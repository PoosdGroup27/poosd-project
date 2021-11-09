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
    
    private lazy var titleContainerView: UIView = .matchingPageTitleContainerView
    private lazy var matchingTitleLogo: UIImageView = .matchingTitleImage
    private lazy var filterImageButton: UIButton = .filterButton
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Matching", image: UIImage(systemName: "house"), tag: 0)
    }
    
    override func loadView() {
        super.loadView()
        
        // Add title container for matching page
        self.view.addSubview(titleContainerView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 5)
            ])
        }
        
        // Add logo for matching page
        self.titleContainerView.addSubview(matchingTitleLogo) {
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),
                $0.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: UIScreen.main.bounds.width / 14)
            ])
        }
        
        // Add a current no op  filter button
        self.titleContainerView.addSubview(filterImageButton) {
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),
                $0.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor, constant: (UIScreen.main.bounds.width / 14)  * -1)
            ])
        }
        
    }
}
