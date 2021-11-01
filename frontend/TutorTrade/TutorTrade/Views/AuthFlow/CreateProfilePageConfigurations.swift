//
//  CreateProfilePageConfigurations.swift
//  TutorTrade
//
//  Created by brock davis on 10/29/21.
//

import UIKit

extension UIScrollView {
    
    static var createProfilePageVerticalScrollView: UIScrollView {
        get {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.backgroundColor = UIColor(named: "WelcomePageBackgroundColor")!
            scrollView.showsVerticalScrollIndicator = false
            return scrollView
        }
    }
}

extension UILabel {
    
    static var createAccountTitle: UILabel {
        get {
            let label = UILabel()
            label.font = UIFont(name: "Lato-Black", size: 28)!
            label.text = "Create your account"
            label.numberOfLines = 1
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }
    }
}

extension UIButton {
    
    static var explainButton: UIButton {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "ExplainIcon")!, for: .normal)
        return button
    }
    
    static var createAccountButton: UIButton {
        get {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .clear
            button.setTitle("Create account", for: .normal)
            button.titleLabel!.font = UIFont(name: "Lato-Bold", size: 20)!
            button.setTitleColor(.white, for: .normal)
            button.setBackgroundImage(.roundedRect(size: CGSize(width: 320, height: 55), cornerRadius: 30, fillColor: UIColor(named: "CreateAccountButtonColor")!), for: .normal)
            return button
        }
    }
}

extension UITextField {
    
    static func profileCreationTextField(withPlaceholder placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = UIFont(name: "Lato-Bold", size: 12)!
        textField.textColor = UIColor(named: "ProfileTextFieldColor")!
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
