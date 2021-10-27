//
//  ProfileController.swift
//  TutorTrade
//
//  Serves as the root view controller for the user's profile page
//
//  Created by Brock Davis on 9/27/21.
//

import UIKit


class ProfileController: UIViewController {
    
    private let factory: ProfilePageFactory
    private let modelManager: TutorProfileManager
    private let displaySettings: AppDisplaySettings
    
    private lazy var verticalScrollView: UIScrollView = .profilePageVerticalScrollView
    private lazy var titleContainerView: UIView = .profilePageTitleContainerView
    private lazy var pageTitleLabel: UILabel =  .profilePageTitle
    private lazy var pointsButton: UIButton = .pointButton(withBalance: modelManager.profile.pointBalance)
    private lazy var profilePhotoView: CircularBorderedImageView = .profilePhotoView(withImage: modelManager.profile.profilePhoto)
    private lazy var nameAndRatingLabel: NameAndRatingLabel = .tutorNameAndRatingLabel(withFirstName: modelManager.profile.firstName, withLastName: modelManager.profile.lastName, withRating: modelManager.profile.rating)
    private lazy var schoolDisplayBoxTitle: UILabel = .fieldTitle(withText: "School")
    private lazy var schoolDisplayBoxView: BorderedDisplayBoxView  = .defaultDisplayBoxView(withIcon: UIImage(named: "SchoolIcon")!)
    private lazy var schoolDisplayBoxLabel: UILabel = .displayBoxLabel(withText: modelManager.profile.school)
    private lazy var schoolEditButton : UIButton = .fieldEditButton
    private lazy var majorDisplayBoxTitle : UILabel = .fieldTitle(withText: "Major")
    private lazy var majorDisplayBoxView : BorderedDisplayBoxView = .defaultDisplayBoxView(withIcon: UIImage(named: "MajorIcon")!)
    private lazy var majorDisplayBoxLabel : UILabel = .displayBoxLabel(withText: modelManager.profile.major)
    private lazy var majorEditButton : UIButton = .fieldEditButton
    private lazy var tutoringSubjectsTitle : UILabel = .fieldTitle(withText: "Tutoring Subjects")
    private lazy var tutoringSubjectsScrollView : TutoringSubjectsScrollView = .init(tutoringSubjects: displaySettings.tutoringSubjects, selectedTutoringSubjects: modelManager.profile.tutoringSubjects, selectionObserver: self.tutoringSubjectsDidChange(tutoringSubject:status:))
    private lazy var logOutButton : UIButton = .logOutButton
    
    private let schoolSelectionVC : UIViewController
    
    init(factory: ProfilePageFactory, modelManager : TutorProfileManager, displaySettings: AppDisplaySettings) {
        self.factory = factory
        self.modelManager = modelManager
        self.displaySettings = displaySettings
        self.schoolSelectionVC = SchoolSelectionViewController()
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    /// Instantiate views + add them to view hierarchy
    override func loadView() {
        super.loadView()
        
        // Add the containing view for title + point view
        self.view.addSubview(titleContainerView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 8)
            ])
        }
        
        // Add the page title label
        self.titleContainerView.addSubview(pageTitleLabel) {
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),
                $0.leadingAnchor.constraint(equalTo: titleContainerView.leadingAnchor, constant: UIScreen.main.bounds.width / 14)
            ])
        }
        
        // Add the points balance button
        self.titleContainerView.addSubview(pointsButton) {
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: titleContainerView.centerYAnchor),
                $0.trailingAnchor.constraint(equalTo: titleContainerView.trailingAnchor, constant: (UIScreen.main.bounds.width / 14)  * -1)
            ])
        }
        
        // Load the main vertical scroll view
        self.view.addSubview(verticalScrollView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.titleContainerView.bottomAnchor),
                $0.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                $0.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            ])
        }
        
        // Add the rounded profile photo view
        self.verticalScrollView.addSubview(profilePhotoView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: verticalScrollView.contentLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height / 30),
                $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2),
                $0.centerXAnchor.constraint(equalTo: verticalScrollView.contentLayoutGuide.centerXAnchor)
            ])
        }
        
        // Add the name + rating label
        self.profilePhotoView.addSubview(nameAndRatingLabel) {
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 3),
                $0.centerXAnchor.constraint(equalTo: profilePhotoView.centerXAnchor),
                $0.centerYAnchor.constraint(equalTo: profilePhotoView.centerYAnchor, constant: profilePhotoView.bounds.height / 4.2)
            ])
        }
        
        // Add the school box title
        self.verticalScrollView.addSubview(schoolDisplayBoxTitle) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: verticalScrollView.contentLayoutGuide.leadingAnchor, constant: UIScreen.main.bounds.width / 10),
                $0.topAnchor.constraint(equalTo: nameAndRatingLabel.bottomAnchor)
            ])
        }
        
        // Add the school display box
        self.verticalScrollView.addSubview(schoolDisplayBoxView) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: schoolDisplayBoxTitle.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: verticalScrollView.contentLayoutGuide.trailingAnchor, constant: -UIScreen.main.bounds.width / 10),
                $0.topAnchor.constraint(equalTo: schoolDisplayBoxTitle.bottomAnchor, constant: UIScreen.main.bounds.height / 80),
                $0.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        // Add the school title
        self.schoolDisplayBoxView.addSubview(schoolDisplayBoxLabel) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: schoolDisplayBoxView.leadingAnchor, constant: 60),
                $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 2.2),
                $0.centerYAnchor.constraint(equalTo: schoolDisplayBoxView.centerYAnchor)
            ])
        }
        
        // Add the school edit button
        self.schoolDisplayBoxView.addSubview(schoolEditButton) {
            $0.addTarget(self, action: #selector(schoolEditButtonTapped(sender:)), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.trailingAnchor.constraint(equalTo: schoolDisplayBoxView.trailingAnchor, constant: -15),
                $0.centerYAnchor.constraint(equalTo: schoolDisplayBoxLabel.centerYAnchor),
                $0.widthAnchor.constraint(equalToConstant: schoolDisplayBoxView.bounds.width / 6)
            ])
        }
        
        // Add the major box title
        self.verticalScrollView.addSubview(majorDisplayBoxTitle) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: schoolDisplayBoxTitle.leadingAnchor),
                $0.topAnchor.constraint(equalTo: schoolDisplayBoxView.bottomAnchor, constant: 20)
            ])
        }
        
        // Add the major display box
        self.verticalScrollView.addSubview(majorDisplayBoxView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: majorDisplayBoxTitle.bottomAnchor, constant: UIScreen.main.bounds.height / 80),
                $0.leadingAnchor.constraint(equalTo: schoolDisplayBoxView.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: schoolDisplayBoxView.trailingAnchor),
                $0.heightAnchor.constraint(equalTo: schoolDisplayBoxView.heightAnchor)
            ])
        }
        
        // Add the major title label
        self.majorDisplayBoxView.addSubview(majorDisplayBoxLabel) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: majorDisplayBoxView.leadingAnchor, constant: 60),
                $0.centerYAnchor.constraint(equalTo: majorDisplayBoxView.centerYAnchor)
            ])
        }
        
        // Add the major edit button
        self.majorDisplayBoxView.addSubview(majorEditButton) {
            NSLayoutConstraint.activate([
                $0.trailingAnchor.constraint(equalTo: majorDisplayBoxView.trailingAnchor, constant: -15),
                $0.centerYAnchor.constraint(equalTo: majorDisplayBoxView.centerYAnchor),
                $0.widthAnchor.constraint(equalToConstant: majorDisplayBoxView.bounds.width / 6)
            ])
        }
        
        // Add the tutoring subjects title
        self.verticalScrollView.addSubview(tutoringSubjectsTitle) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: majorDisplayBoxView.bottomAnchor, constant: 30),
                $0.leadingAnchor.constraint(equalTo: majorDisplayBoxTitle.leadingAnchor)
            ])
        }
        
        // Add the tutoring subjects scroll view
        self.verticalScrollView.addSubview(tutoringSubjectsScrollView) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: tutoringSubjectsTitle.bottomAnchor, constant: 15),
                $0.leadingAnchor.constraint(equalTo: tutoringSubjectsTitle.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: verticalScrollView.trailingAnchor)
            ])
        }
        
        // Add the log out button
        self.verticalScrollView.addSubview(logOutButton) {
            NSLayoutConstraint.activate([
                $0.centerXAnchor.constraint(equalTo: verticalScrollView.centerXAnchor),
                $0.topAnchor.constraint(equalTo: tutoringSubjectsScrollView.bottomAnchor, constant: 50),
                $0.heightAnchor.constraint(equalToConstant: 55),
                $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.75)
            ])
        }
        
        // Set the contentSize constraints for the vertical scroll view
        NSLayoutConstraint.activate([
            verticalScrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: logOutButton.bottomAnchor, constant: 50),
            verticalScrollView.contentLayoutGuide.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }
    
    func tutoringSubjectsDidChange(tutoringSubject: String, status: TutoringSubjectsScrollView.SubjectState) {
        print("Button was tapped")
    }

    
    @objc func schoolEditButtonTapped(sender: UIButton) {
        self.present(schoolSelectionVC, animated: true, completion: nil)
    }
}
