//
//  PointsView.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/4/21.

import UIKit

class PointsView: UIView {
    
    let pointsLabel: UILabel! = {
        let label = UILabel(frame: CGRect(x: 0, y: -50, width: 374, height: 50))
        
        guard let pointsLabel = UIFont(name: "Lato-Bold", size: 25) else {
            fatalError("Failed to load Lato-Font")
        }
        
        label.font = UIFontMetrics.default.scaledFont(for: pointsLabel)
        label.text = "Budget"

        return label
    }()
    
    let availableBalanceLabel: UILabel! = {
        let label = UILabel(frame: CGRect(x: 150, y: 0, width: 374, height: 50))
        
        guard let pointsLabel = UIFont(name: "Lato-Bold", size: 15) else {
            fatalError("Failed to load Lato-Font")
        }
        
        label.font = UIFontMetrics.default.scaledFont(for: pointsLabel)
        label.text = "Available balance:"

        return label
    }()
    
    let availableBalance: UILabel! = {
        let label = UILabel(frame: CGRect(x: 150, y: 30, width: 374, height: 50))
        
        guard let pointsLabel = UIFont(name: "Lato-Bold", size: 25) else {
            fatalError("Failed to load Lato-Font")
        }
        
        label.font = UIFontMetrics.default.scaledFont(for: pointsLabel)
        label.text = "200"

        return label
    }()
    
    let reducePointsButton: UIButton! = {
        let button = UIButton(frame: CGRect(x: 15, y: 75, width: 50, height: 50))
        
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = button.frame.width / 2
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        let image = UIImage(systemName: "minus")?.withTintColor(.black)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    let addPointsButton: UIButton! = {
        let button = UIButton(frame: CGRect(x: 75, y: 75, width: 50, height: 50))
        
        button.backgroundColor = UIColor.lightGray
        button.layer.cornerRadius = button.frame.width / 2
        button.layer.masksToBounds = true
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        
        let image = UIImage(systemName: "plus")?.withTintColor(.black)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        
        return button
    }()
    
    // create the textfield
    let pointsTextField: UITextField! = {
        let textField = UITextField(frame: CGRect(x: 15, y: 25, width: 110, height: 50))
        
        guard let pointsTextFieldFont = UIFont(name: "Lato-Bold", size: 20) else {
            fatalError("Failed to load Lato-Font")
        }
        
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.textColor = .black
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 20
        textField.placeholder = "0"
        textField.font = UIFontMetrics.default.scaledFont(for: pointsTextFieldFont)
        textField.keyboardType = .numberPad
        
        return textField
    }()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 700, width: 350, height: 100))
        self.backgroundColor = .systemGreen
        self.layer.cornerRadius = 20
        self.addSubview(pointsLabel)
        self.addSubview(pointsTextField)
        self.addSubview(availableBalanceLabel)
        self.addSubview(availableBalance)
    }
}
