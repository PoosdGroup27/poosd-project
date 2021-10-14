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
    
    // Declare and initialize scroll view
    let requestScrollView: RequestScrollView! = {
        let scrollView = RequestScrollView(scrollWidth: 390, scrollHeight: 840 - 100)
        return scrollView
    }()
    
    // Declare request model
    var requestModel: RequestModel?
    var requestManager: RequestManager?

    convenience init() {
        // Style VC
        self.init(nibName: nil, bundle: nil)
        title = "✋ Get Help"
        tabBarItem = UITabBarItem(title: "Request", image: UIImage(systemName: "hand.raised"), tag: 1)
        
        // Create request model
        self.requestModel = RequestModel()
        
        // Add delegate
        requestScrollView.requestScrollViewDelegate = self
        
        // Add scrollview as a subview
        self.view.addSubview(requestScrollView)
    }

    override func loadView() {
        super.loadView()
    }
    
    // Function that handles sending RequestModel to API
    func createRequestManager(requestModel: RequestModel) {
        requestManager = RequestManager(requestModel: requestModel)
    }
}

extension RequestController: RequestScrollViewDelegate {
    func onTapSubmitButton(subject: String, urgency: String, description: String, preferredMedium: String, budget: String) {
        requestModel?.subject = subject
        requestModel?.urgency = urgency
        requestModel?.description = description
        requestModel?.platform = preferredMedium
        requestModel?.costInPoints = budget

        // Send the requestModel to backend
        createRequestManager(requestModel: requestModel!)
    }
}
