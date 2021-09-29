//
//  RequestController.swift
//  TutorTrade
//
//  Serves as the root view controller for the page
//  where users can creates a request for tutoring
//
//  Created by Sebastian Hernandez on 9/27/21.
//

import UIKit

class RequestController: UIViewController {
    
    let subjectRequestView: UITextField! = {
        let textField = SubjectRequestView()
        return textField
    }()

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        title = "Request"
        tabBarItem = UITabBarItem(title: "Request", image: UIImage(systemName: "hand.raised"), tag: 1)
    }

    override func loadView() {
        super.loadView()
        self.view.addSubview(subjectRequestView)
    }
}
