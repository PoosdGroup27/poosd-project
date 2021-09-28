//
//  ProfileController.swift
//  TutorTrade
//
//  Serves as the root view controller for the user's profile page
//
//  Created by Sebastian Hernandez on 9/27/21.
//

import UIKit


class ProfileController: UIViewController {
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        title = "Profile"
        tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
