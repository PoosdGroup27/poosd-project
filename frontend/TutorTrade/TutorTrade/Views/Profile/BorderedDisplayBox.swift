//
//  BorderedDisplayBox.swift
//  TutorTrade
//
//  Created by brock davis on 10/11/21.
//

import UIKit

class BorderedDisplayBoxView: UIView {
    
    
    var iconImage : UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var iconHeightRatio: CGFloat
    
    var borderColor : UIColor?
    
    var borderWidth : CGFloat
    
    var cornerRadius : CGFloat?
    
    var boxBackgroundColor: UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    private let titleLayer : CATextLayer
    
    internal init(iconImage: UIImage? = nil, iconHeightRatio: CGFloat = 0.5, borderColor: UIColor?, borderWidth: CGFloat, boxSize: CGSize, cornerRadius: CGFloat = 20.0, boxBackgroundColor: UIColor? = .white, withShadow: Bool = false) {
        self.iconImage = iconImage
        self.iconHeightRatio = iconHeightRatio
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.titleLayer = CATextLayer()
        self.cornerRadius = cornerRadius
        self.boxBackgroundColor = boxBackgroundColor
        super.init(frame: CGRect(origin: .zero, size: boxSize))
        self.backgroundColor = .clear
        if withShadow {
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 5, height: 5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        context.setLineWidth(borderWidth)
        borderColor?.setStroke()
        boxBackgroundColor?.setFill()
        let borderRect = self.bounds.insetBy(dx: borderWidth, dy: borderWidth)
        let rectPath = UIBezierPath(roundedRect: borderRect, cornerRadius: self.cornerRadius ?? 0).cgPath
        self.layer.shadowPath = rectPath
        context.addPath(rectPath)
        context.drawPath(using: (borderColor == nil) ? .fill : .fillStroke)
        if let iconImage = iconImage {
            let imageRect = CGRect(x: borderRect.origin.x + 15, y: borderRect.midY - (borderRect.height * (iconHeightRatio / 2)), width: borderRect.height * iconHeightRatio, height: borderRect.height * iconHeightRatio)
            iconImage.draw(in: imageRect)
        }
    }
}
