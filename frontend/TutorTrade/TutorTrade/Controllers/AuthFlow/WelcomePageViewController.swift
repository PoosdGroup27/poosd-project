//
//  welcomePageViewController.swift
//  TutorTrade
//
//  Created by brock davis on 10/28/21.
//

import UIKit

class WelcomePageViewController: UIViewController {
    
    private lazy var logoView: UIImageView = .tutorTradeLogoView
    private lazy var graphImageView: UIImageView = .tutorTradeGraphImageView
    private lazy var serviceDescriptionLabel: UILabel = .serviceDescriptionLabel
    private lazy var actionContainerView: UIView = .actionContainerVIew
    private lazy var getStartedButton: UIButton = .getStartedButton
    private lazy var signInButton: UIButton = .signInButton
    private lazy var termsOfServiceButton: UIButton = .termsOfServiceButton
    private lazy var privacyPolicyButton: UIButton = .privacyPolicyButton
    private lazy var phoneNumberController = PhoneNumberController()
    private lazy var createProfileViewController = CreateProfileController()

    override func loadView() {
         super.loadView()
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(logoView) {
            NSLayoutConstraint.activate([
                $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.75),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 16.24),
                $0.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                $0.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.height / 10)
            ])
        }
        
        self.view.addSubview(graphImageView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.logoView.bottomAnchor, constant: UIScreen.main.bounds.height / 10),
                $0.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.64),
                $0.widthAnchor.constraint(equalTo: $0.heightAnchor)
            ])
        }
        
        self.view.addSubview(serviceDescriptionLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.graphImageView.bottomAnchor, constant: UIScreen.main.bounds.height / 21),
                $0.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                $0.heightAnchor.constraint(equalToConstant: 35)
            ])
            
        }
        
        self.view.addSubview(actionContainerView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: serviceDescriptionLabel.bottomAnchor, constant: UIScreen.main.bounds.height / 21),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                $0.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
            
        }
        
        self.actionContainerView.addSubview(getStartedButton) {
            $0.addTarget(self, action: #selector(self.getStartedButtonTapped), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.actionContainerView.topAnchor, constant: UIScreen.main.bounds.height / 20),
                $0.leadingAnchor.constraint(equalTo: self.actionContainerView.leadingAnchor, constant: 28),
                $0.trailingAnchor.constraint(equalTo: self.actionContainerView.trailingAnchor, constant: -28),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 15)
            ])
            
        }
        
        self.actionContainerView.addSubview(signInButton) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.getStartedButton.bottomAnchor, constant: UIScreen.main.bounds.height / 27),
                $0.leadingAnchor.constraint(equalTo: self.actionContainerView.leadingAnchor, constant: UIScreen.main.bounds.width / 2.38),
                $0.trailingAnchor.constraint(equalTo: self.actionContainerView.trailingAnchor, constant: -UIScreen.main.bounds.width / 2.38),
                $0.heightAnchor.constraint(equalToConstant: 24)
            ])
            
        }
        
        self.actionContainerView.addSubview(termsOfServiceButton) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.signInButton.bottomAnchor, constant: UIScreen.main.bounds.height / 22),
                $0.leadingAnchor.constraint(equalTo: self.actionContainerView.leadingAnchor, constant: UIScreen.main.bounds.width / 5.3),
                $0.widthAnchor.constraint(equalToConstant: 90),
                $0.heightAnchor.constraint(equalToConstant: 20)
            ])
            
        }
        
        self.actionContainerView.addSubview(privacyPolicyButton) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.termsOfServiceButton.topAnchor),
                $0.widthAnchor.constraint(equalToConstant: 90),
                $0.trailingAnchor.constraint(equalTo: self.actionContainerView.trailingAnchor, constant: -UIScreen.main.bounds.width / 5.3),
                $0.heightAnchor.constraint(equalToConstant: 20)
            ])
            
        }
    }
    
    @objc func getStartedButtonTapped() {
        self.navigationController?.pushViewController(phoneNumberController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

}
