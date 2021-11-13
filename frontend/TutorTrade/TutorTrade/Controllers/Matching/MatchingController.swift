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
    private lazy var cardScrollView = TutteeRequestCard(withFirstName: "Hannah", withProfilePicture: UIImage(named: "UserImage")!,
                                                        withSchool: "University of Central Florida", withRating: 5.0,
                                                        withSubject: "Mathematics", withTime: "Now",
                                                        withDescription: "I am looking for someone to tutor me in Calc 1. We’re currently covering the product rule in class and I need help working through the process.", withPointBalance: 50, withPreferredMedium: "InPerson")

    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Matching", image: UIImage(systemName: "house"), tag: 0)
        self.view.backgroundColor = UIColor(named: "MatchingPageColor")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        // Add a current no-op  filter button
        self.titleContainerView.addSubview(filterImageButton) {
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),
                $0.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor, constant: (UIScreen.main.bounds.width / 14)  * -1)
            ])
        }
        
        // Load the matching card vertical scroll view
        self.view.addSubview(cardScrollView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.titleContainerView.bottomAnchor),
                $0.leadingAnchor.constraint(equalToSystemSpacingAfter: self.view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
                $0.heightAnchor.constraint(equalToConstant: 525),
                cardScrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 225)
            ])
        }
    }
}
