//
//  ViewController.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 9/11/21.
//

import UIKit

class TutorTradeTabBarController: UITabBarController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let matchingController = MatchingController()
        let requestController = RequestController()
        let chatController = ChatController()
        let profileController = ProfileController()
        
        let matchingNavController = UINavigationController(rootViewController: matchingController)
        let requestNavController = UINavigationController(rootViewController: requestController)
        let chatNavController = UINavigationController(rootViewController: chatController)
        let profileNavController = UINavigationController(rootViewController: profileController)
        
        matchingNavController.navigationBar.prefersLargeTitles = true
        requestNavController.navigationBar.prefersLargeTitles = true
        chatNavController.navigationBar.prefersLargeTitles = true
        profileNavController.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .white

        setViewControllers([matchingNavController, requestNavController, chatNavController, profileNavController], animated: false)
        selectedViewController = matchingNavController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

