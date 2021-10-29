//
//  AppDelegate.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 9/11/21.
//

import UIKit

@main
class TutorTradeApplication: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    private let displaySettingsManager =  DisplaySettingsManager()
    private var tabBarController: UITabBarController? = nil
    private var authFlowController: UINavigationController? = nil

    /**
     Configures the application with window and initial view controllers
     */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        // Creates window the size of the device's screen
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // Sets the window's root VC to the approriate instance
        // depending on user auth status
        loadStartupController()
        
        // Causes the window and its root view controller's view hierachry to
        // become visible to the user
        window!.makeKeyAndVisible()
        
        return true
    }
    
    func loadStartupController() {
        if AuthManager.shared.isLoggedIn {
            
            self.tabBarController = self.tabBarController ?? TutorTradeTabBarController(displaySettings: displaySettingsManager.appDisplaySettings!)
            
            // Creates the tab bar controller and set it as the root controller of the app
            window!.rootViewController = tabBarController
            
        } else {
            self.authFlowController = self.authFlowController ?? AuthFlowNavigationController()
            
            window!.rootViewController = authFlowController
            
            AuthManager.shared.isLoggedIn = true
        }
    }
    
    func logOut() {
        AuthManager.shared.isLoggedIn = false
        loadStartupController()
    }
}
