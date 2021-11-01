//
//  PhoneNumberController.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/27/21.
//

import UIKit
import Auth0

class PhoneNumberController: UIViewController, UITextFieldDelegate {
    
    private lazy var phoneNumberTitleContainerView: UIView = .phoneNumberTitleContainerView
    private lazy var phoneNumberTitleLabel: UILabel = .phoneNumberTitleLabel
    private lazy var phoneNumberDescriptionLabel: UILabel = .phoneNumberDescriptionLabel
    private lazy var phoneNumberBox: ShadowDisplayBox = .defaultDisplayBoxView(withIcon: UIImage(named: "PhoneIcon")!, iconHeightRatio: 0.32)
    private lazy var phoneNumberTextField: UITextField = .createTextField(withPlaceholder: "PhoneNumber")
    private lazy var phoneNumberButton: UIButton = .createButton(backgroundColor: .black, image: UIImage(named: "ForwardIcon")!)
    private lazy var verificationController = VerificationController()
    private lazy var validateController: UIAlertController = {
        let controller = UIAlertController.init(title: "Re-enter phone number",
                                                message: "Invalid phone number, please enter a valid phone number.",
                                                preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: "OK", style: .cancel))
        return controller
    }()

    
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
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 70),
                $0.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
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
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 275),
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
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height / 2.3),
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: UIScreen.main.bounds.width / -14.42),
                $0.widthAnchor.constraint(equalToConstant: 50),
                $0.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    func isValidPhoneNumber(phoneNumber: String) -> Bool {
        if (phoneNumber.isEmpty) {
            return false
        }
        
        return true
    }

    @objc func phoneNumberButtonTapped() {

        // Check valid phone numbers for auth0
        let validPhoneNumber = isValidPhoneNumber(phoneNumber: phoneNumberTextField.text!)

        
        if (validPhoneNumber) {
            let number = "+1" + phoneNumberTextField.text!

            AuthManager.shared.setPhoneNumber(phoneNumber: number)

            Auth0
               .authentication()
               .startPasswordless(phoneNumber: AuthManager.shared.userPhoneNumber)
               .start { result in
                   switch result {
                   case .success:
                       print("Sent OTP to support@auth0.com!")
                   case .failure(let error):
                       print(error)
                   }
               }

            self.navigationController?.pushViewController(verificationController, animated: true)
            return
        }
        
        self.present(self.validateController, animated: true)
    }

    @objc func dismissKeyboard() {
        self.phoneNumberTextField.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.phoneNumberTextField.endEditing(true)
    }
}
