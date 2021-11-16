//
//  TutteeRequestCardConfigurations.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 11/11/21.
//

import UIKit

extension UILabel {
    static func configureTutteeNameLabel(withFont font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        return label
    }
    
    static func configureLabel(withText text: String? = nil, withFont font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = font
        return label
    }
    
    static func configureRatingLabel(withRating rating: Double, font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = String(rating)
        label.font = font
        return label
    }
    
    static func configureDescriptionLabel(font: UIFont) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
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
  
    static var pointsBalanceLabel: UILabel {
            let label = UILabel()
            label.font = UIFont(name: "Roboto-Bold", size: 12)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }
    
    static var yesOverlayLabel: UILabel {
        get {
            let label = UILabel()
            label.text = "👍"
            label.transform = CGAffineTransform(rotationAngle: .pi/180 * 10)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Roboto-Bold", size: 30)!
            label.textColor = .white
            label.textAlignment = .center
            label.layer.cornerRadius = 5
            label.layer.masksToBounds = true
            label.backgroundColor = UIColor(named: "YesOverlayColor")
            return label
        }
    }
    
    static var noOverlayLabel: UILabel {
        get {
            let label = UILabel()
            label.text = "👎"
            label.transform = CGAffineTransform(rotationAngle: .pi/180 * -10)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = UIFont(name: "Roboto-Bold", size: 30)!
            label.textColor = .white
            label.textAlignment = .center
            label.layer.cornerRadius = 5
            label.layer.masksToBounds = true
            label.backgroundColor = UIColor(named: "NoOverlayColor")
            return label
        }
    }
}

extension UIImageView {
    static func configureTuteeProfileImage(withImage image: UIImage?) -> UIImageView {
        let image = image ?? UIImage(named: "UserImage")!
        let photoView = UIImageView(image: image)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        return photoView
    }
    
    static func preferredMediumImage(preferredMedium: TutoringMedium) -> UIImageView {
        let image: UIImage
        switch preferredMedium {
        case .inPerson:
            image = UIImage(named: "InPersonIcon")!
        case .online:
            image = UIImage(named: "OnlineIcon")!
        }

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
    
    static func requestCardBoxView(withIcon icon: UIImage, iconHeightRatio: CGFloat = 0.5) -> BorderedDisplayBoxView {
        let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
        let displayBox = BorderedDisplayBoxView(iconImage: icon, iconHeightRatio: iconHeightRatio, borderColor: .black, borderWidth: 1.5, boxSize: boxSize, cornerRadius: 35)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        displayBox.backgroundColor = .clear
        return displayBox
    }
    
    static func subjectCardBoxView(withIcon icon: UIImage, iconHeightRatio: CGFloat = 0.5) -> BorderedDisplayBoxView {
        let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
        let displayBox = BorderedDisplayBoxView(iconImage: icon, iconHeightRatio: iconHeightRatio, borderColor: .black, borderWidth: 1.5, boxSize: boxSize, cornerRadius: 35)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        displayBox.boxBackgroundColor = UIColor(named: "SubjectBoxColor")!
        displayBox.borderWidth = 0
        return displayBox
    }
    
    static func descriptionCardBoxView() -> BorderedDisplayBoxView {
        let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
        let displayBox = BorderedDisplayBoxView(iconImage: nil, iconHeightRatio: 0.5, borderColor: nil, borderWidth: 0, boxSize: boxSize, cornerRadius: 10, boxBackgroundColor: UIColor(named: "DescriptionBoxColor")!, withShadow: false)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        return displayBox
    }
    
    static func budgetCardBoxView() -> BorderedDisplayBoxView {
        let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
        let displayBox = BorderedDisplayBoxView(iconImage: nil, iconHeightRatio: 0.5, borderColor: nil, borderWidth: 0, boxSize: boxSize, cornerRadius: 10, boxBackgroundColor: UIColor(named: "SubjectBoxColor")!, withShadow: true)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        return displayBox
    }
    
    static func mediumCardBoxView() -> BorderedDisplayBoxView {
        let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
        let displayBox = BorderedDisplayBoxView(iconImage: nil, iconHeightRatio: 0.5, borderColor: nil, borderWidth: 0, boxSize: boxSize, cornerRadius: 10, boxBackgroundColor: UIColor(named: "MediumBoxColor")!, withShadow: true)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        return displayBox
    }
    
    static func innerBudgetCardBoxView() -> BorderedDisplayBoxView {
        let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
        let displayBox = BorderedDisplayBoxView(iconImage: UIImage(named: "PointIcon"), iconHeightRatio: 0.5, borderColor: nil, borderWidth: 0, boxSize: boxSize, cornerRadius: 10, boxBackgroundColor: UIColor(named: "InnerBudgetBoxColor")!, withShadow: false)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        return displayBox
    }
    
    static func innerMediumCardBoxView() -> BorderedDisplayBoxView {
        let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
        let displayBox = BorderedDisplayBoxView(iconImage: nil, iconHeightRatio: 0.5, borderColor: nil, borderWidth: 0, boxSize: boxSize, cornerRadius: 10, boxBackgroundColor: UIColor(named: "InnerMediumBoxColor")!, withShadow: false)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        return displayBox
    }
}
