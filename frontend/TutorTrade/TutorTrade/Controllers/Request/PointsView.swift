//
//  PointsView.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/4/21.

import UIKit

class PointsView: UIView {

    // we need to format the view ✅
    // create the label outside of view - ✅
    // create the label inside of view
    // create the buttons
    
    let pointsLabel: UILabel! = {
        let label = UILabel(frame: CGRect(x: 0, y: -50, width: 374, height: 50))
        
        guard let pointsLabel = UIFont(name: "Lato-Bold", size: 25) else {
            fatalError("Failed to load Lato-Font")
        }
        
        label.font = UIFontMetrics.default.scaledFont(for: pointsLabel)
        label.text = "Budget"

        return label
    }()
    
    // create the textfield
    let pointsTextField: UITextField! = {
        let textField = UITextField(frame: CGRect(x: 15, y: 15, width: 110, height: 50))
        
        guard let pointsTextFieldFont = UIFont(name: "Lato-Bold", size: 20) else {
            fatalError("Failed to load Lato-Font")
        }
        
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 20
        textField.placeholder = "0"
        textField.font = UIFontMetrics.default.scaledFont(for: pointsTextFieldFont)
        
        return textField
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 660, width: 350, height: 150))
        self.backgroundColor = .systemGreen
        self.layer.cornerRadius = 20
        self.addSubview(pointsLabel)
        self.addSubview(pointsTextField)
    }
}
