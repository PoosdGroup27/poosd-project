//
//  VerificationCodeController.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/27/21.
//

import UIKit

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

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor(named: "AuthFlowColor")!
    }
    
    override func loadView() {
        super.loadView()
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
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height / 2.7),
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: UIScreen.main.bounds.width / -14.42),
                $0.widthAnchor.constraint(equalToConstant: 50),
                $0.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        self.view.addSubview(verificationBoxOne) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 220),
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
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 220),
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
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 220),
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
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 220),
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
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 220),
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
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 220),
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
        print("In verify")
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let text = textField.text

            if text?.utf16.count==1{
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
                default:
                    break
                }
            }
    }
}
