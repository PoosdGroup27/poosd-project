//
//  MatchesPageConfigurations.swift
//  TutorTrade
//
//  Created by brock davis on 11/24/21.
//

import Foundation
import UIKit

extension UIView {
    static var matchesTitleContainer: UIView {
        get {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            view.layer.cornerRadius = 10
            view.layer.shadowOpacity = 0.12
            view.layer.shadowOffset = CGSize(width: 0, height: 4)
            view.backgroundColor = .white
            return view
        }
    }
    
    static var matchesPageBackgroundView: UIView {
        get {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(named: "MatchesPageColor")!
            return view
        }
    }
}

extension UIScrollView {
    static var matchesPageScrollView: UIScrollView {
        get {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.backgroundColor = UIColor(named: "MatchesPageColor")!
            return scrollView
        }
    }
}

extension UIStackView {
    static var matchesPageStackView: UIStackView {
        get {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            stackView.alignment = .fill
            stackView.spacing = 14
            return stackView
        }
    }
}

extension UIImageView {
    static var matchesImageView: UIImageView {
        get {
            let imageDimension = UIScreen.main.bounds.width / 6.81
            let imageView = UIImageView(image: UIImage(named: "MatchesTitleGraphic")!.resizedTo(CGSize(width: imageDimension, height: imageDimension)))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }
    }
}

extension UILabel {
    static var matchesPageTitle: UILabel {
        get {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.numberOfLines = 1
            label.text = "Matches"
            label.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 12.5)
            return label
        }
    }
}
