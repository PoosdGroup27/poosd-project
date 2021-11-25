//
//  TutteeRequestCard.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 11/11/21.
//

import UIKit

class TutteeRequestCard: UIScrollView {
    
    var profilePicture: UIImage? {
        get {
            self.profilePictureView.image
        } set {
            self.profilePictureView.image = newValue ?? UIImage(named: "DefaultUserImage")!
        }
    }
    var name: String {
        get {
            self.nameLabel.text!
        } set {
            self.nameLabel.text = newValue
        }
    }
    var school: String {
        get {
            self.schoolDisplayBoxLabel.text!
        } set {
            self.schoolDisplayBoxLabel.text = newValue
        }
    }
    var rating: Double {
        get {
            Double(self.ratingDisplayBoxLabel.text!)!
        } set {
            self.ratingDisplayBoxLabel.text = String(newValue)
        }
    }
    var subject: String {
        get {
            self.subjectDisplayBoxLabel.text!
        } set {
            self.subjectDisplayBoxLabel.text = newValue
        }
    }
    var urgency: TutoringRequestUrgency {
        get {
            TutoringRequestUrgency(textRepresentation: self.urgencyDisplayBoxLabel.text!)
        }
        set {
            self.urgencyDisplayBoxLabel.text = newValue.textRepresentation
        }
    }
    var helpDescription: String {
        get {
            self.descriptionDisplayBoxLabel.text!
        } set {
            self.descriptionDisplayBoxLabel.text = newValue
        }
    }
    var pointsBudget: Int {
        get {
            Int(self.pointsBalanceDisplayBoxLabel.text!)!
        } set {
            self.pointsBalanceDisplayBoxLabel.text = String(newValue)
        }
    }
    var preferredMedium: TutoringMedium {
        didSet {
            self.preferredMediumImage = .preferredMediumImage(preferredMedium: preferredMedium)
        }
    }
    
    private var profilePictureView: UIImageView = .configureTuteeProfileImage(withImage: UIImage(named: "DefaultUserImage")!)
    private var preferredMediumImage: UIImageView = .preferredMediumImage(preferredMedium: .inPerson)
  
    private var nameLabel: UILabel = .configureTutteeNameLabel(withFont: UIFont(name: "Roboto-Bold", size: 28)!)
    private var schoolDisplayBoxLabel: UILabel = .configureLabel(withFont: UIFont(name: "Roboto-Bold", size: 12)!)
    private var ratingDisplayBoxLabel: UILabel = .configureLabel(withFont: UIFont(name: "Roboto-Bold", size: 12)!) 
    private var subjectDisplayBoxLabel: UILabel = .configureLabel(withFont: UIFont(name: "Roboto-Bold", size: 12)!)
    private var urgencyDisplayBoxLabel: UILabel = .configureLabel(withFont: UIFont(name: "Roboto-Bold", size: 12)!)
    private var descriptionLabel: UILabel = .configureRequestCardLabel(title: "Description", size: 15)
    private var budgetTitleLabel: UILabel = .configureRequestCardLabel(title: "Budget", size: 12)
    private var mediumTitleLabel: UILabel = .configureRequestCardLabel(title: "Preferred Medium", size: 12)
    private var pointsBalanceDisplayBoxLabel: UILabel = .pointsBalanceLabel
    private var descriptionDisplayBoxLabel: UILabel = .configureDescriptionLabel(font: UIFont(name: "Roboto-Bold", size: 12)!)
  
    private var schoolDisplayBoxView: BorderedDisplayBoxView  = .requestCardBoxView(withIcon: UIImage(named: "SchoolIcon")!)
    private var ratingDisplayBoxView: BorderedDisplayBoxView  = .requestCardBoxView(withIcon: UIImage(named: "RatingIcon")!)
    private var subjectDisplayBoxView: BorderedDisplayBoxView  = .subjectCardBoxView(withIcon: UIImage(named: "HandRaisedIcon")!)
    private var urgencyDisplayBoxView: BorderedDisplayBoxView = .requestCardBoxView(withIcon: UIImage(named: "TimeIcon")!)
    private var descriptionDisplayBoxView: BorderedDisplayBoxView = .descriptionCardBoxView()
    private var budgetDisplayBoxView: BorderedDisplayBoxView = .budgetCardBoxView()
    private var mediumDisplayBoxView: BorderedDisplayBoxView = .mediumCardBoxView()
    private var innerBudgetDisplayBoxView: BorderedDisplayBoxView = .innerBudgetCardBoxView()
    private var innerMediumDisplayBoxView: BorderedDisplayBoxView = .innerMediumCardBoxView()
    
    internal init(withName name: String, withProfilePicture profilePicture: UIImage?,
                  withSchool school: String, withRating rating: Double, withSubject subject: String,
                  withUrgency urgency: TutoringRequestUrgency, withDescription helpDescription: String, withPointsBudget pointsBudget: Int,
                  withPreferredMedium preferredMedium: TutoringMedium) {
        
        
        self.preferredMedium = preferredMedium
        super.init(frame: .zero)
        
        self.profilePicture = profilePicture
        self.name = name
        self.school = school
        self.rating = rating
        self.subject = subject
        self.urgency = urgency
        self.helpDescription = helpDescription
        self.pointsBudget = pointsBudget
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 5
        self.showsVerticalScrollIndicator = false
        
        addSubview(profilePictureView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                $0.heightAnchor.constraint(equalTo: $0.widthAnchor)
            ])
        }

        addSubview(nameLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: self.profilePictureView.bottomAnchor, multiplier: 3),
                $0.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 19)
            ])
        }
       
        // Add the school display box
        self.addSubview(schoolDisplayBoxView) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
                $0.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
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
                $0.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
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
                $0.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
                $0.heightAnchor.constraint(equalToConstant: 37),
                $0.widthAnchor.constraint(equalToConstant: subjectDisplayBoxLabel.intrinsicContentSize.width + 60)
            ])
        }
        
        subjectDisplayBoxView.addSubview(subjectDisplayBoxLabel) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: subjectDisplayBoxView.leadingAnchor, constant: 35),
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
                $0.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)
            ])
        }
        
        addSubview(descriptionDisplayBoxView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
                $0.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
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
