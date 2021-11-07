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
    private lazy var verificationBoxOne: ShadowDisplayBox = .defaultDisplayBoxView()
    private lazy var verificationBoxTwo: ShadowDisplayBox = .defaultDisplayBoxView()
    private lazy var verificationBoxThree: ShadowDisplayBox = .defaultDisplayBoxView()
    private lazy var verificationBoxFour: ShadowDisplayBox = .defaultDisplayBoxView()
    private lazy var verificationBoxFive: ShadowDisplayBox = .defaultDisplayBoxView()
    private lazy var verificationBoxSix: ShadowDisplayBox = .defaultDisplayBoxView()
    private lazy var verificationTextFieldOne: UITextField = .createTextField(withPlaceholder: "X")
    private lazy var verificationTextFieldTwo: UITextField = .createTextField(withPlaceholder: "X")
    private lazy var verificationTextFieldThree: UITextField = .createTextField(withPlaceholder: "X")
    private lazy var verificationTextFieldFour: UITextField = .createTextField(withPlaceholder: "X")
    private lazy var verificationTextFieldFive: UITextField = .createTextField(withPlaceholder: "X")
    private lazy var verificationTextFieldSix: UITextField = .createTextField(withPlaceholder: "X")
    private lazy var createProfileViewController = CreateProfileController()
    var userPhoneNumber: String!
    private var textFieldArray: [UITextField] {
           return [verificationTextFieldOne, verificationTextFieldTwo, verificationTextFieldThree,
                   verificationTextFieldFour, verificationTextFieldFive, verificationTextFieldSix]

   }
    private lazy var validateController: UIAlertController = {
        let controller = UIAlertController.init(title: "Incorrect verification code",
                                                message: "Invalid code, please try again or enter new phone number",
                                                preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: "OK", style: .cancel))
        return controller
    }()

    override func viewDidLoad() {
        let dismissKeyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        self.view.addGestureRecognizer(dismissKeyboardRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.verificationDescriptionLabel.text! += userPhoneNumber
    }

    override func loadView() {
        super.loadView()
        self.view.backgroundColor = UIColor(named: "AuthFlowColor")!

        self.view.addSubview(verificationTitleLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.height / 4),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: UIScreen.main.bounds.width / 14)
            ])
        }
        
        self.view.addSubview(verificationDescriptionLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.topAnchor, constant: UIScreen.main.bounds.height / 3),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: UIScreen.main.bounds.width / 14)
            ])
        }
        
        self.view.addSubview(verificationButton) {
            $0.addTarget(self, action: #selector(self.verificationButtonTapped), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height / 2.3),
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: UIScreen.main.bounds.width / -14.42),
                $0.widthAnchor.constraint(equalToConstant: 50),
                $0.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        self.view.addSubview(verificationBoxOne) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 275),
                $0.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
                $0.widthAnchor.constraint(equalToConstant: 43),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 15)
            ])
        }
        
        self.verificationBoxOne.addSubview(verificationTextFieldOne) {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: verificationBoxOne.centerYAnchor),
                $0.centerXAnchor.constraint(equalTo: verificationBoxOne.centerXAnchor)
            ])
        }

        
        self.view.addSubview(verificationBoxTwo) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 275),
                $0.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 76),
                $0.widthAnchor.constraint(equalToConstant: 43),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 15)
            ])
        }
        
        self.verificationBoxTwo.addSubview(verificationTextFieldTwo) {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: verificationBoxTwo.centerYAnchor),
                $0.centerXAnchor.constraint(equalTo: verificationBoxTwo.centerXAnchor)
            ])
        }

        self.view.addSubview(verificationBoxThree) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 275),
                $0.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 132),
                $0.widthAnchor.constraint(equalToConstant: 43),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 15)
            ])
        }
        
        self.verificationBoxThree.addSubview(verificationTextFieldThree) {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: verificationBoxThree.centerYAnchor),
                $0.centerXAnchor.constraint(equalTo: verificationBoxThree.centerXAnchor)
            ])
        }

        
        self.view.addSubview(verificationBoxFour) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 275),
                $0.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 188),
                $0.widthAnchor.constraint(equalToConstant: 43),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 15)
            ])
        }
        
        self.verificationBoxFour.addSubview(verificationTextFieldFour) {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: verificationBoxFour.centerYAnchor),
                $0.centerXAnchor.constraint(equalTo: verificationBoxFour.centerXAnchor)
            ])
        }

        
        self.view.addSubview(verificationBoxFive) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 275),
                $0.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 244),
                $0.widthAnchor.constraint(equalToConstant: 43),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 15)
            ])
        }
        
        self.verificationBoxFive.addSubview(verificationTextFieldFive) {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: verificationBoxFive.centerYAnchor),
                $0.centerXAnchor.constraint(equalTo: verificationBoxFive.centerXAnchor)
            ])
        }

        
        self.view.addSubview(verificationBoxSix) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 275),
                $0.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 300),
                $0.widthAnchor.constraint(equalToConstant: 43),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 15)
            ])
        }
        
        self.verificationBoxSix.addSubview(verificationTextFieldSix) {
            $0.delegate = self
            $0.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: verificationBoxSix.centerYAnchor),
                $0.centerXAnchor.constraint(equalTo: verificationBoxSix.centerXAnchor)
            ])
        }
    }
    
    @objc func verificationButtonTapped() {
        self.verificationButton.isUserInteractionEnabled = false
        let code = textFieldArray.compactMap{$0.text}.joined()

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
                   print("Access Token: \(String(describing: credentials.accessToken))")

                   let authCredentials = AuthCredentials(idToken: credentials.idToken, accessToken: credentials.accessToken)
                   DefaultAuthManager.shared.credentials = authCredentials
                   
                   DefaultTutorProfileManager.loadProfile(withId: DefaultAuthManager.shared.userId!) { success in
                       DispatchQueue.main.async {
                           if success {
                               (UIApplication.shared.delegate as! TutorTradeApplication).loadStartupController()
                           } else {
                               self.pushCreateProfileController()
                           }
                           self.verificationButton.isUserInteractionEnabled = true
                           self.resetFields()
                       }
                   }
               case .failure(let error):
                   print(error)
                   DispatchQueue.main.async {
                       self.present(self.validateController, animated: true)
                       return
                   }
               }
           }
    }
    
//    func getUniqueID(id: String) -> String {
//        let start = id.index(id.startIndex, offsetBy: 4)
//        let end = id.index(id.startIndex, offsetBy: id.count-1)
//        return String(id[start...end])
//    }

    func pushCreateProfileController() {
            self.navigationController?.pushViewController(self.createProfileViewController, animated: true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text

            if text?.utf16.count == 1 {
                switch textField{
                case verificationTextFieldOne:
                    verificationTextFieldTwo.becomeFirstResponder()
                case verificationTextFieldTwo:
                    verificationTextFieldThree.becomeFirstResponder()
                case verificationTextFieldThree:
                    verificationTextFieldFour.becomeFirstResponder()
                case verificationTextFieldFour:
                    verificationTextFieldFive.becomeFirstResponder()
                case verificationTextFieldFive:
                    verificationTextFieldSix.becomeFirstResponder()
                case verificationTextFieldSix:
                    verificationBoxSix.endEditing(true)
                default:
                    break
                }
            }
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func resetFields() {
        for textField in textFieldArray {
            textField.text = ""
        }
        self.verificationDescriptionLabel.text! = String(self.verificationDescriptionLabel.text![...self.verificationDescriptionLabel.text!.index(self.verificationDescriptionLabel.text!.endIndex, offsetBy: -13)])
    }
}

extension VerificationController: PhoneNumberDelegate {
    func setPhoneNumber(phoneNumber: String) {
        self.userPhoneNumber = phoneNumber
    }
}
