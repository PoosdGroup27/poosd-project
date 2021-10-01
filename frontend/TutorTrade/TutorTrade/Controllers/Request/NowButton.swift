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
        self.init(frame: CGRect(x: 100, y: 200, width: 100, height: 50))
        self.backgroundColor = .gray
        self.setTitle("Now", for: .normal)
    }
}

//class TodayButton: UIButton {
//    convenience init() {
//        self.init(frame: CGRect(x: 250, y: 1000, width: 100, height: 50))
//        self.backgroundColor = .gray
//        self.setTitle("Today", for: .normal)
//    }
//}
//
//class ThisWeekButton: UIButton {
//    convenience init() {
//        self.init(frame: CGRect(x: 250, y: 1000, width: 100, height: 50))
//        self.backgroundColor = .gray
//        self.setTitle("This week", for: .normal)
//    }
//}



