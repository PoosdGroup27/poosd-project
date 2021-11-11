//
//  PhoneNumberConfigurations.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/27/21.
//

import UIKit

extension UIView {
    
    static var countryCodeContainer: UIView {
        get {
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            container.layer.cornerRadius = 10
            container.backgroundColor = .white
            return container
        }
    }
}

extension UILabel {
    static var phoneNumberTitleLabel: UILabel {
        get {
            let phoneNumberLabel = UILabel()
            phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
            phoneNumberLabel.numberOfLines = 0
            phoneNumberLabel.text = "What's your \ndigits?"
            phoneNumberLabel.font = UIFont(name: "Dosis-ExtraBold", size: UIScreen.main.bounds.width / 9.6)
            phoneNumberLabel.lineBreakMode = .byWordWrapping
            phoneNumberLabel.sizeToFit()
            return phoneNumberLabel
        }
    }
    
    static var countryCodeLabel: UILabel {
        get {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 1
            label.text = "🇺🇸 +1"
            label.font = UIFont(name: "Roboto-Regular", size: 16)!
            return label
        }
    }
    
    static var phoneNumberDescriptionLabel: UILabel {
        get {
            let description = UILabel()
            description.translatesAutoresizingMaskIntoConstraints = false
            description.numberOfLines = 2
            description.text = "On TutorTrade you never have to remember a username or password."
            description.font = UIFont(name: "Roboto-Regular", size: UIScreen.main.bounds.width / 28)
            description.lineBreakMode = .byWordWrapping
            description.sizeToFit()
            return description
        }
    }
}

extension ShadowDisplayBox {
    
    static func defaultDisplayBoxView(withIcon icon: UIImage, iconHeightRatio: CGFloat = 0.5) -> ShadowDisplayBox {
        let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
        let displayBox = ShadowDisplayBox(iconImage: icon, iconHeightRatio: iconHeightRatio, borderColor: .white, borderWidth: 1.5,
                                          boxSize: boxSize, cornerRadius: 10, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.25,
                                          shadowOffset: CGSize(width: 4, height: 4), shadowRadius: 4)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        displayBox.backgroundColor = .clear
        return displayBox
    }
}

extension UITextField {
    static func createTextField(withPlaceholder placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.font = UIFont(name: "Roboto-Regular", size: 16)
        textField.textColor = UIColor(named: "PhoneNumberColor")
        textField.keyboardType = .numberPad
        return textField
    }
}

extension UIButton {
    static func createButton(backgroundColor: UIColor, image: UIImage) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = backgroundColor
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 25
        return button
    }
    
    static var backButton: UIButton {
        get {
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: "BackIcon")!, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear
            return button
        }
    }
}
