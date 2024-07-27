//
//  LocationViewController.swift
//  COP
//
//  Created by Mac on 25/07/24.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var MapView: MKMapView!
    var locationData: LocationOfUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MapView.delegate = self
        if let locationData = locationData {
                   showLocationOnMap(locationData: locationData)
        }else{
            print("No Location data available!")
        }
        }
    func showLocationOnMap(locationData: LocationOfUser) {
        let coordinate = CLLocationCoordinate2D(latitude: locationData.latitude, longitude: locationData.longitude)
        if CLLocationCoordinate2DIsValid(coordinate){
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "User Location"
            MapView.addAnnotation(annotation)
            
            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            MapView.setRegion(region, animated: true)
        }else{
            print("Invalid coordinated : \(coordinate)")
        }
     }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "UserLocation"
        
        if annotation is MKPointAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        
        return nil
    }
    }
    

