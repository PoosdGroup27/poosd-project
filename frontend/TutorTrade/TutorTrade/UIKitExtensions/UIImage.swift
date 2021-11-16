//
//  UIImage.swift
//  TutorTrade
//
//  Created by brock davis on 10/29/21.
//

import UIKit

extension UIImage {
    
    static func roundedRect(size: CGSize, cornerRadius: CGFloat, fillColor: UIColor = .white) -> UIImage {
        UIGraphicsImageRenderer(size: size).image { _ in
            let context = UIGraphicsGetCurrentContext()!
            context.setFillColor(fillColor.cgColor)
            context.addPath(UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: cornerRadius).cgPath)
            context.fillPath()
        }
    }
    
    func resizedTo(_ newSize: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: newSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
    }
}
