//
//  TutteeRequestCard.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 11/11/21.
//

import UIKit

class TutteeRequestCard: UIScrollView {
    
    private var profilePicture: UIImage?
    private var firstName: String
    private lazy var profilePictureView: UIImageView = .configureTuteeProfileImage(withImage: UIImage(named: "UserImage")!)
    private lazy var firstNameLabel: UILabel = .configureTutteeName(withFirstName: "Hannah", font: UIFont(name: "Roboto-Bold", size: 28)!)

    internal init(withFirstName firstName: String, withProfilePicture profilePicture: UIImage?) {
        
        self.profilePicture = profilePicture
        self.firstName = firstName

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
                $0.bottomAnchor.constraint(equalToSystemSpacingBelow: self.profilePictureView.bottomAnchor, multiplier: 8),
                $0.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor)
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}
