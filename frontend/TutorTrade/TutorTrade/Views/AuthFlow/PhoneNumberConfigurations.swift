//
//  PhoneNumberConfigurations.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/27/21.
//

import UIKit

// Back Button

// UI Label

extension UIView {
    static var phoneNumberTitleContainerView: UIView {
        get {
            let container = UIView()
//            container.backgroundColor = UIColor(named: "AuthFlowColor")!
            container.translatesAutoresizingMaskIntoConstraints = false
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
            phoneNumberLabel.font = UIFont(name: "Dosis-Bold", size: UIScreen.main.bounds.width / 10)
            phoneNumberLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
            phoneNumberLabel.sizeToFit()
            return phoneNumberLabel
        }
    }
    
    static var phoneNumberDescriptionLabel: UILabel {
        get {
            let description = UILabel()
            description.translatesAutoresizingMaskIntoConstraints = false
            description.numberOfLines = 0
            description.text = "On TutorTrade you never have to remember\na username or password."
            description.font = UIFont(name: "OpenSans-Regular", size: UIScreen.main.bounds.width / 25)
            description.lineBreakMode = NSLineBreakMode.byCharWrapping
            description.sizeToFit()
            return description
        }
    }
}

extension ShadowDisplayBox {
    
    static func defaultDisplayBoxView(withIcon icon: UIImage, iconHeightRatio: CGFloat = 0.5) -> ShadowDisplayBox {
        let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
        let displayBox = ShadowDisplayBox(iconImage: icon, iconHeightRatio: iconHeightRatio, borderColor: .white, borderWidth: 1.5,
                                          boxSize: boxSize, cornerRadius: 10, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.5,
                                          shadowOffset: CGSize(width: 3, height: 3), shadowRadius: 4)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        displayBox.backgroundColor = .clear
        return displayBox
    }
}

// UITextfield
extension UITextField {
    static func createTextField(withPlaceholder placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = placeholder
        textField.font = UIFont(name: "Roboto-Regular", size: 12)
        textField.textColor = UIColor(named: "PhoneNumberColor")
        textField.keyboardType = .numberPad
        return textField
    }
}

// Forward Button

extension UIButton {
    static func createButton(backgroundColor: UIColor, image: UIImage) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = backgroundColor
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 25
        return button
    }
}
