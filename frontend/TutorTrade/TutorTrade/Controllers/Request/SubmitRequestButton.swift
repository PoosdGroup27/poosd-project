//
//  SubmitRequestButton.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 9/29/21.
//

import UIKit

class SubmitRequestButton: UIButton {
    convenience init() {
        self.init(frame: CGRect(x: 250, y: 1000, width: 100, height: 50))
        self.backgroundColor = .blue
        self.setTitle("Submit", for: .normal)
    }
}
