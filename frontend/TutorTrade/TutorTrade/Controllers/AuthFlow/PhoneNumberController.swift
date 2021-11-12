//
//  PhoneNumberController.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/27/21.
//

import UIKit
import Auth0


class PhoneNumberController: UIViewController, UITextFieldDelegate {

    private lazy var backButton: UIButton = .backButton
    private lazy var phoneNumberTitleLabel: UILabel = .phoneNumberTitleLabel
    private lazy var phoneNumberDescriptionLabel: UILabel = .phoneNumberDescriptionLabel
    private lazy var countryCodeContainer: UIView = .countryCodeContainer
    private lazy var countryCodeLabel: UILabel = .countryCodeLabel
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
    private let phoneNumberFilterPattern = try! NSRegularExpression(pattern: "[^0-9]")
    private var notificationToken: NSObjectProtocol!
    private var phoneNumberButtonBottomLayoutConstraint: NSLayoutConstraint!
    
    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor(named: "AuthFlowColor")!
        
        self.view.addSubview(backButton) {
            $0.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: UIScreen.main.bounds.width / 17.85),
                $0.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.height / 12)
            ])
        }
        
        self.view.addSubview(phoneNumberTitleLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.backButton.bottomAnchor, constant: 30),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: UIScreen.main.bounds.width / 10),
                $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -UIScreen.main.bounds.width / 7.35)
            ])
        }
        
        self.view.addSubview(phoneNumberDescriptionLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.phoneNumberTitleLabel.bottomAnchor, constant: UIScreen.main.bounds.height / 15.92),
                $0.leadingAnchor.constraint(equalTo: phoneNumberTitleLabel.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: phoneNumberTitleLabel.trailingAnchor)
            ])
        }
        
        self.view.addSubview(countryCodeContainer) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: phoneNumberDescriptionLabel.bottomAnchor, constant: UIScreen.main.bounds.height / 23.2),
                $0.leadingAnchor.constraint(equalTo: phoneNumberDescriptionLabel.leadingAnchor),
                $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 5.6),
                $0.heightAnchor.constraint(equalToConstant:  UIScreen.main.bounds.height / 15)
            ])
        }
        
        self.countryCodeContainer.addSubview(countryCodeLabel) {
            NSLayoutConstraint.activate([
                $0.centerXAnchor.constraint(equalTo: self.countryCodeContainer.centerXAnchor),
                $0.centerYAnchor.constraint(equalTo: self.countryCodeContainer.centerYAnchor)
            ])
        }

        self.view.addSubview(phoneNumberBox) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.countryCodeContainer.topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.countryCodeContainer.trailingAnchor, constant: 6),
                $0.trailingAnchor.constraint(equalTo: self.phoneNumberDescriptionLabel.trailingAnchor),
                $0.heightAnchor.constraint(equalTo: self.countryCodeContainer.heightAnchor)
            ])
        }

        self.phoneNumberBox.addSubview(phoneNumberTextField) {
            $0.delegate = self
            $0.keyboardType = .numberPad
            $0.autocorrectionType = .no
            $0.textContentType = .sublocality
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: phoneNumberBox.centerYAnchor),
                $0.heightAnchor.constraint(equalTo: phoneNumberBox.heightAnchor, multiplier: 0.7),
                $0.leadingAnchor.constraint(equalTo: phoneNumberBox.leadingAnchor, constant: 43),
                $0.trailingAnchor.constraint(equalTo: phoneNumberBox.trailingAnchor, constant: -10)
            ])
        }

        self.view.addSubview(phoneNumberButton) {
            $0.addTarget(self, action: #selector(self.sendOTPButton), for: .touchUpInside)
            self.phoneNumberButtonBottomLayoutConstraint = $0.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -UIScreen.main.bounds.height / 2.7138)
            NSLayoutConstraint.activate([
                self.phoneNumberButtonBottomLayoutConstraint,
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: UIScreen.main.bounds.width / -14),
                $0.widthAnchor.constraint(equalToConstant: 50),
                $0.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    func isValidPhoneNumber(phoneNumber: String) -> Bool {
    
        return phoneNumberFilterPattern.numberOfMatches(in: phoneNumber, range: NSRange(location: 0, length: phoneNumber.count)) == 0
        && phoneNumber.count == 10
    }

    @objc func sendOTPButton() {
        if  isValidPhoneNumber(phoneNumber: phoneNumberTextField.text!) {
            self.phoneNumberButton.isUserInteractionEnabled = false
            let phoneNumber = "+1" + phoneNumberTextField.text!
            Auth0
               .authentication()
               .startPasswordless(phoneNumber: phoneNumber, connection: "sms")
               .start { result in
                   switch result {
                   case .success:
                       DispatchQueue.main.async {
                           self.verificationController.userPhoneNumber = phoneNumber
                           self.navigationController?.pushViewController(self.verificationController, animated: true)
                           self.phoneNumberButton.isUserInteractionEnabled = true
                           self.resetFields()
                           return
                       }
                   case .failure(let error):
                       print(error)
                       DispatchQueue.main.async {
                           self.present(self.validatePhoneController, animated: true)
                           self.phoneNumberButton.isUserInteractionEnabled = true
                           return
                       }
                   }
               }

            return
        } else {
            self.present(self.validatePhoneController, animated: true)
        }
    }
    
    private func resetFields() {
        self.phoneNumberTextField.text = ""
    }
    
    @objc func backButtonPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.phoneNumberTextField.becomeFirstResponder()
        self.notificationToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidChangeFrameNotification, object: nil, queue: .main) { notification in
            let keyboardRect = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            self.phoneNumberButtonBottomLayoutConstraint.constant = -keyboardRect.height - 20
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.phoneNumberTextField.resignFirstResponder()
        NotificationCenter.default.removeObserver(self.notificationToken!)
    }
}
