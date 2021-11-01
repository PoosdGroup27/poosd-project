//
//  SchoolSelectionViewController.swift
//  TutorTrade
//
//  Created by brock davis on 10/25/21.
//

import UIKit

class PopoverEditingViewController: UIViewController, UITextFieldDelegate {
    
    struct EditFieldValues {
        let fieldLabel: String
        let fieldIcon: UIImage
        let fieldKeyPath: WritableKeyPath<TutorProfile, String>
        let fieldPlaceHolder: String
    }
    
    private var _fieldValues: EditFieldValues
    var fieldValues: EditFieldValues {
        get {
            _fieldValues
        }
        set {
            _fieldValues = newValue
            editFieldLabel.text = newValue.fieldLabel
            editingDisplayBox.iconImage = newValue.fieldIcon
            editingTextField.placeholder  = newValue.fieldPlaceHolder
            editingTextField.text = profileManager.profile[keyPath: newValue.fieldKeyPath]
        }
    }
    private var profileManager: TutorProfileManager
    private lazy var backgroundDismissButton: UIButton = .transparentDismissButton
    private lazy var popoverView: UIView = .popoverEditView
    private lazy var exitButton: UIButton = .popoverExitButton
    private lazy var editFieldLabel: UILabel = .editFieldLabel(withFieldName: _fieldValues.fieldLabel)
    private lazy var editingDisplayBox: BorderedDisplayBoxView = .shadowedDisplayBox(withIcon: _fieldValues.fieldIcon)
    private lazy var editingTextField: UITextField = .editingTextField(withCurrentValue:  profileManager.profile[keyPath: _fieldValues.fieldKeyPath], withPlaceholder: _fieldValues.fieldPlaceHolder)
    private let callback: (() -> ())?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    init(fieldValues: EditFieldValues, profileManager: TutorProfileManager, onFinish callback: (() -> ())?) {
        self._fieldValues = fieldValues
        self.profileManager = profileManager
        self.callback = callback
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        get {
            true
        }
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(backgroundDismissButton) {
            $0.addTarget(self, action: #selector(self.exitButtonTapped), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 4)
            ])
        }
        
        self.view.addSubview(popoverView) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: backgroundDismissButton.bottomAnchor, constant: -30),
                $0.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                $0.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        }
        
        self.popoverView.addSubview(exitButton) {
            $0.addTarget(self, action: #selector(self.exitButtonTapped), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: popoverView.topAnchor, constant: UIScreen.main.bounds.height / 35.3),
                $0.heightAnchor.constraint(equalToConstant: 35),
                $0.widthAnchor.constraint(equalToConstant: 35),
                $0.trailingAnchor.constraint(equalTo: popoverView.trailingAnchor, constant: -UIScreen.main.bounds.height / 35.3)
            ])
        }
        
        self.popoverView.addSubview(editFieldLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.popoverView.topAnchor, constant: UIScreen.main.bounds.height / 10.54),
                $0.leadingAnchor.constraint(equalTo: self.popoverView.leadingAnchor, constant: UIScreen.main.bounds.width / 10),
                $0.widthAnchor.constraint(equalToConstant: 130),
                $0.heightAnchor.constraint(equalToConstant: 31)
            ])
        }
        
        self.popoverView.addSubview(editingDisplayBox) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: editFieldLabel.bottomAnchor, constant: UIScreen.main.bounds.height / 15.32),
                $0.leadingAnchor.constraint(equalTo: self.popoverView.leadingAnchor, constant: 30),
                $0.trailingAnchor.constraint(equalTo: self.popoverView.trailingAnchor, constant: -30),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 10.278)
            ])
        }
        
        self.editingDisplayBox.addSubview(editingTextField) {
            $0.delegate = self
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: editingDisplayBox.centerYAnchor),
                $0.heightAnchor.constraint(equalTo: editingDisplayBox.heightAnchor, multiplier: 0.7),
                $0.leadingAnchor.constraint(equalTo: editingDisplayBox.leadingAnchor, constant: 60),
                $0.trailingAnchor.constraint(equalTo: editingDisplayBox.trailingAnchor, constant: -5)
            ])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        editingTextField.becomeFirstResponder()
    }

    @objc func exitButtonTapped() {
        profileManager.profile[keyPath: fieldValues.fieldKeyPath] = self.editingTextField.text!
        callback?()
        dismiss(animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        exitButtonTapped()
        return true
    }
}
