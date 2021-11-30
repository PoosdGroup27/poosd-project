//
//  ReviewController.swift
//  TutorTrade
//
//  Created by brock davis on 11/29/21.
//

import UIKit

internal class ReviewController: UIViewController {
    
    private lazy var popoverView: UIView = .reviewPopover
    private lazy var popoverTitle: UILabel = .reviewPopoverTitle
    private lazy var submitReviewButton: UIButton = .submitReviewButton
    private lazy var reviewStarStackView: UIStackView = .reviewStarStackView
    private lazy var ratingStars: [UIButton] = [.starButton, .starButton, .starButton, .starButton, .starButton]
    private let completionBlock: (() -> ())?
    
    
    var tutorId: String = ""
    var subject: String = ""
    private let reviewManager = ReviewManager()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        true
    }
    
    init(completion: (() -> ())?) {
        self.completionBlock = completion
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = .red
        
        self.view.backgroundColor = .clear
        
        self.view.addSubview(popoverView) {
            NSLayoutConstraint.activate([
                $0.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
                $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.4)
            ])
        }
        
        self.popoverView.addSubview(self.popoverTitle) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.popoverView.topAnchor, constant: 32),
                $0.leadingAnchor.constraint(equalTo: self.popoverView.leadingAnchor, constant: 25)
            ])
        }
        
        self.popoverView.addSubview(reviewStarStackView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.popoverTitle.bottomAnchor, constant: 60),
                $0.centerXAnchor.constraint(equalTo: self.popoverView.centerXAnchor),
                $0.heightAnchor.constraint(equalToConstant: 50),
                $0.widthAnchor.constraint(equalToConstant: 300)
            ])
        }
        
        ratingStars.forEach {
            $0.addTarget(self, action: #selector(self.ratingStarTapped(sender:)), for: .touchUpInside)
            self.reviewStarStackView.addArrangedSubview($0)
        }
        
        self.popoverView.addSubview(submitReviewButton) {
            $0.addTarget(self, action: #selector(self.submitReviewButtonTapped), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.reviewStarStackView.bottomAnchor, constant: 65),
                $0.widthAnchor.constraint(equalTo: self.popoverView.widthAnchor, multiplier: 0.7),
                $0.heightAnchor.constraint(equalToConstant: 50),
                $0.centerXAnchor.constraint(equalTo: self.popoverView.centerXAnchor)
            ])
        }
    }
    
    @objc func submitReviewButtonTapped() {
        
        let rating = ratingStars.reduce(0) { partialResult, star in
            partialResult + ((star.isSelected) ? 1 : 0)
        }
        
        self.reviewManager.addReview(forUserId: self.tutorId, review: Review(rating: rating, subject: self.subject, reviewEvaluation: ""))
        completionBlock?()
        dismiss(animated: true)
    }
    
    @objc func ratingStarTapped(sender: UIButton) {
        let buttonIndex = ratingStars.firstIndex(of: sender)!
        
        for index in 0...buttonIndex {
            ratingStars[index].isSelected = true
        }
        
        for index in (buttonIndex + 1)..<5 {
            ratingStars[index].isSelected = false
        }
    }
}
