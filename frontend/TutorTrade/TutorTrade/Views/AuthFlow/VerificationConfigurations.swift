//
//  VerificationCodeConfigurations.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/27/21.
//

import UIKit

extension UILabel {
    static var verificationTitleLabel: UILabel {
        get {
            let phoneNumberLabel = UILabel()
            phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false
            phoneNumberLabel.numberOfLines = 0
            phoneNumberLabel.text = "Verify your number"
            phoneNumberLabel.font = UIFont(name: "Dosis-ExtraBold", size: UIScreen.main.bounds.width / 11)
            phoneNumberLabel.lineBreakMode = .byWordWrapping
            phoneNumberLabel.sizeToFit()
            return phoneNumberLabel
        }
    }
    
    static var verificationDescriptionLabel: UILabel {
        get {
            let description = UILabel()
            description.translatesAutoresizingMaskIntoConstraints = false
            description.numberOfLines = 0
            description.text = "Enter the verification code sent by text to "
            description.font = UIFont(name: "Roboto-Regular", size: UIScreen.main.bounds.width / 24)
            description.lineBreakMode = .byWordWrapping
            description.sizeToFit()
            return description
        }
    }
}

extension UIStackView {
    
    static var verificationBoxesStackView: UIStackView {
        get {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.backgroundColor = .clear
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = UIScreen.main.bounds.width / 31.25
            return stackView
        }
    }
}

extension ShadowDisplayBox {
    
    static func defaultDisplayBoxView() -> ShadowDisplayBox {
        let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
        let displayBox = ShadowDisplayBox(borderColor: .white, borderWidth: 1.5,
                                          boxSize: boxSize, cornerRadius: 10, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.5,
                                          shadowOffset: CGSize(width: 3, height: 3), shadowRadius: 4)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        displayBox.backgroundColor = .clear
        return displayBox
    }
}

extension UIButton {
    
    static var resendOTPButton: UIButton {
        get {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            let attributedString = NSAttributedString(string: "Didn’t get a text?", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
            button.setAttributedTitle(attributedString, for: .normal)
            button.titleLabel!.font = UIFont(name: "Roboto-Regular", size: 14)!
            button.backgroundColor = .clear
            return button
        }
    }
}

extension UITextField {
    static var verificationTextField: UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.placeholder = "X"
        textField.font = UIFont(name: "Roboto-Regular", size: 18)!
        return textField
    }
}
