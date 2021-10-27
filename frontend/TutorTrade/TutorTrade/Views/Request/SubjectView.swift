//
//  SubjectView.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/6/21.
//

import UIKit

class SubjectView: UIView {

    let subjectLabel: UILabel! = {
        let label = UILabel(frame: CGRect(x: 0, y: -50, width: 374, height: 50))
        
        guard let labelFont = UIFont(name: "Lato-Bold", size: 25) else {
            fatalError("Failed to load Lato-Font")
        }
        
        label.text = "Subject"
        label.font = UIFontMetrics.default.scaledFont(for: labelFont)
        
        return label
    }()
    
    let subjectTextField: UITextField! = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 350, height: 50))
        
        guard let textFieldFont = UIFont(name: "Lato-Bold", size: 15) else {
            fatalError("Failed to load Lato-Font")
        }
        
        textField.placeholder = "Subject"
        textField.font = UIFontMetrics.default.scaledFont(for: textFieldFont)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        return textField
    }()
    
    convenience init () {
        self.init(frame: CGRect(x: 0, y: 75, width: 350, height: 50))
        self.addSubview(subjectLabel)
        self.addSubview(subjectTextField)
    }
}


