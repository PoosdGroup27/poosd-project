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
    private lazy var matchesScrollView: UIScrollView = .matchesPageScrollView
    private lazy var matchesStackView: UIStackView = .matchesPageStackView
    private var stackViewHeightAnchor: NSLayoutConstraint!
    private var scrollViewHeightAnchor: NSLayoutConstraint!
    private let matchesManager = MatchesManager()
    private let matchBufferLock = DispatchSemaphore(value: 1)
    private var matchBuffer: [Match] = []
    private let matchesLock = DispatchSemaphore(value: 1)
    private var matches: [MatchView: Match] = [:]
    private var matchesRefreshTimer: Timer!
    private var backgroundOverlay: UIView = .reviewBackgroundOverlay
    private lazy var reviewController = ReviewController(completion: self.dismissReviewController)
    
    private func fillMatchBuffer() {
        DispatchQueue.global(qos: .background).async {
            let matches = self.matchesManager.matches
            if let matches = matches {
                self.matchBufferLock.wait()
                self.matchBuffer = matches
                self.matchBufferLock.signal()
            }
        }
    }

    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "Matches"
        tabBarItem = UITabBarItem(title: "Matches", image: UIImage(named: "MatchesTabBarIcon"), tag: 2)
        self.fillMatchBuffer()
        matchesRefreshTimer = Timer.scheduledTimer(withTimeInterval: 20, repeats: true) { _ in
            self.fillMatchBuffer()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        matchBufferLock.wait()
        matchesLock.wait()
        
        guard matches.count != matchBuffer.count else {
            matchBufferLock.signal()
            matchesLock.signal()
            return
        }
        
        self.matches.keys.forEach {
            self.removeMatchView($0)
        }
        matches = [:]
        matchBuffer.forEach {
            let matchView = MatchView(withProfileImage: $0.tutee.profilePhoto!, withName: $0.tutee.name, withPoints: $0.request.budget, withRating: $0.tutee.rating, withSubject: $0.request.subject, withStatus: $0.status, withRole: $0.role, statusChangeOberserver: self.matchStatusChanged(matchView:status:))
            matches[matchView] = $0
            self.addMatchView(matchView)
        }
        matchesLock.signal()
        matchBufferLock.signal()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(matchesScrollView) {
            self.scrollViewHeightAnchor = $0.contentLayoutGuide.heightAnchor.constraint(equalToConstant: 50)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height / 8),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                $0.contentLayoutGuide.widthAnchor.constraint(equalTo: self.view.widthAnchor),
                $0.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                self.scrollViewHeightAnchor
            ])
        }
        
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
        
        self.matchesScrollView.addSubview(matchesStackView) {
            self.stackViewHeightAnchor = $0.heightAnchor.constraint(equalToConstant: 0)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.matchesScrollView.topAnchor, constant: 20),
                $0.leadingAnchor.constraint(equalTo: self.matchesScrollView.leadingAnchor, constant: 14),
                $0.trailingAnchor.constraint(equalTo: self.matchesScrollView.trailingAnchor, constant: -14),
                self.stackViewHeightAnchor
            ])
        }
        
        self.view.addSubview(self.backgroundOverlay) {
            $0.isHidden = true
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                $0.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        }
    }
    
    private func addMatchView(_ matchView: MatchView) {
        self.stackViewHeightAnchor.constant += 274
        self.scrollViewHeightAnchor.constant += 274
        matchesStackView.insertArrangedSubview(matchView, at: 0)
    }
    
    private func removeMatchView(_ matchView: MatchView) {
        self.stackViewHeightAnchor.constant -= 274
        self.scrollViewHeightAnchor.constant -= 274
        matchesStackView.removeArrangedSubview(matchView)
    }
    
    private func matchStatusChanged(matchView: MatchView, status: TuteeRequestStatus) {
        
        let requestId = matches[matchView]!.request.requestId
        matchesManager.updateMatch(requestId: requestId, toStatus: status)
        
        if status == .chatting {
            UIApplication.shared.open(URL(string: "sms:" + matches[matchView]!.tutee.phoneNumber)!)
        }
        
        if status == .reviewed {
            self.backgroundOverlay.isHidden = false
            self.reviewController.subject = matches[matchView]!.request.subject
            self.reviewController.tutorId = matches[matchView]!.tutee.userId
            self.present(reviewController, animated: true)
        }
    }
    
    private func dismissReviewController() {
        self.backgroundOverlay.isHidden = true
    }
}
