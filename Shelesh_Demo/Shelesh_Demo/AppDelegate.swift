//
//  AppDelegate.swift
//  Shelesh_Demo
//
//  Created by Mac on 3/5/20.
//  Copyright © 2020 SheleshR. All rights reserved.
//

import UIKit
import Reachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let reachability = try! Reachability()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setupNetworkReachability()
            
        
        
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
//MARK:  Other methods
    func setupNetworkReachability(){
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print(">> Reachable via WiFi")
                SharedData.shared.isReachable = true
            } else {
                print(">> Reachable via Cellular")
                SharedData.shared.isReachable = true
            }
        }
        reachability.whenUnreachable = { _ in
            print(">> Not reachable")
            SharedData.shared.isReachable = false
        }

        do {
            try reachability.startNotifier()
        } catch {
            print(">> Unable to start notifier")
        }
    }
}

