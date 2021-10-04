//
//  UrgencyButtonsViewController.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 9/30/21.
//

// TODO:
// Make each button their own class and just have all of the buttons as a property of the scrollview controller.

import UIKit

class NowButton: UIButton {
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 195, width: 90, height: 40))
        
        guard let buttonFont = UIFont(name: "Lato-Bold", size: 15) else {
            fatalError("Failed to load Lato-Font")
        }

        self.backgroundColor = UIColor.lightGray
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        
        self.setTitle("Now", for: .normal)
        self.titleLabel?.font = buttonFont
        self.setTitleColor(.black, for: .normal)
    }
}
