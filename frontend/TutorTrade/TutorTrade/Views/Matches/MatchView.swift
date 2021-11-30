//
//  Match.swift
//  TutorTrade
//
//  Created by brock davis on 11/24/21.
//

import UIKit

class MatchView: UIView {
    
    var profileImage: UIImage {
        get {
            self.profileImageView.image!
        }
    }

    var name: String {
        get {
            self.nameLabel.text!
        }
    }

    var points: Int {
        get {
            Int(self.pointsLabel.text!.filter { "0123456789".contains($0) })!
        }
    }

    var rating: Double {
        get {
            Double(self.ratingLabel.text!)!
        }
    }

    var subject: String {
        get {
            self.subjectLabel.text!
        }
    }
    
    private let optionsButton: UIButton = .matchOptionsButton
    private let nameBox: BorderedDisplayBoxView = .matchDisplayBox(boxType: .nameBox)
    private let pointsBox: BorderedDisplayBoxView = .matchDisplayBox(boxType: .pointsBox)
    private let ratingBox: BorderedDisplayBoxView = .matchDisplayBox(boxType: .ratingBox)
    private let subjectBox: BorderedDisplayBoxView = .matchDisplayBox(boxType: .subjectBox)
    private let lineView: UIView = .matchLineSeperator
    private let actionButtons: [UIButton] = [.actionItemButton, .actionItemButton, .actionItemButton]
    private let actionButtonsScrollView: UIScrollView = .matchActionButtonsScrollView
    private let actionSelectionButtons: [UIButton] = [.matchActionSelectionButton, .matchActionSelectionButton, .matchActionSelectionButton]
    private let actionSelectionButtonStackView: UIStackView = .matchActionSelectionButtonStackView
    private let actionButtonSize = CGSize(width: UIScreen.main.bounds.width / 1.838, height: UIScreen.main.bounds.height / 19.333)
    private let actionButtonSelectionSize = CGSize(width: UIScreen.main.bounds.width / 46.875, height: UIScreen.main.bounds.width / 46.875)
    private lazy var matchReviewedBox: BorderedDisplayBoxView = .matchReviewedBox
    private lazy var matchReviewedBoxLabel: UILabel = .matchReviewedBoxLabel
    private let statusChangeOberserver: ((MatchView, TuteeRequestStatus) -> ())?
    private var status: TuteeRequestStatus {
        didSet {
            self.scrollToSelectedIndex()
            statusChangeOberserver?(self, status)
        }
    }
    
    private let profileImageView: UIImageView
    private let nameLabel: UILabel
    private let pointsLabel: UILabel
    private let ratingLabel: UILabel
    private let subjectLabel: UILabel
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    init(withProfileImage profileImage: UIImage, withName name: String, withPoints points: Int, withRating rating: Double, withSubject subject: String, withStatus status: TuteeRequestStatus, withRole role: RequestRole, statusChangeOberserver: ((MatchView, TuteeRequestStatus) -> ())?) {
        
        let imageSize = CGSize(width: UIScreen.main.bounds.width / 4.076, height: UIScreen.main.bounds.height / 7.185)
        self.profileImageView = .matchProfileImage(withProfilePic: profileImage.resizedTo(imageSize))
        self.nameLabel = .matchBoxLabel(withText: name, withFontSize: UIScreen.main.bounds.width / 25)
        self.status = status
        self.statusChangeOberserver = statusChangeOberserver
        
        let selectedIndex: Int = {
            switch status {
            case .accepted:
                return 0
            case .chatting:
                return 1
            case .completed:
                return 2
            default:
                return 0
            }
        }()
        
        let (pointsText, pointsBoxColor): (String, UIColor) = {
            switch role {
            case .tutor:
                return ("+" + String(points), UIColor(named: "AdditivePointsBoxColor")!)
            case .tutee:
                return ("-" + String(points), UIColor(named: "NegativePointsBoxColor")!)
            }
        }()
        self.pointsLabel = .matchBoxLabel(withText: pointsText, withFontSize: UIScreen.main.bounds.width / 31.25)
        self.pointsBox.boxBackgroundColor = pointsBoxColor
        
        self.ratingLabel = .matchBoxLabel(withText: String(rating), withFontSize: UIScreen.main.bounds.width / 31.25)
        self.subjectLabel = .matchBoxLabel(withText: subject, withFontSize: UIScreen.main.bounds.width / 31.25)
        
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 10
        self.layer.shadowOffset = CGSize(width: 2, height: 4)
        self.layer.shadowOpacity = 0.17
        
        self.addSubview(self.optionsButton) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.topAnchor, constant: UIScreen.main.bounds.height / 101.25),
                $0.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
        }
        
        self.addSubview(self.profileImageView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.topAnchor, constant: UIScreen.main.bounds.height / 26.19),
                $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIScreen.main.bounds.width / 25)
            ])
        }
        
        self.addSubview(self.nameBox) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.profileImageView.topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: UIScreen.main.bounds.width / 25),
                $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIScreen.main.bounds.width / 6.434),
                $0.heightAnchor.constraint(equalToConstant: self.nameLabel.intrinsicContentSize.height * 1.7)
    
            ])
        }
        
        self.nameBox.addSubview(self.nameLabel) {
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: self.nameBox.centerYAnchor),
                $0.leadingAnchor.constraint(equalTo: self.nameBox.leadingAnchor, constant: UIScreen.main.bounds.width / 30.5)
            ])
        }
        
        self.addSubview(self.pointsBox) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: self.nameBox.leadingAnchor),
                $0.heightAnchor.constraint(equalToConstant: self.pointsLabel.intrinsicContentSize.height * 2),
                $0.topAnchor.constraint(equalTo: self.nameBox.bottomAnchor, constant: UIScreen.main.bounds.height / 67.666),
                $0.widthAnchor.constraint(equalToConstant: self.pointsLabel.intrinsicContentSize.width * 2 + 30)
            ])
        }
        
        self.pointsBox.addSubview(self.pointsLabel) {
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: self.pointsBox.centerYAnchor),
                $0.leadingAnchor.constraint(equalTo: self.pointsBox.leadingAnchor, constant: UIScreen.main.bounds.width / 37.5 + 27)
            ])
        }
        
        self.addSubview(self.ratingBox) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: self.pointsBox.trailingAnchor, constant: UIScreen.main.bounds.width / 41.66),
                $0.topAnchor.constraint(equalTo: self.pointsBox.topAnchor),
                $0.heightAnchor.constraint(equalTo: self.pointsBox.heightAnchor),
                $0.widthAnchor.constraint(equalToConstant: self.ratingLabel.intrinsicContentSize.width * 2 + 40)
            ])
        }
        
        self.ratingBox.addSubview(self.ratingLabel) {
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: self.ratingBox.centerYAnchor),
                $0.leadingAnchor.constraint(equalTo: self.ratingBox.leadingAnchor, constant: UIScreen.main.bounds.width / 37.5 + 25)
            ])
        }
        
        self.addSubview(self.subjectBox) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.pointsBox.bottomAnchor, constant: UIScreen.main.bounds.height / 67.666),
                $0.leadingAnchor.constraint(equalTo: self.pointsBox.leadingAnchor),
                $0.heightAnchor.constraint(equalToConstant: self.ratingLabel.intrinsicContentSize.height * 2.3),
                $0.widthAnchor.constraint(equalToConstant: self.subjectLabel.intrinsicContentSize.width * 1.5)
            ])
        }
        
        self.subjectBox.addSubview(self.subjectLabel) {
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: self.subjectBox.centerYAnchor),
                $0.leadingAnchor.constraint(equalTo: self.subjectBox.leadingAnchor, constant: UIScreen.main.bounds.width / 30.5)
            ])
        }
        
        self.addSubview(self.lineView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.profileImageView.bottomAnchor, constant: 12),
                $0.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: UIScreen.main.bounds.width / 25),
                $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIScreen.main.bounds.width / 25),
                $0.heightAnchor.constraint(equalToConstant: 0.75)
            ])
        }
        
        if status != .reviewed {
        
            self.addSubview(self.actionButtonsScrollView) {
                NSLayoutConstraint.activate([
                    $0.topAnchor.constraint(equalTo: self.lineView.bottomAnchor, constant: 12),
                    $0.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    $0.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                    $0.heightAnchor.constraint(equalToConstant: actionButtonSize.height * 1.2),
                    $0.contentLayoutGuide.heightAnchor.constraint(equalToConstant: actionButtonSize.height),
                    $0.contentLayoutGuide.widthAnchor.constraint(equalToConstant: ((UIScreen.main.bounds.center.x / 2.5) * 4) + (actionButtonSize.width * 3))
                ])
            }
            
            var previousActionButton: UIButton?
            for (index, actionButton) in actionButtons.enumerated() {
                let (matchAction, actionText, actionMethod): (MatchAction, String, Selector) = {
                   switch index {
                   case 0:
                       return (.message, "Message", #selector(self.messageButtonTapped))
                   case 1:
                       return (.markAsComplete, "Mark as complete", #selector(self.markAsCompleteButtonTapped))
                   default:
                       return (.review, "Review", #selector(self.reviewButtonTapped))
                   }
                }()
                actionButton.setTitle(actionText, for: .normal)
                actionButton.setBackgroundImage(.matchActionBackgroundImage(forAction: matchAction, size: actionButtonSize), for: .normal)
                actionButton.addTarget(self, action: actionMethod, for: .touchUpInside)
                
                if index == 1 {
                    actionButton.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(self.userSwipedRightOnCompleteButton)))
                }
                
                self.actionButtonsScrollView.addSubview(actionButton) {
                    NSLayoutConstraint.activate([
                        $0.topAnchor.constraint(equalTo: self.actionButtonsScrollView.topAnchor),
                        $0.leadingAnchor.constraint(equalTo: (previousActionButton != nil) ? previousActionButton!.trailingAnchor : self.actionButtonsScrollView.leadingAnchor, constant: UIScreen.main.bounds.center.x / 2.5)
                    ])
                }
                previousActionButton = actionButton
            }

            
            for (index, actionSelectionButton) in actionSelectionButtons.enumerated() {
                let isSelected = index == selectedIndex
                actionSelectionButton.setBackgroundImage(.matchActionSelectionButton(isSelected: isSelected, size: actionButtonSelectionSize), for: .normal)
                actionSelectionButtonStackView.addArrangedSubview(actionSelectionButton)
                actionSelectionButton.isSelected = isSelected
            }
            
            let actionSelectionButtonSpacing = UIScreen.main.bounds.width / 28.846
            
            self.addSubview(actionSelectionButtonStackView) {
                NSLayoutConstraint.activate([
                    $0.widthAnchor.constraint(equalToConstant: actionButtonSelectionSize.width * 3 + actionSelectionButtonSpacing * 2),
                    $0.topAnchor.constraint(equalTo: self.actionButtonsScrollView.bottomAnchor, constant: UIScreen.main.bounds.height / 60),
                    $0.heightAnchor.constraint(equalToConstant: actionButtonSelectionSize.height),
                    $0.centerXAnchor.constraint(equalTo: self.centerXAnchor)
                ])
            }
        } else {
            self.addSubview(self.matchReviewedBox) {
                NSLayoutConstraint.activate([
                    $0.topAnchor.constraint(equalTo: self.lineView.bottomAnchor, constant: 20),
                    $0.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                    $0.widthAnchor.constraint(equalToConstant: self.actionButtonSize.width),
                    $0.heightAnchor.constraint(equalToConstant: self.actionButtonSize.height)
                ])
            }
            
            self.matchReviewedBox.addSubview(self.matchReviewedBoxLabel) {
                NSLayoutConstraint.activate([
                    $0.centerYAnchor.constraint(equalTo: self.matchReviewedBox.centerYAnchor),
                    $0.leadingAnchor.constraint(equalTo: self.matchReviewedBox.leadingAnchor, constant: 50)
                ])
            }
        }
    }
    
    @objc func userSwipedRightOnCompleteButton() {
        self.status = .accepted
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollToSelectedIndex()
    }
    
    @objc private func messageButtonTapped() {
        self.status = .chatting
    }
    
    @objc private func markAsCompleteButtonTapped() {
        self.status = .completed
    }
    
    @objc private func reviewButtonTapped() {
        print("review button tapped")
        self.status = .reviewed
        self.actionButtonsScrollView.removeFromSuperview()
        self.actionSelectionButtonStackView.removeFromSuperview()
        self.addSubview(self.matchReviewedBox) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.lineView.bottomAnchor, constant: 20),
                $0.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                $0.widthAnchor.constraint(equalToConstant: self.actionButtonSize.width),
                $0.heightAnchor.constraint(equalToConstant: self.actionButtonSize.height)
            ])
        }
        
        self.matchReviewedBox.addSubview(self.matchReviewedBoxLabel) {
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: self.matchReviewedBox.centerYAnchor),
                $0.leadingAnchor.constraint(equalTo: self.matchReviewedBox.leadingAnchor, constant: 50)
            ])
        }
    }
    
    private func scrollToSelectedIndex() {
        let selectedIndex: Int = {
            switch status {
            case .accepted:
                return 0
            case .chatting:
                return 1
            case .completed:
                return 2
            default:
                return 0
            }
        }()
        let offsetPoint = CGPoint(x: Int((UIScreen.main.bounds.center.x / 2.4 + actionButtons.first!.intrinsicContentSize.width)) * selectedIndex, y: 0)
        self.actionButtonsScrollView.setContentOffset(offsetPoint, animated: true)
        
        self.actionSelectionButtons.forEach {
            if $0.isSelected {
                $0.setBackgroundImage(.matchActionSelectionButton(isSelected: false, size: actionButtonSelectionSize), for: .normal)
                $0.isSelected = false
            }
        }
        self.actionSelectionButtons[selectedIndex].setBackgroundImage(.matchActionSelectionButton(isSelected: true, size: actionButtonSelectionSize), for: .normal)
        self.actionSelectionButtons[selectedIndex].isSelected = true
    }
}
