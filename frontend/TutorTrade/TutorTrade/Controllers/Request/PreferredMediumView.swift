//
//  PreferredMediumView.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/1/21.
//

import UIKit

class PreferredMediumView: UIView {
    
    let preferredMediumLabel: UILabel! = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 374, height: 50))
        
        guard let preferredLabelFont = UIFont(name: "Lato-Bold", size: 25) else {
            fatalError("Failed to load Lato-Font")
        }

        
        label.font = UIFontMetrics.default.scaledFont(for: preferredLabelFont)
        label.text = "Preferred Medium"
        
        return label
    }()
    
    let inPersonButton: UIButton! = {
        let button = UIButton(frame: CGRect(x: 0, y: 60, width: 60, height: 60))
        
        guard let buttonFont = UIFont(name: "Lato-Bold", size: 15) else {
            fatalError("Failed to load Lato-Font")
        }

        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = button.frame.width / 2
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor

        button.setTitle("Person", for: .normal)
        button.titleLabel?.font = buttonFont
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    let onlineButton: UIButton! = {
        let button = UIButton(frame: CGRect(x: 100, y: 60, width: 60, height: 60))
        
        guard let buttonFont = UIFont(name: "Lato-Bold", size: 15) else {
            fatalError("Failed to load Lato-Font")
        }

        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = button.frame.width / 2
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor

        button.setTitle("Online", for: .normal)
        button.titleLabel?.font = buttonFont
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()

    convenience init() {
        self.init(frame: CGRect(x: 0, y: 480, width: 350, height: 150))
        self.addSubview(preferredMediumLabel)
        self.addSubview(inPersonButton)
        self.addSubview(onlineButton)
    }
}