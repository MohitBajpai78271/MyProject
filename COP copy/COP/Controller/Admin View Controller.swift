//
//  Admin View Controller.swift
//  ConstableOnPatrol
//
//  Created by Mac on 11/07/24.
//

import UIKit
import Alamofire

class AdminViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var searchUserNameTextField: UITextField!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var activeUsers: [ActiveUser] = []
    let session = Alamofire.Session.default
    
    let adminLabel: UILabel = {
        let label = UILabel()
        label.text = "Admin"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        BorderOfTextField()
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(adminLabel)
        view.addSubview(searchButton)
        view.addSubview(searchUserNameTextField)
       
        
        tableView.register( MessageCell.self ,forCellReuseIdentifier: "MessageCell" )/*MessageCell.self, forCellReuseIdentifier: "ReusableCell")*/
        tableView.allowsSelection = true
        tableView.delaysContentTouches = false
        tableView.bounces = false
        
        
        fetchActiveUsers()
        
        // Setup constraints
        setupConstraints()
        
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissMyKeyboaed))
        view.addGestureRecognizer(tapGesture)
        
        
    }
    
    func BorderOfTextField(){
        searchUserNameTextField.layer.borderColor = UIColor.black.cgColor
        searchUserNameTextField.layer.borderWidth = 1.0
        searchUserNameTextField.layer.cornerRadius = 5.0
        searchUserNameTextField.delegate = self
    }
    
    @objc func dismissMyKeyboaed() {
        view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchUserNameTextField.endEditing(true)
        print()
    }
    private func setupConstraints() {
        // Admin label constraints
        NSLayoutConstraint.activate([
            adminLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            adminLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Search text field constraints
        NSLayoutConstraint.activate([
            searchUserNameTextField.topAnchor.constraint(equalTo: adminLabel.bottomAnchor, constant: 20),
            searchUserNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchUserNameTextField.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -10),
            searchUserNameTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // Search button constraints
        searchUserNameTextField.rightView = searchButton
        searchUserNameTextField.rightViewMode = .always
        
        // Set up constraints for searchButton
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.widthAnchor.constraint(equalToConstant: 40),  // Adjust the width as needed
            searchButton.heightAnchor.constraint(equalToConstant: 40), // Adjust the height as needed
        ])
    }
    
    func fetchActiveUsers() {
        fetchActiveUserData { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let activeUsers):
                    print("Received active users data: \(activeUsers)")
                    self?.activeUsers = activeUsers
                    print("Active users count: \(self?.activeUsers.count ?? 0)")
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Failed to fetch active users: \(error)")
                    // Handle error, show alert, etc.
                }
            }
        }
    }
}
func fetchActiveUserData(completion: @escaping (Result<[ActiveUser], Error>) -> Void) {
    let url = "http://93.127.172.217:5000/api/activeUser"
    print(UserData.shared.userRole ?? "No role present")
    
    AF.request(url, method: .get).responseData { response in
        if let data = response.data {
            print("Raw response data: \(String(data: data, encoding: .utf8) ?? "Unable to convert data to string")")
        }
        
        switch response.result {
        case .success(let data):
            do {
                let activeUsers = try JSONDecoder().decode([ActiveUser].self, from: data)
                completion(.success(activeUsers))
            } catch {
                print("JSON decoding failed: \(error)")
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

extension AdminViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell else {
                   return UITableViewCell()
               }
               cell.selectionStyle = .default
               let activeUser = activeUsers[indexPath.row]
               cell.nameLabel.text = activeUser.name
               cell.phoneNumberLabel.text = activeUser.mobileNumber
               cell.placeLabel.text = "Area: \(activeUser.areas.joined(separator: ", "))"
               cell.startTimeLabel.text = "Start Time: \(activeUser.dutyStartTime)"
               cell.endTimeLabel.text = "End Time: \(activeUser.dutyEndTime)"
               
               return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        print("pressed one")
        let selectedUser = activeUsers[indexPath.row]
        fetchUserLocation(phoneNumber: selectedUser.mobileNumber) { [weak self] result in
            print(selectedUser.mobileNumber)
            switch result {
            case .success(let locationData):
                print("Latitude: \(locationData.latitude), Longitude: \(locationData.longitude)")
                self?.showLocationOnMap(locationData: locationData)
                print("show location done")
            case .failure(let error):
                print("Error fetching user location: \(error)")
                // Handle error, show alert, etc.
            }
        }
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func fetchUserLocation(phoneNumber: String, completion: @escaping (Result<LocationOfUser, Error>) -> Void) {
        let url = "http://93.127.172.217:4000/users-location"
        let parameters: [String: Any] = ["phoneNumber": phoneNumber]
   
        session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let locationData = try JSONDecoder().decode(LocationOfUser.self, from: data)
                    completion(.success(locationData))
                } catch {
                    print("Error decoding location data: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("Failed to fetch location data: \(error)")
                completion(.failure(error))
            }
        }
    }
    func showLocationOnMap(locationData: LocationOfUser) {
        print("Location data: \(locationData)")
        self.performSegue(withIdentifier: "segueToLocation", sender: locationData)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToLocation" {
            if let destinationVC = segue.destination as? LocationViewController,
               let locationData = sender as? LocationOfUser {
                destinationVC.locationData = locationData
            }
        }
    }
}
