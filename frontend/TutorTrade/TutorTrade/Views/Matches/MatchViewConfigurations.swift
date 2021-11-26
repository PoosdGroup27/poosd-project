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
            button.titleLabel?.textColor = .white
            button.titleLabel?.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 26.785)!
            button.contentHorizontalAlignment = .left
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 55, bottom: 0, right: 0)
            button.layer.shadowOffset = CGSize(width: 0, height: 4)
            button.layer.shadowOpacity = 0.25
            return button
        }
    }
    
    static var matchActionSelectionButton: UIButton  {
        get {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
    }
}

extension UIStackView {
    static var matchActionSelectionButtonStackView: UIStackView {
        get {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.alignment = .center
            return stackView
        }
    }
}

extension UIImageView {
    static func matchProfileImage(withProfilePic profileImage: UIImage) -> UIImageView {
        let imageView = UIImageView(image: profileImage.withCornerRadius(5))
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
            let iconOrigin = CGPoint(x: size.width / 10, y: size.height / 4)
            let iconSize = CGSize(width: size.height / 2, height: size.height / 2)
            icon.draw(in: CGRect(origin: iconOrigin, size: iconSize))
        }
    }
    
    static func matchActionSelectionButton(isSelected: Bool, size: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            let context = UIGraphicsGetCurrentContext()!
            let fillColorName = (isSelected) ? "SelectedMatchActionIndicatorColor" : "UnselectedMatchActionIndicatorColor"
            context.setFillColor(UIColor(named: fillColorName)!.cgColor)
            context.addPath(CGPath(ellipseIn: CGRect(origin: .zero, size: size), transform: nil))
            context.fillPath()
        }
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
}

internal enum MatchDisplayBoxType {
    case pointsBox
    case ratingBox
    case subjectBox
    case nameBox
}

extension BorderedDisplayBoxView {
    static func matchDisplayBox(boxType: MatchDisplayBoxType) -> BorderedDisplayBoxView {
        let (icon, borderRadius): (UIImage?, CGFloat) = {
            switch boxType {
            case .pointsBox:
                return (UIImage(named: "PointIcon")!, 25)
            case .ratingBox:
                return (UIImage(named: "RatingIcon")!, 25)
            case .subjectBox:
                return (nil, 25)
            default:
                return (nil, 5)
            }
        }()
        let boxSize = CGSize(width: UIScreen.main.bounds.width / 2.777, height: 28)
        let displayBox = BorderedDisplayBoxView(iconImage: icon, iconHeightRatio: 0.5, borderColor: nil, borderWidth: 0, boxSize: boxSize, cornerRadius: borderRadius, boxBackgroundColor: UIColor(named: "MatchBoxColor")!, withShadow: false)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        displayBox.backgroundColor = .clear
        return displayBox
    }
}
