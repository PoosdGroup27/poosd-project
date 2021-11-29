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
    private lazy var noRequestsRemainingView: UIView = NoRemainingRequestCardsView()
    private lazy var hapticGenerator = UINotificationFeedbackGenerator()
    private lazy var matchingManager = MatchingManager()
    private var availableRequests: [CompleteTuteeRequest]!
    private var cardRefreshTimer: Timer!

    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.cardRefreshTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            DispatchQueue.main.async(qos: .background) {
                if self.cardStack.window == nil {
                    self.availableRequests = self.matchingManager.matchedRequests
                    self.cardStack.removeFromSuperview()
                    self.cardStack = SwipeCardStack()
                    self.addCardStackToInferface()
                }
            }
        }
        tabBarItem = UITabBarItem(title: "Matching", image: UIImage(systemName: "house"), tag: 0)
        self.view.backgroundColor = UIColor(named: "MatchingPageColor")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Informs the card stack how many times it should call cardStack(:cardForIndexAt:)
    func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        return availableRequests.count
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
    
    func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
        matchingManager.unmatchWith(requestId: availableRequests[index].request.requestId)
    }
    
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        if direction == .right {
            // Send haptic feedback to user upon match
            hapticGenerator.notificationOccurred(.success)
            matchingManager.matchWith(requestId: availableRequests[index].request.requestId)
        } else {
            matchingManager.declineMatchWith(requestId: availableRequests[index].request.requestId)
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
        let tuteeRequestCard = buildCard(atIndex: index)
        card.content = tuteeRequestCard
        // Set self as scrollView delegate to modify bouncing behavior
        tuteeRequestCard.delegate = self
        
        // Set up size + position + content constaints on tuteeScrollView
        NSLayoutConstraint.activate([
            tuteeRequestCard.topAnchor.constraint(equalTo: card.topAnchor),
            tuteeRequestCard.bottomAnchor.constraint(equalTo: card.bottomAnchor),
            tuteeRequestCard.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            tuteeRequestCard.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            tuteeRequestCard.contentLayoutGuide.widthAnchor.constraint(equalTo: card.widthAnchor)
        ])
        // User can only swipe left for NO and right for YES
        card.swipeDirections = [.left, .right]
        return card
    }
    
    private func buildCard(atIndex index: Int) -> TutteeRequestCard {
        let tuteeRequest = availableRequests[index]
        let card = TutteeRequestCard(withName: tuteeRequest.tutee.name, withProfilePicture: tuteeRequest.tutee.profilePhoto, withSchool: tuteeRequest.tutee.school, withRating: tuteeRequest.tutee.rating, withSubject: String(tuteeRequest.request.subject.dropFirst()), withUrgency: tuteeRequest.request.urgency, withDescription: tuteeRequest.request.description, withPointsBudget: tuteeRequest.request.budget, withPreferredMedium: tuteeRequest.request.preferredMedium)
        return card
    }
    
    // Eliminates bouncing behavior on top of scroll view, but retains it on the bottom
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.bounces = scrollView.contentOffset.y >= 50
    }

    override func loadView() {
        super.loadView()
        
        availableRequests = matchingManager.matchedRequests
        
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
        
        self.view.addSubview(noRequestsRemainingView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.matchingTitleLogo.bottomAnchor, constant: UIScreen.main.bounds.height / 6.6),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 75),
                $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -75),
                $0.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
            ])
        }
        
        self.addCardStackToInferface()
    }
    
    private func addCardStackToInferface() {
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
