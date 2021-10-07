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
    
    let requestScrollView: RequestScrollView! = {
         let scrollView = RequestScrollView(scrollWidth: 390, scrollHeight: 840 - 100)
        return scrollView
    }()
    
    var requestModel: RequestModel! = nil

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        title = "✋ Get Help"
        tabBarItem = UITabBarItem(title: "Request", image: UIImage(systemName: "hand.raised"), tag: 1)
        self.requestModel = RequestModel()
        requestScrollView.requestScrollViewDelegate = self
        self.view.addSubview(requestScrollView)
    }

    override func loadView() {
        super.loadView()
    }
}

extension RequestController: RequestScrollViewDelegate {
    func onTapSubmitButton(subject: String, urgency: Int, description: String, preferredMedium: Int, budget: String) {
        requestModel.subject = subject
        requestModel.urgency = urgency
        requestModel.description = description
        requestModel.preferredMedium = preferredMedium
        requestModel.budget = budget
        
        print(requestModel)
    }
}
