//
//  DescriptionTextField.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/1/21.
//

import UIKit

class DescriptionTextField: UITextField {
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 300, width: 350, height: 150))
        
        guard let descriptionLabelFont = UIFont(name: "Lato-Bold", size: 25) else {
            fatalError("Failed to load Lato-Font")
        }
        
        guard let descriptionPlaceHolderFont = UIFont(name: "Lato-Bold", size: 15) else {
            fatalError("Failed to load Lato-Font")
        }

        let descriptionLabel: UILabel = UILabel(frame: CGRect(x: 0, y: -50, width: 374, height: 50))
        
        self.placeholder = "What do you need help with?"
        self.font = UIFontMetrics.default.scaledFont(for: descriptionPlaceHolderFont)
        self.borderStyle = UITextField.BorderStyle.roundedRect
        self.contentVerticalAlignment = .top
        
        descriptionLabel.text = "Description"
        descriptionLabel.font = UIFontMetrics.default.scaledFont(for: descriptionLabelFont)
        
        self.addSubview(descriptionLabel)
    }
}
