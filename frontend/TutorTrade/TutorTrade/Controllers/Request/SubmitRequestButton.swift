//
//  SubmitRequestButton.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 9/29/21.
//

import UIKit

class SubmitRequestButton: UIButton {
    convenience init() {
        self.init(frame: CGRect(x: 250, y: 850, width: 100, height: 50))
        self.backgroundColor = .systemBlue
        self.setTitle("Submit", for: .normal)
        
        guard let buttonFont = UIFont(name: "Lato-Bold", size: 15) else {
            fatalError("Failed to load Lato-Font")
        }

        self.layer.cornerRadius = 20
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.clipsToBounds = true
        self.titleLabel?.font = buttonFont
        self.setTitleColor(.white, for: .normal)
    }
}
