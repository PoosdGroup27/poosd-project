//
//  SubmitButtonView.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/6/21.
//

import UIKit

class SubmitButtonView: UIView {
    
    let submitButton: UIButton! = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        guard let buttonFont = UIFont(name: "Lato-Bold", size: 15) else {
            fatalError("Failed to load Lato-Font")
        }
        
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.clipsToBounds = true
        button.titleLabel?.font = buttonFont
        button.setTitleColor(.white, for: .normal)
        
        return button
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 250, y: 850, width: 100, height: 50))
        self.addSubview(submitButton)
    }
}
