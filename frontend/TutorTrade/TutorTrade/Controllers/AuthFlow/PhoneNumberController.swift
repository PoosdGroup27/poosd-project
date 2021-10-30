//
//  PhoneNumberController.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/27/21.
//

import UIKit

class PhoneNumberController: UIViewController, UITextFieldDelegate {
    
    private lazy var phoneNumberTitleContainerView: UIView = .phoneNumberTitleContainerView
    private lazy var phoneNumberTitleLabel: UILabel = .phoneNumberTitleLabel
    private lazy var phoneNumberDescriptionLabel: UILabel = .phoneNumberDescriptionLabel
    private lazy var phoneNumberBox: ShadowDisplayBox = .defaultDisplayBoxView(withIcon: UIImage(named: "PhoneIcon")!, iconHeightRatio: 0.32)
    private lazy var phoneNumberTextField: UITextField = .createTextField(withPlaceholder: "PhoneNumber")
    private lazy var phoneNumberButton: UIButton = .createButton(backgroundColor: .black, image: UIImage(named: "ForwardIcon")!)
    private lazy var verificationController = VerificationController()
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor(named: "AuthFlowColor")!
    }
    
    override func viewDidLoad() {
        let dismissKeyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(dismissKeyboardRecognizer)
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
        
        self.view.addSubview(phoneNumberBox) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 220),
                $0.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: UIScreen.main.bounds.width / 14.42),
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: UIScreen.main.bounds.width / -14.42),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 15)
            ])
        }

        self.phoneNumberBox.addSubview(phoneNumberTextField) {
            $0.delegate = self
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: phoneNumberBox.centerYAnchor),
                $0.heightAnchor.constraint(equalTo: phoneNumberBox.heightAnchor, multiplier: 0.7),
                $0.leadingAnchor.constraint(equalTo: phoneNumberBox.leadingAnchor, constant: 43),
                $0.trailingAnchor.constraint(equalTo: phoneNumberBox.trailingAnchor, constant: -10)
            ])
        }

        self.view.addSubview(phoneNumberButton) {
            $0.addTarget(self, action: #selector(self.phoneNumberButtonTapped), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height / 2.7),
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: UIScreen.main.bounds.width / -14.42),
                $0.widthAnchor.constraint(equalToConstant: 50),
                $0.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    @objc func phoneNumberButtonTapped() {
        self.navigationController?.pushViewController(verificationController, animated: false)
    }

    @objc func dismissKeyboard() {
        self.phoneNumberTextField.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.phoneNumberTextField.endEditing(true)
    }
}
