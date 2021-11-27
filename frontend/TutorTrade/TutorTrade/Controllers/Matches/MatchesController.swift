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
    private var matchViews: [MatchView] = [
        MatchView(withProfileImage: UIImage(named: "UserImage1")!, withName: "Hannah", withPoints: 150, withRating: 4.9, withSubject: "💻 Computer Science", withStatus: .accepted, withRole: .tutor),
        MatchView(withProfileImage: UIImage(named: "UserImage2")!, withName: "Katie", withPoints: 180, withRating: 4.3, withSubject: "🧬 Biology", withStatus: .chatting, withRole: .tutee),
        MatchView(withProfileImage: UIImage(named: "UserImage3")!, withName: "Adam", withPoints: 120, withRating: 4.1, withSubject: "➕ Mathematics", withStatus: .completed, withRole: .tutor),
        MatchView(withProfileImage: UIImage(named: "UserImage4")!, withName: "Elliot", withPoints: 300, withRating: 3.8, withSubject: "🦖 Archaeology", withStatus: .accepted, withRole: .tutee)
    ]
    private lazy var matchesScrollView: UIScrollView = .matchesPageScrollView
    private lazy var matchesStackView: UIStackView = .matchesPageStackView
    private var stackViewHeightAnchor: NSLayoutConstraint!
    private var scrollViewHeightAnchor: NSLayoutConstraint!
    
    override func viewDidAppear(_ animated: Bool) {
        print(self.scrollViewHeightAnchor.constant)
        print(self.matchesScrollView.contentSize)
    }
    
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
        
        for matchView in matchViews {
            self.addMatchView(matchView)
        }
    }
    
    private func addMatchView(_ matchView: MatchView) {
        self.stackViewHeightAnchor.constant += 274
        self.scrollViewHeightAnchor.constant += 274
        matchesStackView.insertArrangedSubview(matchView, at: 0)
    }
}
