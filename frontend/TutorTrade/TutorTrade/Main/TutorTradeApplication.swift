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
        if DefaultAuthManager.shared.isLoggedIn {
            
            var semaphore: DispatchSemaphore?
            if DefaultTutorProfileManager.shared == nil {
                semaphore = DispatchSemaphore(value: 0)
                DefaultTutorProfileManager.loadProfile(withId: DefaultAuthManager.shared.userId!) { success in
                        semaphore!.signal()
                }
            }
            semaphore?.wait()

                
            // Creates the tab bar controller and set it as the root controller of the app
            window!.rootViewController = TutorTradeTabBarController(displaySettings: displaySettingsManager.appDisplaySettings!)
            
        } else {
            self.authFlowController = self.authFlowController ?? UINavigationController(rootViewController: WelcomePageViewController())
            self.authFlowController?.popToRootViewController(animated: false)
            
            window!.rootViewController = authFlowController
        }
    }
    
    func logOut() {
        DefaultAuthManager.shared.logOut()
        loadStartupController()
    }
}
