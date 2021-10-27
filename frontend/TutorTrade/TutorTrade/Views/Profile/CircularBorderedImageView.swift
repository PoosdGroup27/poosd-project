//
//  CircularBorderedImageView.swift
//  TutorTrade
//
//  Created by brock davis on 10/11/21.
//

import UIKit

class CircularBorderedImageView: UIView {
    
    private var outerCirclePath: CGPath {
        get {
            CGPath(ellipseIn: CGRect(x: bounds.center.x - radius, y: bounds.center.y - radius, width: radius * 2, height: radius * 2), transform: .none)
        }
    }
    
    private var borderSpacingCirclePath : CGPath {
        get {
            let borderWidth = borderWidth ?? 0
            return CGPath(ellipseIn: CGRect(x: bounds.center.x - radius + borderWidth, y: bounds.center.y - radius + borderWidth, width: (radius * 2) - (borderWidth * 2), height: (radius * 2) - (borderWidth * 2)), transform: .none)
        }
    }
    
    private var imageCirclePath : CGPath {
        get {
            let borderWidth = borderWidth ?? 0
            let borderSpaceWidth = borderSpaceWidth ?? 0
            return CGPath(ellipseIn: CGRect(x: self.bounds.center.x - radius + borderWidth + borderSpaceWidth, y: self.bounds.center.x - radius + borderWidth + borderSpaceWidth, width: (radius * 2) - ((borderWidth + borderSpaceWidth)  * 2), height: (radius * 2) - ((borderWidth + borderSpaceWidth)  * 2)), transform: .none)
        }
    }
    
    var radius: CGFloat {
        get {
            min(self.bounds.width, self.bounds.height) / 2
        }
        set {
            self.bounds.size.width = newValue
            self.bounds.size.height = newValue
        }
    }
    
    override var bounds: CGRect {
        didSet {
            if self.shadowSize != nil {
                self.layer.shadowPath = outerCirclePath
            }
        }
    }
    
    override var frame: CGRect {
        didSet {
            if self.shadowSize != nil {
                self.layer.shadowPath = outerCirclePath
            }
        }
    }
    
    var image: UIImage
    
    var borderWidth: CGFloat?
    
    var borderColor: UIColor?
    
    var shadowSize: CGSize?
    
    var borderSpaceWidth: CGFloat?
    
    init(radius: CGFloat = 50, image: UIImage, borderWidth: CGFloat? = nil, borderColor: UIColor? = nil, borderSpaceWidth: CGFloat? = nil, shadowSize: CGSize? = nil) {
        self.image = image
        self.borderWidth = borderWidth
        self.borderColor = borderColor
        self.borderSpaceWidth = borderSpaceWidth
        self.shadowSize = shadowSize
        super.init(frame: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
        self.isOpaque = false
        if let shadowSize = shadowSize {
            self.layer.shadowOffset = shadowSize
            self.layer.shadowOpacity = 0.5
            self.layer.shadowPath = outerCirclePath
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        
        // Draw the border circle and/or shadow
        if borderWidth != nil || shadowSize != nil {
            
            context.saveGState()
            
            context.addPath(outerCirclePath)
            
            if let borderColor = borderColor {
                context.setFillColor(borderColor.cgColor)
            }
            context.fillPath()
            
            if borderSpaceWidth != nil {
                context.addPath(borderSpacingCirclePath)
                UIColor.white.setFill()
                context.fillPath()
            }
            context.restoreGState()
        }
        let imageCirclePath = imageCirclePath
        context.addPath(imageCirclePath)
        context.clip()
        image.draw(in: imageCirclePath.boundingBoxOfPath)
        
//        if let cutOutRadius = cutOutRadius {
//            context.resetClip()
//            let outerCirclePath = outerCirclePath
//            context.addPath(outerCirclePath)
//            context.clip()
//            let outerCircleRect = outerCirclePath.boundingBoxOfPath
//            let cutOutRect = CGRect(x: outerCircleRect.midX - cutOutRadius, y: outerCircleRect.height - radius, width: cutOutRadius * 2, height: cutOutRadius * 2)
//            context.addEllipse(in: cutOutRect)
//            let cutOutColor = cutOutColor ?? .white
//            context.setFillColor(cutOutColor.cgColor)
//            context.fillPath()
//        }
    }
}
