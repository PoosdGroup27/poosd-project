//
//  UrgencyView.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/3/21.
//

import UIKit

class UrgencyView: UIView {
    
    enum UrgencyButtonTags: Int {
        case today = 0
        case tomorrow = 1
        case thisWeek = 2
    }

    let urgencyLabel: UILabel! = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 374, height: 50))
        
        guard let urgencyLabelFont = UIFont(name: "Lato-Bold", size: 25) else {
            fatalError("Failed to load Lato-Font")
        }

        label.font = UIFontMetrics.default.scaledFont(for: urgencyLabelFont)
        label.text = "Urgency"
        return label
    }()
    
    let nowButton: UIButton! = {
        let button = UIButton(frame: CGRect(x: 0, y: 60, width: 90, height: 40))
        
        guard let buttonFont = UIFont(name: "Lato-Bold", size: 15) else {
            fatalError("Failed to load Lato-Font")
        }

        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        button.setTitle("Today", for: .normal)
        button.titleLabel?.font = buttonFont
        button.setTitleColor(.black, for: .normal)

        return button
    }()
    
    let todayButton: UIButton! = {
        let button = UIButton(frame: CGRect(x: 130, y: 60, width: 90, height: 40))
        
        guard let buttonFont = UIFont(name: "Lato-Bold", size: 15) else {
            fatalError("Failed to load Lato-Font")
        }

        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        button.setTitle("Tomorrow", for: .normal)
        button.titleLabel?.font = buttonFont
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    let thisWeekButton: UIButton! = {
        let button = UIButton(frame: CGRect(x: 255, y: 60, width: 90, height: 40))
        
        guard let buttonFont = UIFont(name: "Lato-Bold", size: 15) else {
            fatalError("Failed to load Lato-Font")
        }

        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        button.setTitle("This Week", for: .normal)
        button.titleLabel?.font = buttonFont
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 135, width: 350, height: 100))
        self.addSubview(urgencyLabel)
        self.addSubview(nowButton)
        self.addSubview(todayButton)
        self.addSubview(thisWeekButton)
    }
}
