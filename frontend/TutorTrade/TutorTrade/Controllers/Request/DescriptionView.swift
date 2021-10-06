//
//  DescriptionView.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/6/21.
//

import UIKit

class DescriptionView: UIView {
    let descriptionTextField: UITextField! = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 350, height: 150))
        
        guard let textFieldFont = UIFont(name: "Lato-Bold", size: 15) else {
            fatalError("Failed to load Lato-Font")
        }
        
        textField.placeholder = "What do you need help with?"
        textField.font = UIFontMetrics.default.scaledFont(for: textFieldFont)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.contentVerticalAlignment = .top
        
        return textField
    }()
    
    let descriptionLabel: UILabel! = {
        let label = UILabel(frame: CGRect(x: 0, y: -50, width: 374, height: 50))
        
        guard let labelFont = UIFont(name: "Lato-Bold", size: 25) else {
            fatalError("Failed to load Lato-Font")
        }
        
        label.text = "Description"
        label.font = UIFontMetrics.default.scaledFont(for: labelFont)
        
        return label
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 300, width: 350, height: 150))
        self.addSubview(descriptionLabel)
        self.addSubview(descriptionTextField)
    }
}
