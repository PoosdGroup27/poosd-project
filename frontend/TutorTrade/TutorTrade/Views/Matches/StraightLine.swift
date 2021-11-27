//
//  StraightLine.swift
//  TutorTrade
//
//  Created by brock davis on 11/25/21.
//

import UIKit

class StraightLine: UIView {
    
    var size: CGSize
    
    var color: UIColor
    
    init(size: CGSize, color: UIColor) {
        self.size = size
        self.color = color
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.move(to: .zero)
        context.move(to: CGPoint(x: 0, y: size.width))
        color.setStroke()
        context.setLineWidth(size.height)
        context.strokePath()
    }

}
