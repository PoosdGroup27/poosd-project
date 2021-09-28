//
//  RequestController.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 9/27/21.
//

import UIKit

class RequestController: UIViewController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Request"
        tabBarItem = UITabBarItem(title: "Request", image: UIImage(systemName: "hand.raised"), tag: 1)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
