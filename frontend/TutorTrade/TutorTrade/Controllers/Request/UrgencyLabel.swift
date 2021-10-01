//
//  UrgencyLabel.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/1/21.
//

import UIKit

class UrgencyLabel: UILabel {

    convenience init() {
        self.init(frame: CGRect(x: 0, y: 130, width: 374, height: 50))
        
        guard let urgencyLabelFont = UIFont(name: "Lato-Bold", size: 25) else {
            fatalError("Failed to load Lato-Font")
        }
        
        self.font = UIFontMetrics.default.scaledFont(for: urgencyLabelFont)
        self.text = "Urgency"
    }
}
