//
//  WelcomePageConfigurations.swift
//  TutorTrade
//
//  Created by brock davis on 10/27/21.
//

import UIKit

extension UIImageView {
    
    static var tutorTradeLogoView: UIImageView {
        get {
            let imageView = UIImageView(image: UIImage(named: "LogoImage")!)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }
    }
    
    static var tutorTradeGraphImageView: UIImageView {
        get {
            let imageView = UIImageView(image: UIImage(named: "GraphImage")!)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }
    }
}

extension UILabel {
    
    static var serviceDescriptionLabel: UILabel {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Community-based tutoring."
        descriptionLabel.font = UIFont(name: "Lato-Bold", size: 25)!
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }
}

extension UIView {
    
    static var actionContainerVIew: UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(named: "ActionContainerViewColor")!
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.cornerRadius = 16
        return containerView
    }
}

extension UIButton {
    
    static var getStartedButton: UIButton {
        get {
            let button = UIButton()
            button.backgroundColor = UIColor(named: "GetStartedButtonColor")!
            button.setTitle("Get started", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel!.font = UIFont(name: "Lato-Bold", size: 20)!
            button.layer.cornerRadius = 30
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
    }
    
    static var signInButton: UIButton {
        get {
            let button = UIButton()
            button.setTitle("Sign in", for: .normal)
            button.backgroundColor = .clear
            button.titleLabel!.font = UIFont(name: "Lato-Bold", size: 20)!
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(UIColor(named: "SignInButtonTextColor")!, for: .normal)
            return button
        }
    }
    
    static var termsOfServiceButton: UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let titleAttributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributedTitle = NSAttributedString(string: "Terms of Service",
                                                 attributes:titleAttributes)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel!.font = UIFont(name: "Roboto-Regular", size: 12)!
        button.backgroundColor = .clear
        return button
    }
    
    static var privacyPolicyButton: UIButton {
        get {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            let titleAttributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
            let attributedTitle = NSMutableAttributedString(string: "Privacy Policy")
            attributedTitle.addAttributes(titleAttributes, range: NSRange(0..<attributedTitle.length))
            button.setAttributedTitle(attributedTitle, for: .normal)
            button.backgroundColor = .clear
            button.titleLabel!.font = UIFont(name: "Roboto-Regular", size: 12)!
            return button
        }
    }
}
