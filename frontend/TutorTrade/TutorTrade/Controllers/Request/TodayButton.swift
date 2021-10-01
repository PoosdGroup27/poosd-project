//
//  TodayButton.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/1/21.
//

import UIKit

class TodayButton: UIButton {
    
    convenience init() {
        self.init(frame: CGRect(x: 130, y: 195, width: 90, height: 40))
        
        guard let buttonFont = UIFont(name: "Lato-Bold", size: 15) else {
            fatalError("Failed to load Lato-Font")
        }
        
        self.backgroundColor = UIColor.lightGray
        self.layer.cornerRadius = 20
        self.clipsToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.setTitle("Today", for: .normal)
        self.titleLabel?.font = buttonFont
        self.setTitleColor(.black, for: .normal)
    }
}
