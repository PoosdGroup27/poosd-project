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
        
        let startupController: UIViewController
        
        if DefaultAuthManager.shared.isLoggedIn {
            if DefaultTutorProfileManager.shared != nil || self.loadTutorProfile() {
                startupController = TutorTradeTabBarController(displaySettings: displaySettingsManager.appDisplaySettings!)
            } else {
                let createProfileController = UINavigationController(rootViewController: CreateProfileController())
                createProfileController.setNavigationBarHidden(true, animated: false)
                startupController = createProfileController
            }
        } else {
            let authFlowController = UINavigationController(rootViewController: WelcomePageViewController())
            authFlowController.setNavigationBarHidden(true, animated: false)
            startupController = authFlowController
        }
        
        self.window!.rootViewController = startupController
    }
    
    func logOut() {
        DefaultAuthManager.shared.logOut()
        DefaultTutorProfileManager.shared?.logOut()
        loadStartupController()
    }
    
    
    private func loadTutorProfile() -> Bool {
        var wasLoaded: Bool = false
        let semaphore = DispatchSemaphore(value: 0)
        DefaultTutorProfileManager.loadProfile(withId: DefaultAuthManager.shared.userId!) { success in
                wasLoaded = success
                semaphore.signal()
        }
        semaphore.wait()
        return wasLoaded
    }
}
