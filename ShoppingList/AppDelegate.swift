//
//  AppDelegate.swift
//  ShoppingList
//
//  Created by Eric Alves Brito.
//  Copyright © 2020 FIAP. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        if let _ = Auth.auth().currentUser {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tableViewController = storyboard.instantiateViewController(withIdentifier: "ListTableViewController")
            let navigationController = UINavigationController()
            navigationController.navigationBar.prefersLargeTitles = true
            navigationController.viewControllers = [tableViewController]
            
            window?.rootViewController = navigationController
        }
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        RemoteConfigValues.shared.fetch()
    }
}

