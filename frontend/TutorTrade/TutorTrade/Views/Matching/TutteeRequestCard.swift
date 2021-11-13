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
    private lazy var profilePictureView: UIImageView = .configureTuteeProfileImage(withImage: UIImage(named: "UserImage")!)
    private lazy var firstNameLabel: UILabel = .configureTutteeName(withFirstName: "Hannah", font: UIFont(name: "Roboto-Bold", size: 28)!)
    private lazy var schoolDisplayBoxView: BorderedDisplayBoxView  = .requestCardBoxView(withIcon: UIImage(named: "SchoolIcon")!)
    private lazy var schoolDisplayBoxLabel: UILabel = .configureSchoolLabel(withSchoolName: school, font: UIFont(name: "Roboto-Bold", size: 12)!)
    private lazy var ratingDisplayBoxView: BorderedDisplayBoxView  = .requestCardBoxView(withIcon: UIImage(named: "RatingIcon")!)
    private lazy var ratingDisplayBoxLabel: UILabel = .configureSchoolLabel(withSchoolName: String(rating), font: UIFont(name: "Roboto-Bold", size: 12)!)
    private lazy var subjectDisplayBoxView: BorderedDisplayBoxView  = .subjectCardBoxView(withIcon: UIImage(named: "HandRaisedIcon")!)
    private lazy var subjectDisplayBoxLabel: UILabel = .configureSchoolLabel(withSchoolName: subject, font: UIFont(name: "Roboto-Bold", size: 12)!)
    private lazy var urgencyDisplayBoxView: BorderedDisplayBoxView = .requestCardBoxView(withIcon: UIImage(named: "TimeIcon")!)
    private lazy var urgencyDisplayBoxLabel: UILabel = .configureSchoolLabel(withSchoolName: time, font: UIFont(name: "Roboto-Bold", size: 12)!)
    private lazy var descriptionLabel: UILabel = .getTitleLabel(title: "Description", size: 15)
    private lazy var budgetTitleLabel: UILabel = .getTitleLabel(title: "Budget", size: 12)
    private lazy var mediumTitleLabel: UILabel = .getTitleLabel(title: "Preferred Medium", size: 12)
    private lazy var descriptionDisplayBoxView: BorderedDisplayBoxView = .descriptionCardBoxView()
    private lazy var descriptionDisplayBoxLabel: UILabel = .configureDescriptionLabel(withHelpDescription: helpDescription, font: UIFont(name: "Roboto-Bold", size: 12)!)
    private lazy var budgetDisplayBoxView: BorderedDisplayBoxView = .budgetCardBoxView()
    private lazy var pointsBalanceDisplayBoxLabel: UILabel = .pointsBalanceLabel(pointsBalance: pointsBalance)
    private lazy var mediumDisplayBoxView: BorderedDisplayBoxView = .mediumCardBoxView()
    private lazy var innerBudgetDisplayBoxView: BorderedDisplayBoxView = .innerBudgetCardBoxView()
    private lazy var innerMediumDisplayBoxView: BorderedDisplayBoxView = .innerMediumCardBoxView()
    private lazy var preferredMediumImage: UIImageView = .preferredMediumImage(preferredMedium: preferredMedium!)
    
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

        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.showsVerticalScrollIndicator = false
        
        addSubview(profilePictureView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                $0.widthAnchor.constraint(equalTo: self.widthAnchor),
                $0.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -210),
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
