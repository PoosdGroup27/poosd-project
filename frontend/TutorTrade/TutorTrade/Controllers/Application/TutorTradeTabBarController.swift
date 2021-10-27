//
//  ViewController.swift
//  TutorTrade
//
//  Tab bar controller that comes into existence
//  upon app launch. Serves as a container view controller
//  for the root view controllers that manage each of the pages
//  that users will interact with.
//
//  Created by Sebastian Hernandez on 9/11/21.
//

import UIKit

class TutorTradeTabBarController: UITabBarController {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    init(displaySettings: AppDisplaySettings) {
        // Create VC with default/non-storyboard root view
        super.init(nibName: nil, bundle: nil)
        
        // Initialize tab bar controller's children
        let matchingController = MatchingController()
        let requestController = RequestController()
        let chatController = ChatController()
        let profileController = ProfileController(factory: DefaultProfilePageFactory(imageDrawer: DefaultImageDrawer()), modelManager: DefaultTutorProfileManager(), displaySettings: displaySettings)
        
        // Encapsulate view controllers within Navigation Controllers (Temporary)
        let matchingNavController = UINavigationController(rootViewController: matchingController)
        let requestNavController = UINavigationController(rootViewController: requestController)
        let chatNavController = UINavigationController(rootViewController: chatController)
        
        // Aesthetic preferences
        matchingNavController.navigationBar.prefersLargeTitles = true
        requestNavController.navigationBar.prefersLargeTitles = true
        chatNavController.navigationBar.prefersLargeTitles = true
        
        // Set tab bar color
        view.backgroundColor = .white
        
        // Add child view controllers to tab bar
        viewControllers = [matchingNavController, requestNavController, chatNavController, profileController]

        // Set the initially selected view controller upon app launch
        selectedViewController = matchingNavController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
