//
//  RequestSubjectTextField.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 9/29/21.
//

import UIKit

class SubjectRequestView: UITextField {
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 75, width: 350, height: 50))
        
        guard let subjectLabelFont = UIFont(name: "Lato-Bold", size: 25) else {
            fatalError("Failed to load Lato-Font")
        }
        
        guard let subjectPlaceHolderFont = UIFont(name: "Lato-Bold", size: 15) else {
            fatalError("Failed to load Lato-Font")
        }

        let subjectLabel: UILabel = UILabel(frame: CGRect(x: 0, y: -50, width: 374, height: 50))
        
        self.placeholder = "Subject"
        self.font = UIFontMetrics.default.scaledFont(for: subjectPlaceHolderFont)
        self.borderStyle = UITextField.BorderStyle.roundedRect
        
        subjectLabel.text = "Subject"
        subjectLabel.font = UIFontMetrics.default.scaledFont(for: subjectLabelFont)
        
        self.addSubview(subjectLabel)
    }
}
