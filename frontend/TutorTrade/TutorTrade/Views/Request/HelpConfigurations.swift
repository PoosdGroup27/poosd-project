//
//  HelpConfigurations.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 11/22/21.
//

import Foundation
import UIKit


extension UIScrollView {
    static var helpPageScrollView : UIScrollView {
        get {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.backgroundColor = UIColor(named: "ProfilePageColor")!
            return scrollView
        }
    }
}

extension UIView {
    static var helpTitleContainer: UIView {
        get {
            let container = UIView()
            container.backgroundColor = .white
            container.translatesAutoresizingMaskIntoConstraints = false
            return container
        }
    }
}

extension UILabel {
    static var helpTitleLabel: UILabel {
        get {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "✋ Get Help:"
            label.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 12)
            return label
        }
    }
    
    static var subjectLabel: UILabel {
        get {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "Subject"
            label.font = UIFont(name: "Lato-Bold", size: 25)
            return label
        }
    }
    
    static func requestLabel(text: String) -> UILabel{
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont(name: "Lato-Bold", size: 25)
        return label
    }
    
    static func budgetHelpLabel() -> UILabel{
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Available Balance:"
        label.font = UIFont(name: "Lato-Bold", size: 15)
        return label
    }
    
    static func actualBudgetLabel(points: Int) -> UILabel{
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = String(points)
        label.font = UIFont(name: "Lato-Bold", size: 24)
        return label
    }
    
    static func getMediumLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font =  UIFont(name: "Lato-Bold", size: 13)
        return label
    }
}

extension ShadowDisplayBox {
    
    static func helpShadowDisplayBox(withIcon icon: UIImage, iconHeightRatio: CGFloat = 0.5) -> ShadowDisplayBox {
        let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
        let displayBox = ShadowDisplayBox(iconImage: icon, iconHeightRatio: iconHeightRatio, borderColor: .white, borderWidth: 1.5,
                                          boxSize: boxSize, cornerRadius: 10, shadowColor: UIColor.black.cgColor, shadowOpacity: 0.25,
                                          shadowOffset: CGSize(width: 4, height: 4), shadowRadius: 4)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        displayBox.backgroundColor = .clear
        return displayBox
    }
}

extension UITextField {
    static var subjectsTextField: UITextField {
        get {
            let textfield = UITextField()
            textfield.translatesAutoresizingMaskIntoConstraints = false
            textfield.placeholder = "Choose Subject"
            textfield.font = UIFont(name: "Lato-Bold", size: 15)
            return textfield
        }
    }
    
    static var descriptionTextField: UITextField {
        get {
            let textfield = UITextField()
            textfield.translatesAutoresizingMaskIntoConstraints = false
            textfield.placeholder = "What do you need help with?"
            textfield.font = UIFont(name: "Lato-Bold", size: 15)
            textfield.contentVerticalAlignment = .top
            return textfield
        }
    }
    
    static var budgetTextField: UITextField {
        get {
            let textfield = UITextField()
            textfield.translatesAutoresizingMaskIntoConstraints = false
            textfield.placeholder = "0"
            textfield.keyboardType = .numberPad
            textfield.font = UIFont(name: "Lato-Bold", size: 18)
            return textfield
        }
    }
}

extension UIButton {
    static func getUrgencyButtons() -> [UIButton] {
        
        var buttons = [UIButton]()
        let titles = ["Today", "Tomorrow", "This week"]
        
        for i in 0...2 {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(named: "UrgencyButtonColor")!
            button.layer.cornerRadius = 20
            button.clipsToBounds = true
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.setTitle(titles[i], for: .normal)
            button.tag = i
            button.titleLabel?.font = UIFont(name: "Lato-Bold", size: 15)
            button.setTitleColor(.black, for: .normal)
            
            buttons.insert(button, at: i)
        }
        
        return buttons
    }
    
    static func getMediumButtons() -> [UIButton] {
        var buttons = [UIButton]()
        let icons = [UIImage(systemName: "person.2.fill"), UIImage(systemName: "desktopcomputer")]
        for i in 0...1 {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(named: "UrgencyButtonColor")!
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 30
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.black.cgColor
            button.tag = i
            button.setImage(icons[i], for: .normal)
            button.imageView?.tintColor = .black
            buttons.insert(button, at: i)
            
        }

        return buttons
    }
    
    static var submitButton: UIButton {
        get {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(named: "BlueButton")!
            button.layer.cornerRadius = 20
            button.setTitle("Submit", for: .normal)
            button.titleLabel?.font = UIFont(name: "Lato-Bold", size: 17)
            button.layer.shadowOpacity = 0.2
            button.layer.shadowOffset = CGSize(width: 5, height: 5)
            return button
        }
    }
}

extension BorderedDisplayBoxView {
    static func helpDescriptionCardBoxView() -> BorderedDisplayBoxView {
        let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
        let displayBox = BorderedDisplayBoxView(iconImage: nil, iconHeightRatio: 0.5, borderColor: nil, borderWidth: 0, boxSize: boxSize, cornerRadius: 10, boxBackgroundColor: .white, withShadow: true)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        return displayBox
    }
    
    static func pointBalanceTextFieldDisplayBox() -> BorderedDisplayBoxView {
        let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
        let displayBox = BorderedDisplayBoxView(iconImage: UIImage(named: "PointIcon")!, iconHeightRatio: 0.5, borderColor: .black, borderWidth: 1, boxSize: boxSize, cornerRadius: 10, boxBackgroundColor: .white, withShadow: false)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        return displayBox
    }
}
