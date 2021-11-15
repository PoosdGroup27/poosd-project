//
//  ChatController.swift
//  TutorTrade
//
//  Serves as the root view controller for the page
//  where users can chat to set up tutoring with
//  the other users they have matched with
//
//  Created by Sebastian Hernandez on 9/27/21.
//

import UIKit

class MatchesController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Matches"
        tabBarItem = UITabBarItem(title: "Matches", image: UIImage(named: "MatchesTabBarIcon"), tag: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
