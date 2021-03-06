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
        let requestController = HelpController(withBalance: 180)
        let matchesController = MatchesController()
        let profileController = ProfileController(displaySettings: displaySettings)
        
        // Set tab bar color
        view.backgroundColor = .white
        
        // Set the tab bar to always be white
        tabBar.isTranslucent = false
        
        viewControllers = [matchingController, requestController, matchesController, profileController]

        // Set the initially selected view controller upon app launch
        selectedViewController = matchingController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

