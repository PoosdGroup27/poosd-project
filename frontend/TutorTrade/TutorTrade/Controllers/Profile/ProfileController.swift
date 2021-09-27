//
//  ProfileController.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 9/27/21.
//

import UIKit

class ProfileController: UIViewController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Profile"
        tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
