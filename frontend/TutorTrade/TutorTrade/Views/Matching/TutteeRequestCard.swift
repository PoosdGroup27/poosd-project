//
//  TutteeRequestCard.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 11/11/21.
//

/*
 Todo:
 1. Refactor the labels and views especially the configurations
 */

import UIKit

class TutteeRequestCard: UIScrollView {
    
    private var profilePicture: UIImage?
    private var firstName: String
    private var school: String
    private var rating: Double
    private var subject: String
    private var time: String
    private var helpDescription: String
    private var pointsBalance: Int
    private var preferredMedium: String?
    private var profilePictureView: UIImageView
    private var firstNameLabel: UILabel
    private var schoolDisplayBoxView: BorderedDisplayBoxView  = .requestCardBoxView(withIcon: UIImage(named: "SchoolIcon")!)
    private var schoolDisplayBoxLabel: UILabel
    private var ratingDisplayBoxView: BorderedDisplayBoxView  = .requestCardBoxView(withIcon: UIImage(named: "RatingIcon")!)
    private var ratingDisplayBoxLabel: UILabel
    private var subjectDisplayBoxView: BorderedDisplayBoxView  = .subjectCardBoxView(withIcon: UIImage(named: "HandRaisedIcon")!)
    private var subjectDisplayBoxLabel: UILabel
    private var urgencyDisplayBoxView: BorderedDisplayBoxView = .requestCardBoxView(withIcon: UIImage(named: "TimeIcon")!)
    private var urgencyDisplayBoxLabel: UILabel
    private var descriptionLabel: UILabel = .getTitleLabel(title: "Description", size: 15)
    private var budgetTitleLabel: UILabel = .getTitleLabel(title: "Budget", size: 12)
    private var mediumTitleLabel: UILabel = .getTitleLabel(title: "Preferred Medium", size: 12)
    private var descriptionDisplayBoxView: BorderedDisplayBoxView = .descriptionCardBoxView()
    private var descriptionDisplayBoxLabel: UILabel
    private var budgetDisplayBoxView: BorderedDisplayBoxView = .budgetCardBoxView()
    private var pointsBalanceDisplayBoxLabel: UILabel
    private var mediumDisplayBoxView: BorderedDisplayBoxView = .mediumCardBoxView()
    private var innerBudgetDisplayBoxView: BorderedDisplayBoxView = .innerBudgetCardBoxView()
    private var innerMediumDisplayBoxView: BorderedDisplayBoxView = .innerMediumCardBoxView()
    private var preferredMediumImage: UIImageView
    
    internal init(withFirstName firstName: String, withProfilePicture profilePicture: UIImage?,
                  withSchool school: String, withRating rating: Double, withSubject subject: String,
                  withTime time: String, withDescription helpDescription: String, withPointBalance pointsBalance: Int,
                  withPreferredMedium preferredMedium: String) {
        
        self.profilePicture = profilePicture
        self.firstName = firstName
        self.school = school
        self.rating = rating
        self.subject = subject
        self.time = time
        self.helpDescription = helpDescription
        self.pointsBalance = pointsBalance
        self.preferredMedium = preferredMedium
        self.schoolDisplayBoxLabel = .configureSchoolLabel(withSchoolName: school, font: UIFont(name: "Roboto-Bold", size: 12)!)
        self.ratingDisplayBoxLabel = .configureSchoolLabel(withSchoolName: String(rating), font: UIFont(name: "Roboto-Bold", size: 12)!)
        self.subjectDisplayBoxLabel = .configureSchoolLabel(withSchoolName: subject, font: UIFont(name: "Roboto-Bold", size: 12)!)
        self.urgencyDisplayBoxLabel = .configureSchoolLabel(withSchoolName: time, font: UIFont(name: "Roboto-Bold", size: 12)!)
        self.descriptionDisplayBoxLabel = .configureDescriptionLabel(withHelpDescription: helpDescription, font: UIFont(name: "Roboto-Bold", size: 12)!)
        self.firstNameLabel = .configureTutteeName(withFirstName: firstName, font: UIFont(name: "Roboto-Bold", size: 28)!)
        self.pointsBalanceDisplayBoxLabel = .pointsBalanceLabel(pointsBalance: pointsBalance)
        self.preferredMediumImage = .preferredMediumImage(preferredMedium: preferredMedium)

        self.profilePictureView = .configureTuteeProfileImage(withImage: profilePicture)

        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.showsVerticalScrollIndicator = false
        
        addSubview(profilePictureView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                $0.heightAnchor.constraint(equalToConstant: 340)
            ])
        }

        addSubview(firstNameLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: self.profilePictureView.bottomAnchor, multiplier: 3),
                $0.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 19)
            ])
        }
        
        // Add the school display box
        self.addSubview(schoolDisplayBoxView) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: firstNameLabel.leadingAnchor),
                $0.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 10),
                $0.heightAnchor.constraint(equalToConstant: 37),
                $0.widthAnchor.constraint(equalToConstant: schoolDisplayBoxLabel.intrinsicContentSize.width + 60)
            ])
        }
        
        // Add the school title
        schoolDisplayBoxView.addSubview(schoolDisplayBoxLabel) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: schoolDisplayBoxView.leadingAnchor, constant: 45),
                $0.centerYAnchor.constraint(equalTo: schoolDisplayBoxView.centerYAnchor)
            ])
        }
        
        // Add the school display box
        addSubview(ratingDisplayBoxView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 10),
                $0.leadingAnchor.constraint(equalTo: schoolDisplayBoxView.trailingAnchor, constant: 10),
                $0.heightAnchor.constraint(equalToConstant: 37),
                $0.widthAnchor.constraint(equalToConstant: 83)
            ])
        }
        
        ratingDisplayBoxView.addSubview(ratingDisplayBoxLabel) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: ratingDisplayBoxView.leadingAnchor, constant: 45),
                $0.centerYAnchor.constraint(equalTo: ratingDisplayBoxView.centerYAnchor)
            ])
        }
        
        addSubview(subjectDisplayBoxView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: schoolDisplayBoxView.bottomAnchor, constant: 10),
                $0.leadingAnchor.constraint(equalTo: firstNameLabel.leadingAnchor),
                $0.heightAnchor.constraint(equalToConstant: 37),
                $0.widthAnchor.constraint(equalToConstant: subjectDisplayBoxLabel.intrinsicContentSize.width + 60)
            ])
        }
        
        subjectDisplayBoxView.addSubview(subjectDisplayBoxLabel) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: subjectDisplayBoxView.leadingAnchor, constant: 45),
                $0.centerYAnchor.constraint(equalTo: subjectDisplayBoxView.centerYAnchor)
            ])
        }
        
        addSubview(urgencyDisplayBoxView){
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: ratingDisplayBoxView.bottomAnchor, constant: 10),
                $0.leadingAnchor.constraint(equalTo: subjectDisplayBoxView.trailingAnchor, constant: 10),
                $0.heightAnchor.constraint(equalToConstant: 37),
                $0.widthAnchor.constraint(equalToConstant: urgencyDisplayBoxLabel.intrinsicContentSize.width + 60)
            ])
        }
        
        urgencyDisplayBoxView.addSubview(urgencyDisplayBoxLabel) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: urgencyDisplayBoxView.leadingAnchor, constant: 45),
                $0.centerYAnchor.constraint(equalTo: urgencyDisplayBoxView.centerYAnchor)
            ])
        }
        
        addSubview(descriptionLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: subjectDisplayBoxView.bottomAnchor, constant: 30),
                $0.leadingAnchor.constraint(equalTo: firstNameLabel.leadingAnchor)
            ])
        }
        
        addSubview(descriptionDisplayBoxView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
                $0.leadingAnchor.constraint(equalTo: firstNameLabel.leadingAnchor),
                $0.widthAnchor.constraint(equalToConstant: 320),
                $0.heightAnchor.constraint(equalToConstant: descriptionLabel.intrinsicContentSize.height + 60)
            ])
        }
        
        descriptionDisplayBoxView.addSubview(descriptionDisplayBoxLabel) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: descriptionDisplayBoxView.leadingAnchor, constant: 10),
                $0.widthAnchor.constraint(equalTo: descriptionDisplayBoxView.widthAnchor, constant: -10),
                $0.centerYAnchor.constraint(equalTo: descriptionDisplayBoxView.centerYAnchor)
            ])
        }
        
        addSubview(budgetDisplayBoxView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: descriptionDisplayBoxView.bottomAnchor, constant: 30),
                $0.leadingAnchor.constraint(equalTo: descriptionDisplayBoxView.leadingAnchor, constant: 10),
                $0.widthAnchor.constraint(equalToConstant: 120),
                $0.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
        
        budgetDisplayBoxView.addSubview(budgetTitleLabel) {
            NSLayoutConstraint.activate([
                $0.centerXAnchor.constraint(equalTo: budgetDisplayBoxView.centerXAnchor),
                $0.centerYAnchor.constraint(equalTo: budgetDisplayBoxView.centerYAnchor, constant: -25)
            ])
        }
        
        budgetDisplayBoxView.addSubview(innerBudgetDisplayBoxView) {
            NSLayoutConstraint.activate([
                $0.centerXAnchor.constraint(equalTo: budgetDisplayBoxView.centerXAnchor),
                $0.centerYAnchor.constraint(equalTo: budgetDisplayBoxView.centerYAnchor, constant: 15),
                $0.widthAnchor.constraint(equalToConstant: 80),
                $0.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        innerBudgetDisplayBoxView.addSubview(pointsBalanceDisplayBoxLabel) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: innerBudgetDisplayBoxView.leadingAnchor, constant: 45),
                $0.centerYAnchor.constraint(equalTo: innerBudgetDisplayBoxView.centerYAnchor)
            ])
        }
        
        addSubview(mediumDisplayBoxView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: descriptionDisplayBoxView.bottomAnchor, constant: 30),
                $0.trailingAnchor.constraint(equalTo: descriptionDisplayBoxView.trailingAnchor, constant: -10),
                $0.widthAnchor.constraint(equalToConstant: 120),
                $0.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
        
        mediumDisplayBoxView.addSubview(mediumTitleLabel) {
            NSLayoutConstraint.activate([
                $0.centerXAnchor.constraint(equalTo: mediumDisplayBoxView.centerXAnchor),
                $0.centerYAnchor.constraint(equalTo: mediumDisplayBoxView.centerYAnchor, constant: -25)
            ])
        }
        
        mediumDisplayBoxView.addSubview(innerMediumDisplayBoxView) {
            NSLayoutConstraint.activate([
                $0.centerXAnchor.constraint(equalTo: mediumDisplayBoxView.centerXAnchor),
                $0.centerYAnchor.constraint(equalTo: mediumDisplayBoxView.centerYAnchor, constant: 15),
                $0.widthAnchor.constraint(equalToConstant: 80),
                $0.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        innerMediumDisplayBoxView.addSubview(preferredMediumImage) {
            NSLayoutConstraint.activate([
                $0.centerXAnchor.constraint(equalTo: innerMediumDisplayBoxView.centerXAnchor),
                $0.centerYAnchor.constraint(equalTo: innerMediumDisplayBoxView.centerYAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            self.contentLayoutGuide.bottomAnchor.constraint(equalTo: mediumDisplayBoxView.bottomAnchor, constant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
