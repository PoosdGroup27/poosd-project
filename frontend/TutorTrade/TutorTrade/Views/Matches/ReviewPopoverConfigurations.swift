//
//  ReviewPopoverConfigurations.swift
//  TutorTrade
//
//  Created by brock davis on 11/29/21.
//

import Foundation
import UIKit

extension UIView {
    static var reviewPopover: UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 35
        view.backgroundColor = UIColor(named: "ReviewPopoverColor")!
        return view
    }
}

extension UILabel {
    static var reviewPopoverTitle: UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Rate your experience"
        label.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 15.5)!
        label.numberOfLines = 1
        return label
    }
}

extension UIStackView {
    static var reviewStarStackView: UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        return stackView
    }
}

extension UIButton {
    
    static var submitReviewButton: UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = UIColor(named: "SubmitReviewButtonColor")!
        button.titleLabel!.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 18.5)!
        button.layer.cornerRadius = 10
        button.setTitleColor(UIColor(named: "SubmitReviewTitleColor"), for: .normal)
        return button
    }
    
    static var starButton: UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "UnselectedRatingStar")!.resizedTo(CGSize(width: 50, height: 50)), for: .normal)
        button.setBackgroundImage(UIImage(named: "SelectedRatingStar")!.resizedTo(CGSize(width: 50, height: 50)), for: .selected)
        return button
    }
}
