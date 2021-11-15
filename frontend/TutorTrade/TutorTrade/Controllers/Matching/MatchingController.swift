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
import Shuffle

class MatchingController: UIViewController, SwipeCardStackDataSource{
    
    private lazy var cardStack = SwipeCardStack()
    private lazy var matchingTitleLogo: UIImageView = .matchingTitleImage
    private lazy var filterImageButton: UIButton = .filterButton
    let cards: [TutteeRequestCard] = [
        .init(withFirstName: "Hannah", withProfilePicture: UIImage(named: "UserImage5")!, withSchool: "University of Central Florida", withRating: 4.7, withSubject: "Mathematics", withTime: "Today", withDescription: "Please help me", withPointBalance: 150, withPreferredMedium: "Online"),
        .init(withFirstName: "Jesse James", withProfilePicture: UIImage(named: "UserImage5")!, withSchool: "Universiy of Florida", withRating: 4.9, withSubject: "Archeology", withTime: "Now", withDescription: "I need help bad", withPointBalance: 180, withPreferredMedium: "InPerson"),
        .init(withFirstName: "Katie Burton", withProfilePicture: UIImage(named: "UserImage5")!, withSchool: "Stanford", withRating: 4.1, withSubject: "Computer Science", withTime: "This Week", withDescription: "Treaps are hell", withPointBalance: 240, withPreferredMedium: "InPerson"),
        .init(withFirstName: "Adam Apple", withProfilePicture: UIImage(named: "UserImage5")!, withSchool: "NYU", withRating: 3.1, withSubject: "IT", withTime: "Now", withDescription: "I might have to switch to business", withPointBalance: 130, withPreferredMedium: "InPerson"),
        .init(withFirstName: "James Jones", withProfilePicture: UIImage(named: "UserImage5")!, withSchool: "Grand Canyon University", withRating: 4.9, withSubject: "Music", withTime: "Now", withDescription: "Help me play the saxaphone", withPointBalance: 380, withPreferredMedium: "InPerson")
    ]

    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Matching", image: UIImage(systemName: "house"), tag: 0)
        self.view.backgroundColor = UIColor(named: "MatchingPageColor")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        5
    }
    
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        if index != 0 {
           print(cards[index - 1].contentSize)
        }
        let card = SwipeCard()
        card.content = cards[index]
        NSLayoutConstraint.activate([
            cards[index].contentLayoutGuide.widthAnchor.constraint(equalTo: card.widthAnchor)
        ])
        card.swipeDirections = [.left, .right]
        return card
    }

    override func loadView() {
        super.loadView()
        
        // Add logo for matching page
        self.view.addSubview(matchingTitleLogo) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.height / 10),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: UIScreen.main.bounds.width / 18.75)
            ])
        }
        
        // Add a current no-op  filter button
        self.view.addSubview(filterImageButton) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.matchingTitleLogo.topAnchor),
                $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -UIScreen.main.bounds.width / 18.75)
            ])
        }
        
        self.view.addSubview(cardStack) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.dataSource = self
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.matchingTitleLogo.bottomAnchor, constant: UIScreen.main.bounds.height / 35),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                $0.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -UIScreen.main.bounds.height / 35)
            ])
        }
    }
}
