//
//  SchoolSelectionViewFactory.swift
//  TutorTrade
//
//  Created by brock davis on 10/25/21.
//

import UIKit


protocol SchoolSelectionViewFactory {
    
    var popoverView : UIView { get }
    
    var backgroundTapExitView : UIButton { get }
    
    var exitButton : UIButton { get }
    
    var schoolTextField : UITextField { get }
    
    var schoolTextBox : BorderedDisplayBoxView { get }
    
}

class DefaultSchoolSelectionViewFactory : SchoolSelectionViewFactory {
    
    var backgroundTapExitView: UIButton {
        get {
            let backgroundExitView = UIButton(frame: .zero)
            backgroundExitView.backgroundColor = .clear
            backgroundExitView.translatesAutoresizingMaskIntoConstraints = false
            return backgroundExitView
        }
    }
    
    var schoolTextField: UITextField {
        get {
            let schoolTextField = UITextField()
            schoolTextField.placeholder = "School Name"
            return schoolTextField
        }
    }
    
    var schoolTextBox: BorderedDisplayBoxView {
        get {
            BorderedDisplayBoxView(borderColor: .blue, borderWidth: 3.0, boxSize: .zero)
        }
    }
    
    
    var popoverView: UIView {
        get {
            UIView()
        }
    }
    
    var exitButton : UIButton {
        get {
            UIButton()
        }
    }
}
