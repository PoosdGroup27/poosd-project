//
//  ChatController.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 9/27/21.
//

import UIKit

class ChatController: UIViewController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Chat"
        tabBarItem = UITabBarItem(title: "Chat", image: UIImage(systemName: "message"), tag: 2)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
