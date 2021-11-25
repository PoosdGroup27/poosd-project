//
//  MatchViewConfigurations.swift
//  TutorTrade
//
//  Created by brock davis on 11/24/21.
//

import UIKit

extension UIButton {
    
    static var matchOptionsButton: UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "MatchOptionsButtonImage")!, for: .normal)
        return button
    }
    
    static var actionItemButton: UIButton {
        get {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
    }
}

extension UIImageView {
    static func matchProfileImage(withProfilePic profileImage: UIImage) -> UIImageView {
        let imageView = UIImageView(image: profileImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}

extension UIImage {
    
    static func matchActionBackgroundImage(forAction action: MatchAction, size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            let context = UIGraphicsGetCurrentContext()!
            let borderedRectPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: 25).cgPath
            context.addPath(borderedRectPath)
            UIColor(named: "MatchActionButtonColor")!.setFill()
            context.fillPath()
            let icon: UIImage = {
                switch action {
                case .message:
                    return UIImage(named: "MessageIcon")!
                case .markAsComplete:
                    return UIImage(named: "MarkAsCompletedIcon")!
                case .review:
                    return UIImage(named: "ReviewIcon")!
                }
            }()
            let iconOrigin = CGPoint(x: size.width / 8, y: size.height / 4)
            let iconSize = CGSize(width: size.height / 2, height: size.height / 2)
            icon.draw(in: CGRect(origin: iconOrigin, size: iconSize))
        }
    }
    
    static func matchActionSelectionButton(isSelected: Bool) {
//        UIGraphicsImageRenderer.image { _ in
//            let context = UIGraphicsGetCurrentContext()!
//            context.setFillColor((isSelected) ? )
        }
}

extension UIView {
    static var matchNameBoxView: UIView {
        get {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(named: "MatchBoxColor")!
            view.layer.cornerRadius = 5
            return view
        }
    }
    
    static var matchLineSeperator: UIView {
        get {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(named: "MatchLineSeperatorColor")!
            return view
        }
    }
}

extension UILabel {
    static func matchBoxLabel(withText text: String, withFontSize fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont(name: "Roboto-Bold", size: fontSize)!
        return label
    }
    
    static func matchActionLabel(forAction action: MatchAction) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = {
            switch action {
            case .message:
                return "Message"
            case .markAsComplete:
                return "Mark as complete"
            case .review:
                return "Review"
            }
        }()
        label.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 26.785)
        label.textColor = .white
        return label
    }
}

internal enum MatchDisplayBoxType {
    case pointsBox
    case ratingBox
    case subjectBox
}

extension BorderedDisplayBoxView {
    static func matchDisplayBox(boxType: MatchDisplayBoxType) -> BorderedDisplayBoxView {
        let icon: UIImage? = {
            switch boxType {
            case .pointsBox:
                return UIImage(named: "PointIcon")!
            case .ratingBox:
                return UIImage(named: "RatingIcon")!
            case .subjectBox:
                return nil
            }
        }()
        let boxSize = CGSize(width: UIScreen.main.bounds.width / 2.777, height: 28)
        let displayBox = BorderedDisplayBoxView(iconImage: icon, iconHeightRatio: 0.5, borderColor: nil, borderWidth: 0, boxSize: boxSize, cornerRadius: 35, boxBackgroundColor: nil, withShadow: false)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        return displayBox
    }
}
