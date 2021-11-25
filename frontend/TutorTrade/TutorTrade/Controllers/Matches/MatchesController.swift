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
    
    private lazy var titleContainer: UIView = .matchesTitleContainer
    private lazy var pageTitleGraphic: UIImageView = .matchesImageView
    private lazy var pageTitle: UILabel = .matchesPageTitle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Matches"
        tabBarItem = UITabBarItem(title: "Matches", image: UIImage(named: "MatchesTabBarIcon"), tag: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(titleContainer) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 8)
            ])
        }
        
        self.titleContainer.addSubview(pageTitleGraphic) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: self.titleContainer.leadingAnchor, constant: UIScreen.main.bounds.width / 15),
                $0.topAnchor.constraint(equalTo: self.titleContainer.topAnchor, constant: UIScreen.main.bounds.height / 40)
            ])
        }
        
        self.titleContainer.addSubview(pageTitle) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: pageTitleGraphic.trailingAnchor, constant: 6),
                $0.centerYAnchor.constraint(equalTo: pageTitleGraphic.centerYAnchor)
            ])
        }
    }
}
