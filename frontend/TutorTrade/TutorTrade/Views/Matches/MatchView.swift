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
    private let actionButton: UIButton = .actionItemButton
    private let actionSelectionButtons: [UIButton] = {
        stride(from: 0, to: 3, by: 1).map { _ in
            UIButton.matchActionSelectionButton
        }
    }()
    private let actionSelectionButtonStackView: UIStackView = .matchActionSelectionButtonStackView
    
    
    private let profileImageView: UIImageView
    private let nameLabel: UILabel
    private let pointsLabel: UILabel
    private let ratingLabel: UILabel
    private let subjectLabel: UILabel
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    init(withProfileImage profileImage: UIImage, withName name: String, withPoints points: Int, withRating rating: Double, withSubject subject: String, withStatus status: TuteeRequestStatus, withRole role: RequestRole) {
        
        let imageSize = CGSize(width: UIScreen.main.bounds.width / 4.076, height: UIScreen.main.bounds.height / 7.185)
        self.profileImageView = .matchProfileImage(withProfilePic: profileImage.resizedTo(imageSize))
        self.nameLabel = .matchBoxLabel(withText: name, withFontSize: UIScreen.main.bounds.width / 25)
        
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
        self.setActionButton(forStatus: status)
        
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
                $0.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIScreen.main.bounds.width / 5.434),
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
        
        self.addSubview(self.actionButton) {
            NSLayoutConstraint.activate([
                $0.centerXAnchor.constraint(equalTo: self.centerXAnchor),
                $0.topAnchor.constraint(equalTo: self.lineView.bottomAnchor, constant: UIScreen.main.bounds.height / 54.133)
            ])
        }
        
        let actionButtonSelectionSize = CGSize(width: UIScreen.main.bounds.width / 46.875, height: UIScreen.main.bounds.width / 46.875)
        
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
        
        for (index, actionSelectionButton) in actionSelectionButtons.enumerated() {
            actionSelectionButton.setBackgroundImage(.matchActionSelectionButton(isSelected: index == selectedIndex, size: actionButtonSelectionSize), for: .normal)
            actionSelectionButtonStackView.addArrangedSubview(actionSelectionButton)
        }
        
        let actionSelectionButtonSpacing = UIScreen.main.bounds.width / 28.846
        
        self.addSubview(actionSelectionButtonStackView) {
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: actionButtonSelectionSize.width * 3 + actionSelectionButtonSpacing * 2),
                $0.topAnchor.constraint(equalTo: self.actionButton.bottomAnchor, constant: UIScreen.main.bounds.height / 47.764),
                $0.heightAnchor.constraint(equalToConstant: actionButtonSelectionSize.height),
                $0.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        }
    }
    
    private func setActionButton(forStatus status: TuteeRequestStatus) {
        let actionButtonSize = CGSize(width: UIScreen.main.bounds.width / 1.838, height: UIScreen.main.bounds.height / 19.333)
        let (matchAction, actionText): (MatchAction, String) = {
            switch status {
            case .accepted:
                return (.message, "Message")
            case .chatting:
                return (.markAsComplete, "Mark as complete")
            case .completed:
                return (.review, "Review")
            default:
            return (.message, "Message")
            }
        }()
        
        self.actionButton.setTitle(actionText, for: .normal)
        self.actionButton.setBackgroundImage(.matchActionBackgroundImage(forAction: matchAction, size: actionButtonSize), for: .normal)
    }

}
