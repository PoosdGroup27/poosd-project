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
            container.backgroundColor = .white
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

// UITextfield

// Forward Button

// Keyboard
