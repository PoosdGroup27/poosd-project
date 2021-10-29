//
//  PhoneNumberController.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/27/21.
//

import UIKit

class PhoneNumberController: UIViewController {
    
    private lazy var phoneNumberTitleContainerView: UIView = .phoneNumberTitleContainerView
    private lazy var phoneNumberTitleLabel: UILabel = .phoneNumberTitleLabel
    private lazy var phoneNumberDescriptionLabel: UILabel = .phoneNumberDescriptionLabel
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(phoneNumberTitleContainerView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 3)
            ])
        }
        
        self.phoneNumberTitleContainerView.addSubview(phoneNumberTitleLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: phoneNumberTitleContainerView.topAnchor, constant: UIScreen.main.bounds.height / 50),
                $0.leadingAnchor.constraint(equalTo: phoneNumberTitleContainerView.leadingAnchor, constant: UIScreen.main.bounds.width / 14)
            ])
        }
        
        self.phoneNumberTitleContainerView.addSubview(phoneNumberDescriptionLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: phoneNumberTitleContainerView.topAnchor, constant: UIScreen.main.bounds.height / 6),
                $0.leadingAnchor.constraint(equalTo: phoneNumberTitleContainerView.leadingAnchor, constant: UIScreen.main.bounds.width / 14)
            ])
        }
    }
}
