//
//  CoreGraphics.swift
//  TutorTrade
//
//  Created by brock davis on 10/11/21.
//

import UIKit

extension CGRect {
    
    var center : CGPoint {
        get {
            CGPoint(x: self.midX, y: self.midY)
        }
    }
}
