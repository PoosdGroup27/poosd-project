//
//  ProfilePageConfigurations.swift
//  TutorTrade
//
//  Created by brock davis on 10/26/21.
//

import UIKit

extension UIScrollView {
    
    static var profilePageVerticalScrollView : UIScrollView {
        get {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.backgroundColor = UIColor(named: "ProfilePageColor")!
            scrollView.showsVerticalScrollIndicator = false
            return scrollView
        }
    }
}


extension UIView {
    static var profilePageTitleContainerView : UIView {
        get {
            let titleContainer = UIView()
            titleContainer.backgroundColor = .white
            titleContainer.translatesAutoresizingMaskIntoConstraints = false
            return titleContainer
        }
    }
}

extension UILabel {
    static var profilePageTitle: UILabel {
        get {
            let pageLabel = UILabel()
            pageLabel.translatesAutoresizingMaskIntoConstraints = false
            pageLabel.text = "Profile"
            pageLabel.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 12)
            pageLabel.sizeToFit()
            return pageLabel
        }
    }
    
    static func fieldTitle(withText text: String, withFont font: UIFont = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 22)!) -> UILabel {
        let fieldTitle = UILabel()
        fieldTitle.text = text
        fieldTitle.font = font
        fieldTitle.sizeToFit()
        fieldTitle.translatesAutoresizingMaskIntoConstraints = false
        return fieldTitle
    }
    
    static func displayBoxLabel(withText text: String, withFont font: UIFont = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 29)!) -> UILabel {
        let displayLabel = UILabel()
        displayLabel.text = text
        displayLabel.font = font
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.numberOfLines = 1
        displayLabel.minimumScaleFactor = 0.5
        displayLabel.adjustsFontSizeToFitWidth = true
        displayLabel.sizeToFit()
        return displayLabel
    }
}

extension BorderedDisplayBoxView {
    
    static func defaultDisplayBoxView(withIcon icon: UIImage) -> BorderedDisplayBoxView {
        let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
        let displayBox = BorderedDisplayBoxView(iconImage: icon, borderColor: .black, borderWidth: 1.5, boxSize: boxSize, cornerRadius: 10)
        displayBox.translatesAutoresizingMaskIntoConstraints = false
        displayBox.backgroundColor = .clear
        return displayBox
    }
}

extension UIButton {
    static var fieldEditButton : UIButton {
        get {
            let editButton = UIButton()
            editButton.setTitle("Edit", for: .normal)
            editButton.titleLabel!.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 29)!
            editButton.setTitleColor(.black, for: .normal)
            editButton.layer.cornerRadius = 6
            editButton.contentVerticalAlignment = .center
            editButton.translatesAutoresizingMaskIntoConstraints = false
            editButton.backgroundColor = UIColor(named: "EditButtonColor")!
            return editButton
        }
    }
    
    static var logOutButton: UIButton {
        get {
            let button = UIButton()
            button.backgroundColor = UIColor(named: "LogOutButtonColor")!
            button.setTitleColor(.white, for: .normal)
            button.setTitle("Log out", for: .normal)
            button.titleLabel!.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 17.5)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.layer.cornerRadius = 15
            return button
        }
    }
    
    static func pointButton(withBalance balance: Int) -> UIButton {
        let pointButton = UIButton(type: .roundedRect)
        pointButton.translatesAutoresizingMaskIntoConstraints = false
        pointButton.setTitle(String(balance), for: .normal)
        pointButton.titleLabel!.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 26)
        pointButton.setTitleColor(.black, for: .normal)
        pointButton.sizeToFit()
        pointButton.contentHorizontalAlignment = .trailing
        pointButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
        pointButton.bounds = CGRect(x: 0, y: 0, width: pointButton.bounds.width * 3.5, height: pointButton.bounds.height * 1.5)
        pointButton.setBackgroundImage(drawPointButtonImage(buttonSize: pointButton.bounds.size), for: .normal)
        return pointButton
    }
    
    private static func drawPointButtonImage(buttonSize: CGSize) -> UIImage {
        UIGraphicsImageRenderer(size: buttonSize).image { _ in
            let context = UIGraphicsGetCurrentContext()!
            context.setLineWidth(1.5)
            let borderRect = CGRect(x: 1.5, y: 1.5, width: buttonSize.width - 3, height: buttonSize.height - 3)
            let borderPath = UIBezierPath(roundedRect: borderRect, cornerRadius: 20).cgPath
            context.addPath(borderPath)
            context.strokePath()
            let imageSize = CGSize(width: buttonSize.height / 1.8, height: buttonSize.height / 1.8)
            let imageOrigin = CGPoint(x: borderRect.midX / 4, y: borderRect.midY - (imageSize.height / 2))
            UIImage(named: "PointIcon")!.draw(in: CGRect(origin: imageOrigin, size: imageSize))
        }
    }
}

extension CircularBorderedImageView {
    
    static func profilePhotoView(withImage image: UIImage?) -> CircularBorderedImageView {
        let image = image ?? UIImage(named: "DefaultProfilePhoto")!
        let imageRadius = UIScreen.main.bounds.width / 2
        let photoView = CircularBorderedImageView(radius: imageRadius, image: image, borderWidth: imageRadius / 32 , borderColor: UIColor(named: "SelectedSubjectBorderColor") , borderSpaceWidth: imageRadius / 26)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        return photoView
    }
}

extension NameAndRatingLabel {
    
    static func tutorNameAndRatingLabel(withFirstName firstName: String, withLastName lastName: String, withRating rating: Double) -> NameAndRatingLabel {
        let label = NameAndRatingLabel(firstName: firstName, lastName: lastName, rating: rating, font: UIFont(name: "Roboto-Bold", size: 16)!, lineSpacing: 7)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(named: "ProfilePageColor")!
        return label
    }
}
