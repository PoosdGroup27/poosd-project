//
//  SchoolSelectionConfigurations.swift
//  TutorTrade
//
//  Created by brock davis on 10/29/21.
//

import UIKit

extension UIButton {
    
    static var transparentDismissButton: UIButton {
        get {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear
            return button
        }
    }
    
    static var popoverExitButton: UIButton {
        get {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setBackgroundImage(drawExitButtonImage(), for: .normal)
            return button
        }
    }
    
    private static func drawExitButtonImage() -> UIImage {
        let bounds = CGRect(x: 0, y: 0, width: 20, height: 20)
        return UIGraphicsImageRenderer(bounds: bounds).image { _ in
            let context = UIGraphicsGetCurrentContext()!
            UIColor(named: "EditButtonColor")!.setFill()
            context.addEllipse(in: bounds)
            context.fillPath()
            UIImage(named: "ExitIcon")!.draw(in: bounds)
        }
    }
}

extension UIView {
    
    static var popoverEditView: UIView {
        get {
            let popoverView = UIView()
            popoverView.translatesAutoresizingMaskIntoConstraints = false
            popoverView.backgroundColor = UIColor(named: "PopoverViewColor")
            popoverView.layer.cornerRadius = 35
            popoverView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            return popoverView
        }
    }
}

extension UILabel {
    static func editFieldLabel(withFieldName fieldName: String) -> UILabel {
            let label = UILabel()
            label.text = fieldName
            label.font = UIFont(name: "Lato-Bold", size: 26)!
            label.numberOfLines = 1
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = .black
            return label
    }
}

extension UITextField {
    static func editingTextField(withCurrentValue currentValue: String, withPlaceholder placeholder: String) -> UITextField {
            let textField = UITextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = placeholder
            textField.text = currentValue
            textField.font = UIFont(name: "Roboto-Bold", size: 12)
            textField.textColor = .black
            return textField
    }
}

extension BorderedDisplayBoxView {
    
    static func shadowedDisplayBox(withIcon icon: UIImage) -> BorderedDisplayBoxView {
        let displayBox = BorderedDisplayBoxView(iconImage: icon, iconHeightRatio: 0.3, borderColor: nil, borderWidth: 0.0, boxSize: .zero, cornerRadius: 10, boxBackgroundColor: .white, withShadow: true)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        return displayBox
    }
}


