//
//  SettingsViewController.swift
//  ConstableOnPatrol
//
//  Created by Mac on 12/07/24.
//

import UIKit

class SettingsViewController: UIViewController{
    
    @IBOutlet weak var logOutOutlet: UIButton!
    
    let authService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutOutlet.layer.borderColor = UIColor.black.cgColor
        logOutOutlet.layer.borderWidth = 2.0
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
//        
//        // Assuming you have a reference to your window
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let delegate = windowScene.delegate as? SceneDelegate {
//            delegate.window?.rootViewController = signInViewController
//            delegate.window?.makeKeyAndVisible()
//        }
//        
        
        
        
        authService.logOut(phoneNumber: UserData.shared.phoneNumber ?? "+917827139030", context: self)
    }
}
