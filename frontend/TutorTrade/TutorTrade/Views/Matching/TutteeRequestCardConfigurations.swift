//
//  TutteeRequestCardConfigurations.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 11/11/21.
//

import UIKit

extension UILabel {
    static func configureDescriptionLabel(title: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = title
        label.font = UIFont(name: "Roboto-Bold", size: size)
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        return label
    }
    
    static func configureRequestCardLabel(title: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = UIFont(name: "Roboto-Bold", size: size)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    static func pointsBalanceLabel(pointsBalance: Int) -> UILabel {
            let label = UILabel()
            label.text = String(pointsBalance)
            label.font = UIFont(name: "Roboto-Bold", size: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }
}

extension UIImageView {
    static func configureTuteeProfileImage(withImage image: UIImage?) -> UIImageView {
        let image = image ?? UIImage(named: "UserImage")!
        let photoView = UIImageView(image: image)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        return photoView
    }
    
    static func preferredMediumImage(preferredMedium: String) -> UIImageView {
        let image = UIImage(named: preferredMedium + "Icon")!
        let photoView = UIImageView(image: image)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        return photoView
    }
}

extension UIImage {
}

extension UIStackView {
    static var schoolAndRatingStackView: UIStackView {
        get {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .equalSpacing
            stackView.alignment = .fill
            stackView.backgroundColor = .clear
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }
    }
}

extension BorderedDisplayBoxView {
    
    static func requestCardBoxView(withIcon icon: UIImage?, iconHeightRatio: CGFloat = 0.5, boxColor: UIColor?, withShadow: Bool, borderWidth: CGFloat, cornerRadius: CGFloat) -> BorderedDisplayBoxView {
        let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
        let displayBox = BorderedDisplayBoxView(iconImage: icon, iconHeightRatio: iconHeightRatio, borderColor: .black, borderWidth: borderWidth, boxSize: boxSize, cornerRadius: cornerRadius, withShadow: withShadow)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        displayBox.backgroundColor = .clear
        displayBox.boxBackgroundColor = boxColor!
        return displayBox
    }
}
