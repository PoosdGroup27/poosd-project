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
            phoneNumberLabel.font = UIFont(name: "Dosis-Bold", size: UIScreen.main.bounds.width / 10)
            phoneNumberLabel.lineBreakMode = NSLineBreakMode.byCharWrapping
            phoneNumberLabel.sizeToFit()
            return phoneNumberLabel
        }
    }
    
    static var verificationDescriptionLabel: UILabel {
        get {
            let description = UILabel()
            description.translatesAutoresizingMaskIntoConstraints = false
            description.numberOfLines = 0
            description.text = "Enter the verification code sent by \ntext to "
            description.font = UIFont(name: "OpenSans-Regular", size: UIScreen.main.bounds.width / 25)
            description.lineBreakMode = NSLineBreakMode.byCharWrapping
            description.sizeToFit()
            return description
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
