//
//  AppDelegate.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 9/11/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /**
     Configures the application with window and initial view controllers
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        // Creates window the size of the device's screenq
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Creates the tab bar controller and set it as the root controller of the app
        window!.rootViewController = TutorTradeTabBarController()
        
        // Causes the window and its root view controller's view hierachry to
        // become visible to the user
        window!.makeKeyAndVisible()
        
        return true
    }
}
