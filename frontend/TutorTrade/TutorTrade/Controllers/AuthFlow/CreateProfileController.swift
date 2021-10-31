//
//  CreateAccountViewController.swift
//  TutorTrade
//
//  Created by brock davis on 10/29/21.
//

import UIKit

class CreateProfileController: UIViewController, UITextFieldDelegate {

    private lazy var scrollView: UIScrollView = .createProfilePageVerticalScrollView
    private lazy var pageTitle: UILabel = .createAccountTitle
    private lazy var nameTitle: UILabel = .displayBoxLabel(withText: "Full Name")
    private lazy var nameBox: BorderedDisplayBoxView = .defaultDisplayBoxView(withIcon: UIImage(named: "NameIcon")!, iconHeightRatio: 0.32)
    private lazy var nameTextField: UITextField = .profileCreationTextField(withPlaceholder: "Full Name")
    private lazy var schoolTitle: UILabel = .displayBoxLabel(withText: "School")
    private lazy var schoolBox: BorderedDisplayBoxView = .defaultDisplayBoxView(withIcon: UIImage(named: "SchoolIcon")!, iconHeightRatio: 0.32)
    private lazy var schoolTextField: UITextField = .profileCreationTextField(withPlaceholder: "Enter School")
    private lazy var majorTitle: UILabel = .displayBoxLabel(withText: "Major")
    private lazy var majorBox: BorderedDisplayBoxView = .defaultDisplayBoxView(withIcon: UIImage(named: "MajorIcon")!, iconHeightRatio: 0.32)
    private lazy var majorTextField: UITextField = .profileCreationTextField(withPlaceholder: "Enter Major")
    private lazy var tutoringSubjectsTitle: UILabel = .displayBoxLabel(withText: "Tutoring Subjects")
    private lazy var explainButton: UIButton = .explainButton
    private lazy var tutoringSubjectsScrollView: TutoringSubjectsScrollView = .init(tutoringSubjects: DisplaySettingsManager.shared.appDisplaySettings!.tutoringSubjects, selectedTutoringSubjects: nil, selectionObserver: nil)
    private lazy var createAccountButton: UIButton = .createAccountButton
    private lazy var explainController: UIAlertController = {
        let controller = UIAlertController.init(title: "Tutoring Subjects", message: "Select the subjects that are you able to tutor other students in", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .cancel))
        return controller
    }()
    
    
    override func viewDidLoad() {
        let dismissKeyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        self.view.addGestureRecognizer(dismissKeyboardRecognizer)
    }
    
    @objc func dismissKeyboard() {
            self.scrollView.endEditing(true)
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor(named: "WelcomePageBackgroundColor")!
        
        self.view.addSubview(scrollView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                $0.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        }
        
        self.scrollView.addSubview(pageTitle) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: UIScreen.main.bounds.height / 17),
                $0.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: UIScreen.main.bounds.width / 14.42),
                $0.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width / 1.47),
                $0.heightAnchor.constraint(equalToConstant: 34)
            ])
        }
        
        self.scrollView.addSubview(nameTitle) {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: self.pageTitle.leadingAnchor),
                $0.topAnchor.constraint(equalTo: self.pageTitle.bottomAnchor, constant: UIScreen.main.bounds.height / 22),
                $0.heightAnchor.constraint(equalToConstant: 18),
                $0.widthAnchor.constraint(equalToConstant: 85)
            ])
        }
        
        self.scrollView.addSubview(nameBox) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.nameTitle.bottomAnchor, constant: 10),
                $0.leadingAnchor.constraint(equalTo: self.nameTitle.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -UIScreen.main.bounds.width / 14.42),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 14)
            ])
        }
        
        self.nameBox.addSubview(nameTextField) {
            $0.delegate = self
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: self.nameBox.centerYAnchor),
                $0.heightAnchor.constraint(equalTo: self.nameBox.heightAnchor, multiplier: 0.7),
                $0.leadingAnchor.constraint(equalTo: self.nameBox.leadingAnchor, constant: 43),
                $0.trailingAnchor.constraint(equalTo: self.nameBox.trailingAnchor, constant: -10)
            ])
        }
        
        self.scrollView.addSubview(schoolTitle) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.nameBox.bottomAnchor, constant: UIScreen.main.bounds.height / 31.2),
                $0.leadingAnchor.constraint(equalTo: self.nameBox.leadingAnchor),
                $0.widthAnchor.constraint(equalToConstant: 85),
                $0.heightAnchor.constraint(equalToConstant: 18)
            ])
        }
        
        self.scrollView.addSubview(schoolBox) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.schoolTitle.bottomAnchor, constant: 10),
                $0.leadingAnchor.constraint(equalTo: self.schoolTitle.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.nameBox.trailingAnchor),
                $0.heightAnchor.constraint(equalTo: self.nameBox.heightAnchor)
            ])
        }
        
        self.schoolBox.addSubview(schoolTextField) {
            $0.delegate = self
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: schoolBox.centerYAnchor),
                $0.heightAnchor.constraint(equalTo: schoolBox.heightAnchor, multiplier: 0.7),
                $0.leadingAnchor.constraint(equalTo: schoolBox.leadingAnchor, constant: 43),
                $0.trailingAnchor.constraint(equalTo: schoolBox.trailingAnchor, constant: -10)
            ])
        }
        
        self.scrollView.addSubview(majorTitle) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: schoolBox.bottomAnchor, constant: UIScreen.main.bounds.height / 31.2),
                $0.leadingAnchor.constraint(equalTo: schoolBox.leadingAnchor),
                $0.widthAnchor.constraint(equalToConstant: 85),
                $0.heightAnchor.constraint(equalToConstant: 18)
            ])
        }
        
        self.scrollView.addSubview(majorBox) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.majorTitle.bottomAnchor, constant: 10),
                $0.leadingAnchor.constraint(equalTo: self.majorTitle.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.schoolBox.trailingAnchor),
                $0.heightAnchor.constraint(equalTo: self.schoolBox.heightAnchor)
            ])
        }
        
        self.majorBox.addSubview(majorTextField) {
            $0.delegate = self
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: self.majorBox.centerYAnchor),
                $0.leadingAnchor.constraint(equalTo: self.majorBox.leadingAnchor, constant: 43),
                $0.trailingAnchor.constraint(equalTo: self.majorBox.trailingAnchor, constant: -10),
                $0.heightAnchor.constraint(equalTo: self.majorBox.heightAnchor, multiplier: 0.7)
            ])
        }
        
        self.scrollView.addSubview(tutoringSubjectsTitle) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.majorBox.bottomAnchor, constant: UIScreen.main.bounds.height / 31.23),
                $0.leadingAnchor.constraint(equalTo: self.majorBox.leadingAnchor),
                $0.widthAnchor.constraint(equalToConstant: 115),
                $0.heightAnchor.constraint(equalToConstant: 18)
            ])
        }
        
        self.scrollView.addSubview(explainButton) {
            $0.addTarget(self, action: #selector(self.explainButtonTapped), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.tutoringSubjectsTitle.topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.tutoringSubjectsTitle.trailingAnchor),
                $0.widthAnchor.constraint(equalToConstant: 18),
                $0.heightAnchor.constraint(equalToConstant: 18)
            ])
        }
        
        self.scrollView.addSubview(tutoringSubjectsScrollView) {
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.tutoringSubjectsTitle.bottomAnchor, constant: UIScreen.main.bounds.height / 54.13),
                $0.leadingAnchor.constraint(equalTo: self.tutoringSubjectsTitle.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor)
            ])
        }
        
        self.scrollView.addSubview(createAccountButton) {
            $0.addTarget(self, action: #selector(self.createAccountButtonTapped), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.tutoringSubjectsScrollView.bottomAnchor, constant: UIScreen.main.bounds.height / 16.57),
                $0.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 28),
                $0.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: -28),
                $0.heightAnchor.constraint(equalToConstant: 55)
            ])
        }
        
        NSLayoutConstraint.activate([
            self.scrollView.contentLayoutGuide.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            self.scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: UIScreen.main.bounds.height / 10.41)
        ])
        
    }
    
    @objc func explainButtonTapped() {
        self.present(self.explainController, animated: true)
    }
    
    @objc func createAccountButtonTapped() {
        AuthManager.shared.isLoggedIn = true
        self.navigationController?.popToRootViewController(animated: false)
        (UIApplication.shared.delegate as! TutorTradeApplication).loadStartupController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.scrollView.endEditing(true)
        return true
    }

}
