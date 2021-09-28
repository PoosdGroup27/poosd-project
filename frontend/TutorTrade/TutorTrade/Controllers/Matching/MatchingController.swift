//
//  MatchingController.swift
//  TutorTrade
//
//  Serves as the root view controller for the matching page
//  where users can swipe to indicate who they are interested
//  in tutoring
//
//  Created by Sebastian Hernandez on 9/27/21.
//

import UIKit

class MatchingController: UIViewController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Matching"
        tabBarItem = UITabBarItem(title: "Matching", image: UIImage(systemName: "house"), tag: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
