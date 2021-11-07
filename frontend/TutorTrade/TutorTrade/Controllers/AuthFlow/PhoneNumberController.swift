//
//  PhoneNumberController.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/27/21.
//

import UIKit
import Auth0

protocol PhoneNumberDelegate {
    func setPhoneNumber(phoneNumber: String)
}

class PhoneNumberController: UIViewController, UITextFieldDelegate {

    
    private lazy var phoneNumberTitleContainerView: UIView = .phoneNumberTitleContainerView
    private lazy var phoneNumberTitleLabel: UILabel = .phoneNumberTitleLabel
    private lazy var phoneNumberDescriptionLabel: UILabel = .phoneNumberDescriptionLabel
    private lazy var phoneNumberBox: ShadowDisplayBox = .defaultDisplayBoxView(withIcon: UIImage(named: "PhoneIcon")!, iconHeightRatio: 0.32)
    private lazy var phoneNumberTextField: UITextField = .createTextField(withPlaceholder: "Phone Number")
    private lazy var phoneNumberButton: UIButton = .createButton(backgroundColor: .black, image: UIImage(named: "ForwardIcon")!)
    private lazy var verificationController = VerificationController()
    private lazy var validatePhoneController: UIAlertController = {
        let controller = UIAlertController.init(title: "Error",
                                                message: "Please enter a valid U.S. +1 phone number.",
                                                preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: "OK", style: .cancel))
        return controller
    }()
    
    var phoneNumberDelegate: PhoneNumberDelegate!
    
    override func viewDidLoad() {
        let dismissKeyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(dismissKeyboardRecognizer)
    }

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor(named: "AuthFlowColor")!
        self.view.addSubview(phoneNumberTitleContainerView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: self.view.safeAreaLayoutGuide.topAnchor, multiplier: 8),
                $0.leadingAnchor.constraint(equalToSystemSpacingAfter: self.view.safeAreaLayoutGuide.leadingAnchor, multiplier: 4),
                $0.trailingAnchor.constraint(equalToSystemSpacingAfter: self.view.safeAreaLayoutGuide.trailingAnchor, multiplier: -4)
            ])
        }
        
        self.phoneNumberTitleContainerView.addSubview(phoneNumberTitleLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: phoneNumberTitleLabel.topAnchor),
                $0.leadingAnchor.constraint(equalTo: phoneNumberTitleContainerView.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: phoneNumberTitleContainerView.trailingAnchor)
            ])
        }
        
        self.phoneNumberTitleContainerView.addSubview(phoneNumberDescriptionLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: phoneNumberTitleContainerView.topAnchor, multiplier: 17),
                $0.leadingAnchor.constraint(equalTo: phoneNumberTitleContainerView.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: phoneNumberTitleContainerView.trailingAnchor)
            ])
        }

        self.view.addSubview(phoneNumberBox) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: phoneNumberTitleContainerView.topAnchor, multiplier: 26),
                $0.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: UIScreen.main.bounds.width / 14),
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: UIScreen.main.bounds.width / -14),
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
            $0.addTarget(self, action: #selector(self.sendOTPButton), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: phoneNumberBox.topAnchor, multiplier: 12),
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: UIScreen.main.bounds.width / -14),
                $0.widthAnchor.constraint(equalToConstant: 50),
                $0.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    func isValidPhoneNumber(phoneNumber: String) -> Bool {
        if (phoneNumber.isEmpty) {
            self.present(validatePhoneController, animated: true)
            return false
        }
        
        return true
    }

    @objc func sendOTPButton() {

        if  isValidPhoneNumber(phoneNumber: phoneNumberTextField.text!) {
            Auth0
               .authentication()
               .startPasswordless(phoneNumber: "+1" + phoneNumberTextField.text!, connection: "sms")
               .start { result in
                   switch result {
                   case .success:
                       print("Sent OTP to support@auth0.com!")
//                       self.phoneNumberDelegate.setPhoneNumber(phoneNumber: self.phoneNumberTextField.text!)
                       DispatchQueue.main.async {
                           self.navigationController?.pushViewController(self.verificationController, animated: true)
                           return
                       }
                   case .failure(let error):
                       print(error)
                       DispatchQueue.main.async {
                           self.present(self.validatePhoneController, animated: true)
                           return
                       }
                   }
               }

            return
        }
    }

    @objc func dismissKeyboard() {
        self.phoneNumberTextField.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.phoneNumberTextField.endEditing(true)

    }
}
