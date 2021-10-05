//
//  PointsView.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/4/21.

import UIKit

class PointsView: UIView {

    // we need to format the view
    // create the label outside of view - ✅
    // create the textfield
    // create the label inside of view
    // create the buttons
    
    let pointsLabel: UILabel! = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 374, height: 50))
        
        guard let pointsLabel = UIFont(name: "Lato-Bold", size: 25) else {
            fatalError("Failed to load Lato-Font")
        }
        
        label.font = UIFontMetrics.default.scaledFont(for: pointsLabel)
        label.text = "Cost"

        return label
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 620, width: 350, height: 150))
        self.backgroundColor = .red
        self.addSubview(pointsLabel)
    }
}
