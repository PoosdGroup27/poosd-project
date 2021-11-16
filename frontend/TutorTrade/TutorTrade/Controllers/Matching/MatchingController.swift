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

class MatchingController: UIViewController, SwipeCardStackDataSource, SwipeCardStackDelegate, UIScrollViewDelegate {
    
    private lazy var cardStack = SwipeCardStack()
    private lazy var matchingTitleLogo: UIImageView = .matchingTitleImage
    private lazy var undoButton: UIButton = .undoButton
    private lazy var hapticGenerator = UINotificationFeedbackGenerator()
    
    let cards: [TutteeRequestCard] = [
        .init(withName: "Hannah", withProfilePicture: UIImage(named: "UserImage1")!.resizedTo(CGSize(width: 350, height: 350)), withSchool: "University of Central Florida", withRating: 4.7, withSubject: "Mathematics", withUrgency: .today, withDescription: "Please help me", withPointsBudget: 150, withPreferredMedium: .online),
        .init(withName: "Jesse James", withProfilePicture: UIImage(named: "UserImage4")!.resizedTo(CGSize(width: 350, height: 350)), withSchool: "Universiy of Florida", withRating: 4.9, withSubject: "Archeology", withUrgency: .today, withDescription: "I need help bad", withPointsBudget: 180, withPreferredMedium: .inPerson),
        .init(withName: "Katie Burton", withProfilePicture: UIImage(named: "UserImage12")?.resizedTo(CGSize(width: 350, height: 350)), withSchool: "Stanford", withRating: 4.1, withSubject: "Computer Science", withUrgency: .thisWeek, withDescription: "Treaps are hell", withPointsBudget: 240, withPreferredMedium: .inPerson),
        .init(withName: "Adam Apple", withProfilePicture: UIImage(named: "UserImage3")!.resizedTo(CGSize(width: 350, height: 350)), withSchool: "NYU", withRating: 3.1, withSubject: "IT", withUrgency: .tommorow, withDescription: "I might have to switch to business", withPointsBudget: 130, withPreferredMedium: .inPerson),
        .init(withName: "James Jones", withProfilePicture: UIImage(named: "UserImage5")!.resizedTo(CGSize(width: 350, height: 350)), withSchool: "Grand Canyon University", withRating: 4.9, withSubject: "Music", withUrgency: .today, withDescription: "Help me play the saxaphone", withPointsBudget: 380, withPreferredMedium: .inPerson)
    ]

    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Matching", image: UIImage(systemName: "house"), tag: 0)
        self.view.backgroundColor = UIColor(named: "MatchingPageColor")
        self.hapticGenerator.prepare()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Informs the card stack how many times it should call cardStack(:cardForIndexAt:)
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Gives the system time to initialize the taptic engine
        hapticGenerator.prepare()
    }
    
    // Allows user to undo previous swipe
    @objc func undoButtonTapped() {
        self.cardStack.undoLastSwipe(animated: false)
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        // Send haptic feedback to user upon match
        if direction == .right {
            hapticGenerator.notificationOccurred(.success)
        }
    }
    
    // Called by the card stack to retreive the card to display at a given index
    func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        let card = SwipeCard()
        
        // Yes/No overlays whose opacity is animated in response to user swipe gesture
        let rightOverlay = UILabel.yesOverlayLabel
        let leftOverlay = UILabel.noOverlayLabel
        card.setOverlays([.right: rightOverlay, .left: leftOverlay])
        
        // Position and size left overlay
        NSLayoutConstraint.activate([
            leftOverlay.topAnchor.constraint(equalTo: card.topAnchor, constant: 60),
            leftOverlay.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 50),
            leftOverlay.widthAnchor.constraint(equalToConstant: leftOverlay.intrinsicContentSize.width * 3),
            leftOverlay.heightAnchor.constraint(equalToConstant: leftOverlay.intrinsicContentSize.height * 2)
            
        ])
        // Position and size right overlay
        NSLayoutConstraint.activate([
            rightOverlay.topAnchor.constraint(equalTo: card.topAnchor, constant: 60),
            rightOverlay.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -50),
            rightOverlay.widthAnchor.constraint(equalToConstant: rightOverlay.intrinsicContentSize.width * 3),
            rightOverlay.heightAnchor.constraint(equalToConstant: rightOverlay.intrinsicContentSize.height * 2)
            
        ])
        // Set the card's content to the corresponding tuteeScrollView
        card.content = cards[index]
        // Set self as scrollView delegate to modify bouncing behavior
        cards[index].delegate = self
        
        // Set up size + position + content constaints on tuteeScrollView
        NSLayoutConstraint.activate([
            cards[index].topAnchor.constraint(equalTo: card.topAnchor),
            cards[index].bottomAnchor.constraint(equalTo: card.bottomAnchor),
            cards[index].leadingAnchor.constraint(equalTo: card.leadingAnchor),
            cards[index].trailingAnchor.constraint(equalTo: card.trailingAnchor),
            cards[index].contentLayoutGuide.widthAnchor.constraint(equalTo: card.widthAnchor)
        ])
        // User can only swipe left for NO and right for YES
        card.swipeDirections = [.left, .right]
        return card
    }
    
    // Eliminates bouncing behavior on top of scroll view, but retains it on the bottom
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = scrollView.contentOffset.y >= 50
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
        
        // Add undo button to go back to the previous card
        self.view.addSubview(undoButton) {
            $0.addTarget(self, action: #selector(self.undoButtonTapped), for: .touchUpInside)
    
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.matchingTitleLogo.topAnchor),
                $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25),
                $0.heightAnchor.constraint(equalToConstant: 30),
                $0.widthAnchor.constraint(equalToConstant: 30)
            ])
        }
        
        self.view.addSubview(cardStack) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.dataSource = self
            $0.delegate = self

            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.matchingTitleLogo.bottomAnchor, constant: UIScreen.main.bounds.height / 35),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
                $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
                $0.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -5)
            ])
        }
    }
}
