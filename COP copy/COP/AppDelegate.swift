//
//  AppDelegate.swift
//  COP
//
//  Created by Mac on 21/07/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
           
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
           
           // Add debug print to check the token
           if let token = UserDefaults.standard.string(forKey: "x-auth-token") {
               print("Token found: \(token)")
               // User is logged in, show TabBarViewController
               let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController")
               window?.rootViewController = tabBarVC
           } else {
               print("No token found, showing SignInViewController")
               // User is not logged in, show SignInViewController
               let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViwController")
               window?.rootViewController = UINavigationController(rootViewController: signInVC)
           }
           
           window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

