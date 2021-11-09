//
//  VerificationCodeController.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/27/21.
//

import UIKit
import Auth0
import JWTDecode

class VerificationController: UIViewController, UITextFieldDelegate {
    
    private lazy var verificationTitleLabel: UILabel = .verificationTitleLabel
    private lazy var verificationDescriptionLabel: UILabel = .verificationDescriptionLabel
    private lazy var verificationButton: UIButton = .createButton(backgroundColor: .black, image: UIImage(named: "ForwardIcon")!)
    private lazy var resendOTPButton: UIButton = .resendOTPButton
    private lazy var verificationBoxes: [ShadowDisplayBox] = {
        stride(from: 0, to: 6, by: 1).map { _ in
            ShadowDisplayBox.defaultDisplayBoxView()
        }
    }()
    private lazy var verificationBoxesStackView: UIStackView = .verificationBoxesStackView
    private lazy var verificationTextFields: [UITextField] = {
        stride(from: 0, to: 6, by: 1).map { _ in
            UITextField.verificationTextField
        }
    }()
    private lazy var createProfileViewController = CreateProfileController()
    var userPhoneNumber: String!
    private var verificationDescriptionText = "Enter the verification code sent by text to "
    private var notificationToken: NSObjectProtocol!
    private lazy var validateController: UIAlertController = {
        let controller = UIAlertController.init(title: "Incorrect verification code",
                                                message: "Invalid code, please try again or enter new phone number",
                                                preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: "OK", style: .cancel))
        return controller
    }()
    private var verificationButtonBottomConstraint: NSLayoutConstraint!

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor(named: "AuthFlowColor")!

        self.view.addSubview(verificationTitleLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.height / 7),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: UIScreen.main.bounds.width / 11.52),
                $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -UIScreen.main.bounds.width / 11.52)
            ])
        }
        
        self.view.addSubview(verificationDescriptionLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.verificationTitleLabel.bottomAnchor, constant: UIScreen.main.bounds.height / 20),
                $0.leadingAnchor.constraint(equalTo: self.verificationTitleLabel.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.verificationTitleLabel.trailingAnchor)
            ])
        }
        
        
        self.view.addSubview(verificationBoxesStackView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: verificationDescriptionLabel.bottomAnchor, constant: UIScreen.main.bounds.height / 20),
                $0.leadingAnchor.constraint(equalTo: verificationDescriptionLabel.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: verificationDescriptionLabel.trailingAnchor),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 15)
            ])
        }
        
        for i in 0...5 {
            // Stack view applies constraints on verification boxes such that they are equally sized and spaced
            self.verificationBoxesStackView.addArrangedSubview(verificationBoxes[i])
            self.verificationBoxes[i].addSubview(verificationTextFields[i]) {
                $0.delegate = self
                $0.keyboardType = .numberPad
                $0.addTarget(self, action: #selector(moveToNextTextField), for: .editingChanged)
                // Center text fields within verification boxes with respect to both dimensions
                NSLayoutConstraint.activate([
                    $0.centerXAnchor.constraint(equalTo: self.verificationBoxes[i].centerXAnchor),
                    $0.centerYAnchor.constraint(equalTo: self.verificationBoxes[i].centerYAnchor)
                ])
            }
        }
        self.view.addSubview(verificationButton) {
            $0.addTarget(self, action: #selector(self.attemptVerification), for: .touchUpInside)
            self.verificationButtonBottomConstraint = $0.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: UIScreen.main.bounds.width / -14)
            NSLayoutConstraint.activate([
                self.verificationButtonBottomConstraint,
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: UIScreen.main.bounds.width / -14.42),
                $0.widthAnchor.constraint(equalToConstant: 50),
                $0.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        self.view.addSubview(resendOTPButton) {
            $0.addTarget(self, action: #selector(changePhoneNumber), for: .touchUpInside)
            // Hidden until timer elapses
            $0.isHidden = true
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: self.verificationButton.centerYAnchor),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 23)
            ])
        }
        
    }
    
    @objc func attemptVerification() {
        self.verificationButton.isUserInteractionEnabled = false
        let code = verificationTextFields.compactMap{$0.text}.joined()

        Auth0
           .authentication()
           .login(
            phoneNumber: userPhoneNumber,
               code: code,
            audience: DefaultAuthManager.shared.audience,
            scope: DefaultAuthManager.shared.scopes)
           .start { result in
               switch result {
               case .success(let credentials):
                   DefaultAuthManager.shared.credentials = AuthCredentials(idToken: credentials.idToken, accessToken: credentials.accessToken)
                   
                   DefaultTutorProfileManager.loadProfile(withId: DefaultAuthManager.shared.userId!) { success in
                       DispatchQueue.main.async {
                           if success {
                               (UIApplication.shared.delegate as! TutorTradeApplication).loadStartupController()
                           } else {
                               self.navigationController?.pushViewController(self.createProfileViewController, animated: true)
                           }
                           self.verificationButton.isUserInteractionEnabled = true
                       }
                   }
               case .failure(let error):
                   print(error)
                   DispatchQueue.main.async {
                       self.present(self.validateController, animated: true)
                       self.verificationButton.isUserInteractionEnabled = true
                       return
                   }
               }
           }
    }
    
    /**
     UITextFieldDelegate method that is called to determine if a user entry should be added to the text field
     */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // Prevent adding more than 1 character to text field
        // Empty string represents the delete character per docs
        guard textField.text!.isEmpty || string == "" else {
            moveToNextTextField(textField)
            return false
        }
        
        // User pressed delete
        if string == "" {
            textField.text = ""
            moveToPreviousTextField(textField)
            return false
        }
        
        // Attempt to verify if user entered last digit of OTP
        if textField.text!.isEmpty && textField === verificationTextFields.last! {
            textField.text = string
            self.attemptVerification()
            return false
        }
        
        // Allow single digit entry to text field
        return string.count == 1 && string.first!.isNumber
    }
    
    /**
     Directs keyboard and cursor to the next text field in sequence
     */
    @objc func moveToNextTextField(_ textField: UITextField) {
        
        // Don't proceed until the text field has a digit entry
        guard !textField.text!.isEmpty else {
            return
        }
        
        let index = verificationTextFields.firstIndex(of: textField)!
        
        switch index {
        // Last text field should remain first responder
        case verificationTextFields.count - 1:
            return
        default:
            // Pass first responder status to next text field in sequence
            textField.resignFirstResponder()
            verificationTextFields[index + 1].becomeFirstResponder()
        }
    }
    
    /**
     Directs keyboard and cursor to the previous text field in sequence
     */
    func moveToPreviousTextField(_ textField: UITextField) {
        let index = verificationTextFields.firstIndex(of: textField)!
        
        switch index {
        case 0:
            // First text field should remain first responder
            return
        default:
            // Pass first responder status to previous text field in sequence
            textField.resignFirstResponder()
            verificationTextFields[index - 1].becomeFirstResponder()
        }
    }
    
    /**
     Called to let the user enter a different phone # for sending OTP
     */
    @objc func changePhoneNumber() {
        self.navigationController?.popViewController(animated: true)
    }
    
    /**
     Reset fields so each view reappearance results in a fresh page for user
     */
    private func resetFields() {
        for textField in verificationTextFields {
            textField.text = ""
        }
        userPhoneNumber = ""
        self.verificationDescriptionLabel.text! = verificationDescriptionText + userPhoneNumber
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.verificationDescriptionLabel.text! += userPhoneNumber
        // When page loads, keyboard should be up and directed to first text field
        self.verificationTextFields.first?.becomeFirstResponder()
        
        // Change the position of the buttons above keyboard when the keyboard frame changes
        self.notificationToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidChangeFrameNotification, object: nil, queue: .main) { notification in
            let keyboardRect = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            self.verificationButtonBottomConstraint.constant = -keyboardRect.height - 20
            self.view.setNeedsLayout()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // User can only re-request or change number for OTP after 3 seconds have elapsed
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            DispatchQueue.main.async {
                print("Animation")
                UIView.transition(with: self.resendOTPButton, duration: 1, options: [.curveEaseIn]) {
                    self.resendOTPButton.isHidden = false
                }
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        resetFields()
        self.resendOTPButton.isHidden = true
        NotificationCenter.default.removeObserver(self.notificationToken!)
    }
}
