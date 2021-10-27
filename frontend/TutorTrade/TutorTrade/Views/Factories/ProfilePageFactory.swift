//
//  ProfilePageFactory.swift
//  TutorTrade
//
//  Created by brock davis on 10/10/21.
//

import UIKit

protocol ProfilePageFactory {
    
    var verticalScrollView : UIScrollView { get }
    
    var titleContainerView : UIView { get }
    
    var pageTitleLabel : UILabel { get }
    
    var schoolDisplayBoxTitle : UILabel { get }
    
    var schoolDisplayBoxView : BorderedDisplayBoxView { get }
    
    var schoolEditButton : UIButton { get }
    
    var majorDisplayBoxTitle : UILabel { get }

    var majorDisplayBoxView : BorderedDisplayBoxView { get }

    var majorEditButton : UIButton { get }
    
    var tutoringSubjectsTitle : UILabel { get }
    
    var logOutButton : UIButton { get }
    
    func schoolDisplayBoxLabel(schoolName : String) -> UILabel
    
    func majorDisplayBoxLabel(majorName : String) -> UILabel
    
    func pointButton(balance: Int) -> UIButton
    
    func profilePhotoView(image: UIImage?) -> CircularBorderedImageView
    
    func tutorNameAndRatingLabel(firstName: String, lastName: String, rating: Double) -> NameAndRatingLabel
    
    func tutoringSubjectsScrollView(subjects: [String], selectedSubjects: Set<String>, selectionObserver : ((String, TutoringSubjectsScrollView.SubjectState) -> ())?) -> TutoringSubjectsScrollView

}

class DefaultProfilePageFactory : ProfilePageFactory {
    
    
    
    internal init(imageDrawer: ImageDrawer) {
        self.imageDrawer = imageDrawer
    }

    var imageDrawer : ImageDrawer
    var pageBackgroundColor = UIColor(named: "ProfilePageColor")!
    
    var verticalScrollView: UIScrollView {
        get {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.backgroundColor = pageBackgroundColor
            scrollView.showsVerticalScrollIndicator = false
            return scrollView
        }
    }
    
    var titleContainerView: UIView {
        get {
            let titleContainer = UIView()
            titleContainer.backgroundColor = .white
            titleContainer.translatesAutoresizingMaskIntoConstraints = false
            return titleContainer
        }
    }
    
    var pageTitleLabel: UILabel {
        get {
            let pageLabel = UILabel()
            pageLabel.translatesAutoresizingMaskIntoConstraints = false
            pageLabel.text = "Profile"
            pageLabel.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 12)
            pageLabel.sizeToFit()
            return pageLabel
        }
    }
    
    var schoolDisplayBoxTitle : UILabel {
        get {
            let schoolBoxTitle = UILabel()
            schoolBoxTitle.text = "School"
            schoolBoxTitle.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 22)!
            schoolBoxTitle.sizeToFit()
            schoolBoxTitle.translatesAutoresizingMaskIntoConstraints = false
            return schoolBoxTitle
        }
    }
    
    var schoolDisplayBoxView : BorderedDisplayBoxView {
        get {
            let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
            let displayBox = BorderedDisplayBoxView(iconImage: UIImage(named: "SchoolIcon")!, borderColor: .black, borderWidth: 1.5, boxSize: boxSize, cornerRadius: 10)
            displayBox.translatesAutoresizingMaskIntoConstraints = false
            displayBox.backgroundColor = pageBackgroundColor
            return displayBox
        }
    }
    
    var schoolEditButton : UIButton {
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
    
    var majorDisplayBoxTitle : UILabel {
        get {
            let majorBoxTitle = UILabel()
            majorBoxTitle.text = "Major"
            majorBoxTitle.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 22)!
            majorBoxTitle.sizeToFit()
            majorBoxTitle.translatesAutoresizingMaskIntoConstraints = false
            return majorBoxTitle
        }
    }

    var majorDisplayBoxView : BorderedDisplayBoxView {
        get {
            let boxSize = CGSize(width: UIScreen.main.bounds.width * 0.75, height: UIScreen.main.bounds.height * 0.08)
            let displayBox = BorderedDisplayBoxView(iconImage: UIImage(named: "MajorIcon")!, borderColor: .black, borderWidth: 1.5, boxSize: boxSize, cornerRadius: 10)
            displayBox.translatesAutoresizingMaskIntoConstraints = false
            displayBox.backgroundColor = pageBackgroundColor
            return displayBox
        }
    }

    var majorEditButton : UIButton {
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
    
    var tutoringSubjectsTitle: UILabel {
        get {
            let majorBoxTitle = UILabel()
            majorBoxTitle.text = "Tutoring Subjects"
            majorBoxTitle.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 22)!
            majorBoxTitle.sizeToFit()
            majorBoxTitle.translatesAutoresizingMaskIntoConstraints = false
            return majorBoxTitle
        }
    }
    
    var logOutButton: UIButton {
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
    
    func pointButton(balance: Int) -> UIButton {
        let pointButton = UIButton(type: .roundedRect)
        pointButton.translatesAutoresizingMaskIntoConstraints = false
        pointButton.setTitle(String(balance), for: .normal)
        pointButton.titleLabel!.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 26)
        pointButton.setTitleColor(.black, for: .normal)
        pointButton.sizeToFit()
        pointButton.contentHorizontalAlignment = .trailing
        pointButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 25)
        pointButton.bounds = CGRect(x: 0, y: 0, width: pointButton.bounds.width * 3.5, height: pointButton.bounds.height * 1.5)
        pointButton.setBackgroundImage(imageDrawer.drawPointButtonImage(buttonSize: pointButton.bounds.size), for: .normal)
        print(UIScreen.main.bounds)
        return pointButton
    }
    
    func profilePhotoView(image: UIImage?) -> CircularBorderedImageView {
        let profilePhoto = image ?? UIImage(named: "DefaultProfilePhoto")!
        let imageRadius = UIScreen.main.bounds.width / 2
        let photoView = CircularBorderedImageView(radius: imageRadius, image: profilePhoto, borderWidth: imageRadius / 32 , borderColor: UIColor(named: "SelectedSubjectBorderColor") , borderSpaceWidth: imageRadius / 26)
        photoView.translatesAutoresizingMaskIntoConstraints = false
        return photoView
    }
    
    func tutorNameAndRatingLabel(firstName: String, lastName: String, rating: Double) -> NameAndRatingLabel {
        let label = NameAndRatingLabel(firstName: firstName, lastName: lastName, rating: rating, font: UIFont(name: "Roboto-Bold", size: 16)!, lineSpacing: 7)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = pageBackgroundColor
        return label
    }
    
    func schoolDisplayBoxLabel(schoolName : String) -> UILabel {
        let displayLabel = UILabel()
        displayLabel.text = schoolName
        displayLabel.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 29)!
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.numberOfLines = 1
        displayLabel.minimumScaleFactor = 0.5
        displayLabel.adjustsFontSizeToFitWidth = true
        displayLabel.sizeToFit()
        return displayLabel
    }
    
    func majorDisplayBoxLabel(majorName: String) -> UILabel {
        let displayLabel = UILabel()
        displayLabel.text = majorName
        displayLabel.font = UIFont(name: "Roboto-Bold", size: UIScreen.main.bounds.width / 29)!
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        displayLabel.sizeToFit()
        return displayLabel
    }
    
    func tutoringSubjectsScrollView(subjects: [String], selectedSubjects: Set<String>, selectionObserver : ((String, TutoringSubjectsScrollView.SubjectState) -> ())?) -> TutoringSubjectsScrollView {
        let scrollView = TutoringSubjectsScrollView(tutoringSubjects: subjects, selectedTutoringSubjects: selectedSubjects, selectionObserver: selectionObserver)
        scrollView.backgroundColor = pageBackgroundColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
}

protocol ImageDrawer {
    
    func drawPointButtonImage(buttonSize: CGSize) -> UIImage
    
}

struct DefaultImageDrawer : ImageDrawer {
    
    func drawPointButtonImage(buttonSize: CGSize) -> UIImage {
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
