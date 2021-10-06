//
//  RequestController.swift
//  TutorTrade
//
//  Serves as the root view controller for the page
//  where users can creates a request for tutoring
//
//  Created by Sebastian Hernandez on 9/27/21.
//

// TO DO: Create Preferred Mediums using a collectionView
import UIKit

class RequestController: UIViewController {

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        title = "✋ Get Help"
        tabBarItem = UITabBarItem(title: "Request", image: UIImage(systemName: "hand.raised"), tag: 1)
        
        let requestScrollView = RequestScrollView(scrollWidth: self.view.frame.size.width,
                                                                scrollHeight: self.view.frame.size.height - 100)
        
        self.view.addSubview(requestScrollView)
        print(requestScrollView.requestModel!)
    }

    override func loadView() {
        super.loadView()
    }    
}
