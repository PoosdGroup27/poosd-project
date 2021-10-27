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

class ChatController: UIViewController {
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        title = "Chat"
        tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "message"), tag: 2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
