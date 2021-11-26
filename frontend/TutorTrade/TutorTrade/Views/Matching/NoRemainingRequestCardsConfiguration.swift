//
//  NoRemainingRequestCardsConfiguration.swift
//  TutorTrade
//
//  Created by brock davis on 11/24/21.
//

import Foundation
import UIKit

extension UIImageView {
    
    static var noCardsRemainingGraphic: UIImageView {
        get {
            let imageDimension = UIScreen.main.bounds.width / 2.64
            let imageView = UIImageView(image: UIImage(named: "NoCardsRemainingImage")!.resizedTo(CGSize(width: imageDimension, height: imageDimension)))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }
    }
}

extension UILabel {
    
    static var noCardsRemaingTitle: UILabel {
        get {
            let label = UILabel()
            label.text = "All caught up!"
            label.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 15)!
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textColor = UIColor(named: "NoCardsRemaingTitleColor")!
            return label
        }
    }
    
    static var noCardsRemainingParagraph: UILabel {
        get {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.text = "There’s no more requests left to match with. Check back again later!"
            label.textColor = UIColor(named: "NoCardsRemainingParagraphColor")!
            label.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 20.833)!
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 4
            label.textAlignment = .center
            return label
        }
    }
}
