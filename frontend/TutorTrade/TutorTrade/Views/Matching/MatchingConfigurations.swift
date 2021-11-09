//
//  MatchingConfigurations.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 11/8/21.
//

import UIKit

extension UIView {
    static var matchingPageTitleContainerView: UIView {
        get {
            let titleContainer = UIView()
            titleContainer.backgroundColor = UIColor(named: "MatchingPageColor")!
            titleContainer.translatesAutoresizingMaskIntoConstraints = false
            return titleContainer
        }
    }
}

extension UIButton {
    static var filterButton: UIButton {
        get {
            let button = UIButton()
            button.setImage(UIImage(named: "FilterImage")!, for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }
    }
}

extension UIImageView {
    
    static var matchingTitleImage: UIImageView {
        get {
            let imageView = UIImageView(image: UIImage(named: "MatchingLogoImage")!)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }
    }
}

extension UIScrollView {
    static var cardScrollView: UIScrollView {
        get {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.backgroundColor = .red
            scrollView.showsVerticalScrollIndicator = false
            return scrollView
        }
    }
}
