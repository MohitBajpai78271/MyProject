//
//  ApiMapsViewController.swift
//  ConstableOnPatrol
//
//  Created by Mac on 11/07/24.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class ApiMapsViewController: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var policeStationLabel: UILabel!
    @IBOutlet weak var policeStationButton: dropDownButton!
    @IBOutlet weak var crimTypeLabel: UILabel!
    @IBOutlet weak var criimeTypeButton: dropDownButton!
    
    var tapGesture : UITapGestureRecognizer!
    
    @IBOutlet weak var dateText: UILabel!
    var crimes: [Crime] = []
    
    var datePicker: UIDatePicker!
    private var transparentView : UIView?
    
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    
    var hasCentredOnUser = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        criimeTypeButton.delegate = self
        policeStationButton.delegate = self
        
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        
        underLinetexts()
        
        setupMapView()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        criimeTypeButton.options = CrimesAndPoliceStations.crimeType
        policeStationButton.options = CrimesAndPoliceStations.policeStationPlace
        
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
//        let date: String = dateText.text ?? "No date selectd"
        fetchCrimeData(selectedDate: nil)
    }
    
    func setupMapView() {
        mapView.delegate = self
        // Set initial location to somewhere in Delhi
        let initialLocation = CLLocationCoordinate2D(latitude: 28.748633, longitude: 77.114327)
        mapView.setRegion(MKCoordinateRegion(center: initialLocation, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
    }
    
    
    //MARK: - UnderLine Texts
    
    func underLinetexts(){
        
        let labelTextCrime = crimTypeLabel.text ?? "All"
        let labelTextPoliceStation = policeStationLabel.text ?? "All"
        
        let labelCrime = crimTypeLabel
        let labelPoliceStation = policeStationLabel
        
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedStringCrime = NSAttributedString(string: labelTextCrime, attributes: underlineAttribute)
        let attributedStringpoliceStation = NSAttributedString(string: labelTextPoliceStation, attributes: underlineAttribute)
        
        labelCrime?.attributedText = attributedStringCrime
        labelPoliceStation?.attributedText = attributedStringpoliceStation
        
    }
    
    //MARK: - Calender Popped
    
    @IBAction func calenderButtonPressed(_ sender: UIButton) {
        
             let alertController = UIAlertController(title: "Select Date", message: nil, preferredStyle: .alert)
                alertController.view.addSubview(datePicker)
                
                alertController.addAction(UIAlertAction(title: "Reset", style: .cancel) { [weak self] _ in
                    guard let self = self else { return }
                    self.dateText.text = "No date selected"
                    self.datePicker.date = Date()
                    self.fetchCrimeData(selectedDate: nil)
                })
                
                alertController.addAction(UIAlertAction(title: "Done", style: .default) { [weak self] _ in
                    guard let self = self else { return }
                    let selectedDate = self.datePicker.date
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let formattedDate = dateFormatter.string(from: selectedDate)
                    self.dateText.text = formattedDate
                    self.fetchCrimeData(selectedDate: formattedDate)
                })
                
                present(alertController, animated: true) { [weak self] in
                    guard let self = self else { return }
                    self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
                    alertController.view.superview?.addGestureRecognizer(self.tapGesture!)
                }
    }
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
        if let tapGesture = tapGesture{
            self.view.window?.removeGestureRecognizer(tapGesture)
        }
    }
    
    //MARK: - FetchCrimeData and Add Annotation
    
    func fetchCrimeData(selectedDate: String?) {
        let place = policeStationLabel.text ?? "All"
        let crimeType = crimTypeLabel.text ?? "All"

        // Prepare parameters based on current filters
        var parameters: [String: String] = [:]
        if let date = selectedDate, date != "No date selected" {
            parameters["date"] = date
        }
        if place != "All" {
            parameters["place"] = place
        }
        if crimeType != "All" {
            parameters["crimeType"] = crimeType
        }

        // Construct URL with parameters
        var components = URLComponents(string: "http://93.127.172.217:4000/view-data/crimedata")!
        components.queryItems = parameters.isEmpty ? nil : parameters.map { URLQueryItem(name: $0.key, value: $0.value) }

        guard let apiUrl = components.url else {
            print("Invalid URL")
            return
        }

        // Make API request with Alamofire
        AF.request(apiUrl, parameters: parameters).responseDecodable(of: [Crime].self) { response in
            switch response.result {
            case .success(let crimes):
                self.crimes = crimes
                print("Fetched crimes: ")
//                for crime in crimes {
//                    print("Crime: \(crime.crimeType) on \(crime.date) at \(crime.beat)")
//                }

                // Filter the fetched crimes based on date, place, and crime type
                let filteredCrimes = crimes.filter { crime in
                             let crimeTypeFromAPI = crime.crimeType.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                             let filteredCrimeType = crimeType.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

                             let matchDate = selectedDate == nil || crime.date == selectedDate
                             let matchPlace = place == "All" || crime.beat == place
                             let matchCrimeType = filteredCrimeType == "all" || crimeTypeFromAPI == filteredCrimeType
                             
                             // Debug output
//                             print("Crime type from API: \(crime.crimeType)")
//                             print("Filtered crime type: \(crimeType)")
//                             print("Trimmed and lowercased crime type from API: \(crimeTypeFromAPI)")
//                             print("Trimmed and lowercased filtered crime type: \(filteredCrimeType)")
//                             print("matchDate: \(matchDate), matchPlace: \(matchPlace), matchCrimeType: \(matchCrimeType)")
                             
                             return matchDate && matchPlace && matchCrimeType
                         }
                DispatchQueue.main.async {
                    self.addCrimeAnnotations(crimes: filteredCrimes)
                }
            case .failure(let error):
                if let data = response.data {
                    _ = String(data: data, encoding: .utf8) ?? "Unknown error"
                    print("Request failed with error: \(error.localizedDescription), server message: ")
                } else {
                    print("Request failed with error: \(error.localizedDescription)")
                }
                if let response = response.response {
                    print("Network response code: \(response.statusCode)")
                }
            }
        }
    }
    
    func addCrimeAnnotations(crimes : [Crime]) {
        mapView.removeAnnotations(mapView.annotations)
        
        for crime in crimes {
            guard let latitude = Double(crime.latitude), let longitude = Double(crime.longitude) else {
                       print("Invalid coordinates for crime: \(crime)")
                       continue
                   }
              let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
              let annotation = MKPointAnnotation()
              annotation.coordinate = coordinate
              annotation.title = crime.crimeType
              annotation.subtitle = "\(crime.date) - \(crime.beat)"
              mapView.addAnnotation(annotation)
          }
        }
    }

//MARK: - DropDown Button

extension ApiMapsViewController: dropDownButtonDelegate{
    
    func dropDownButtonShowOptions(_ button: dropDownButton, alertController: UIAlertController) {
        if let rootViewController = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene})
            .flatMap({$0.windows})
            .first(where: { $0.isKeyWindow })?.rootViewController{
            rootViewController.present(alertController, animated: true,completion: nil)
        }
        present(alertController,animated: true,completion: nil)
    }
    
    func dropDownButtonShowOptions(_ button: dropDownButton) {
        print("show option")
    }
    
    func dropDownButtonHideOptions(_ button: dropDownButton) {
        print("hide option")
    }
    
    func dropDownButton(_ button: dropDownButton, didSelectOption option: String) {
        if button == criimeTypeButton{
            crimTypeLabel.text = option
        }else if button == policeStationButton{
            policeStationLabel.text = option
        }
        let date : String? = dateText.text == "No date selected" ? nil : dateText.text
        fetchCrimeData(selectedDate: date)
    }

}

//MARK: - CLLocation Manager

extension ApiMapsViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
//            print("updated locn : \(location.coordinate.latitude) and \(location.coordinate.longitude)")
            if !hasCentredOnUser {
                mapView.setRegion(MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)), animated: true)
                hasCentredOnUser = true
            }
        }
       }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access was restricted")
//            let alert = UIAlertController(title: "Location Access Denied", message: "Location access is required to show crime markers on the map. Please enable location services in settings.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//            self.present(alert, animated: true,completion: nil)
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
     func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Location manager did fail with error : \(error.localizedDescription)")
    }
}

//MARK: - MKMapView

extension ApiMapsViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? MKPointAnnotation else {
                return nil
            }
        let identifier = "CrimeAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView

        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        if let crimeType = annotation.title {   // let title = annotation.title,
                
                switch crimeType {
                    
                case "BURGLARY":
                    annotationView?.markerTintColor = .red
                case "MV THEFT":
                    annotationView?.markerTintColor = .orange
                case "SNATCHING":
                    annotationView?.markerTintColor = .purple
                case "HOUSE THEFT":
                    annotationView?.markerTintColor = .green
                case "ROBBERY":
                    annotationView?.markerTintColor = .blue
                default:
                    annotationView?.markerTintColor = .yellow
                }
            }
            
            
            return annotationView
        }
        
        //    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //        if let location = locations.last{
        //            //            print("\(location.coordinate.latitude) and \(location.coordinate.longitude)")
        //            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        //            mapView.setRegion(region, animated: true)
        //        }
        //    }
        
    }

