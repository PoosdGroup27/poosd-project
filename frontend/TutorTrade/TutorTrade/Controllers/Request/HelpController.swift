//
//  HelpController.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 11/22/21.
//

import Foundation
import UIKit

class HelpController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate {
    private var profileManager: TutorProfileManager
    private var requestModel: RequestModel
    private var requestManager: RequestManager

    private lazy var helpTitleContainer: UIView = .helpTitleContainer
    private lazy var helpTitleLabel: UILabel = .helpTitleLabel
    private lazy var helpScrollView: UIScrollView = .helpPageScrollView
    private lazy var helpSubjectLabel: UILabel = .requestLabel(text: "Subject")
    private lazy var subjectDisplayBox: ShadowDisplayBox = .helpShadowDisplayBox(withIcon: UIImage(named: "Bookmark")!)
    private lazy var subjectsTextField: UITextField = .subjectsTextField
    private var pickerView: UIPickerView = UIPickerView()
    private lazy var urgencyLabel: UILabel = .requestLabel(text: "Urgency")
    private lazy var urgencyButtons: [UIButton] = UIButton.getUrgencyButtons()
    private lazy var descriptionLabel: UILabel = .requestLabel(text: "Description")
    private lazy var descriptionDisplayBox: BorderedDisplayBoxView = .helpDescriptionCardBoxView()
    private lazy var descriptionTextView: UITextView = .descriptionTextView
    private lazy var budgetLabel: UILabel = .requestLabel(text: "Budget")
    private lazy var budgetDisplayBox: BorderedDisplayBoxView = .budgetCardBoxView()
    private lazy var budgetTextFieldDisplayBox: BorderedDisplayBoxView = .pointBalanceTextFieldDisplayBox()
    private lazy var budgetTextView: UITextView = .budgetTextView
    private lazy var availableBudget: UILabel = .budgetHelpLabel()
    private lazy var actualBudgetLabel: UILabel = .actualBudgetLabel(points: profileManager.profile.pointBalance)
    private lazy var mediumLabel: UILabel = .requestLabel(text: "Preferred Medium")
    private lazy var mediumButtons: [UIButton] = UIButton.getMediumButtons()
    private lazy var inPersonLabel: UILabel = .getMediumLabel(text: "In Person")
    private lazy var onlineLabel: UILabel = .getMediumLabel(text: "Online")
    private lazy var submitButton: UIButton = .submitButton
    private lazy var submitRequestAlert: UIAlertController = {
        let controller = UIAlertController.init(title: "Request submitted ✅",
                                                message: "",
                                                preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: "OK", style: .cancel))
        return controller
    }()
    private lazy var verifyPointsAlert: UIAlertController = {
        let controller = UIAlertController.init(title: "Not enough points. 🥺",
                                                message: "Unable to submit request, not enough points.",
                                                preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: "OK", style: .cancel))
        return controller
    }()
    private lazy var emptyFieldsAlert: UIAlertController = {
        let controller = UIAlertController.init(title: "Empty field",
                                                message: "Please fill out all fields.",
                                                preferredStyle: .alert)

        controller.addAction(UIAlertAction(title: "OK", style: .cancel))
        return controller
    }()
    private var urgencyButtonFlag = false
    private var mediumButtonFlag = false
    private var subjects: [String] = ["➗ Mathematics",
                                      "🪐 Astronomy",
                                      "⚛️ Physics",
                                      "💻 Computer Science",
                                      "💾 IT",
                                      "🚉 Civil Engineering",
                                      "🧱 Materials",
                                      "🏗 Construction",
                                      "🏛 Architecture",
                                      "🌍 Environmental Sciences",
                                      "🌾 Agriculture",
                                      "🧬 Biology",
                                    "☣️ Biomedical Sciences",
                                    "🧪 Chemistry",
                                    "🏈 Sports Science",
                                    "💪 Physiology",
                                    "🔎 Forensic Science",
                                    "👩🏻‍⚕️ Nursing",
                                    "🧠 Psychology",
                                    "🤔 Philosophy",
                                    "🙏 Religion",
                                    "🗳 Politics",
                                    "📖 Law",
                                    "🕰 History",
                                    "📍 Geography",
                                    "🦖 Archaeology",
                                    "✍️ Journalism",
                                     "📚 Literature",
                                     "🔤 Languages",
                                     "🎨 Art",
                                     "🎭 Theatre",
                                    "🎵 Music",
                                    "👩‍🏫 Education",
                                    "🏨 Hospitality",
                                    "📈 Marketing",
                                    "📊 Business",
                                    "🧾 Accounting",
                                    "💵 Finance",
                                    "🛍 Retail",
                                    "🙋 Human Resources",
                                    "⿴ Graphic Design",
                                    "✈️ Aviation"]
    
    internal init (withBalance balance: Int) {
        self.profileManager = DefaultTutorProfileManager.shared!
        self.requestModel = RequestModel()
        self.requestManager = RequestManager()
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(title: "Request", image: UIImage(named: "RequestTabBarIcon"), tag: 1)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        self.view.addSubview(helpTitleContainer) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                $0.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 8)
            ])
        }
        
        // Set up title container
        self.helpTitleContainer.addSubview(helpTitleLabel) {
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: self.helpTitleContainer.centerYAnchor),
                $0.leadingAnchor.constraint(equalTo: self.helpTitleContainer.leadingAnchor, constant: UIScreen.main.bounds.width / 14)
            ])
        }
        
        self.view.addSubview(helpScrollView) {
            $0.delegate = self
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.helpTitleContainer.bottomAnchor),
                $0.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
                $0.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
            ])
        }
        
        self.helpScrollView.addSubview(helpSubjectLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.helpScrollView.topAnchor, constant: 32),
                $0.leadingAnchor.constraint(equalTo: self.helpTitleLabel.leadingAnchor)
            ])
        }
        
        self.helpScrollView.addSubview(subjectDisplayBox) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: self.helpSubjectLabel.bottomAnchor, multiplier: 2),
                $0.leadingAnchor.constraint(equalTo: self.helpSubjectLabel.leadingAnchor),
                $0.widthAnchor.constraint(equalToConstant: 300),
                $0.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
        
        self.subjectDisplayBox.addSubview(subjectsTextField) {
            $0.inputView = self.pickerView
            self.pickerView.delegate = self
            self.pickerView.dataSource = self
            $0.delegate = self
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: self.subjectDisplayBox.centerYAnchor),
                $0.leadingAnchor.constraint(equalTo: self.subjectDisplayBox.leadingAnchor, constant: 56),
                $0.widthAnchor.constraint(equalTo: self.subjectDisplayBox.widthAnchor),
                $0.heightAnchor.constraint(equalTo: self.subjectDisplayBox.heightAnchor),
            ])
        }
        
        self.helpScrollView.addSubview(urgencyLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: self.subjectDisplayBox.bottomAnchor, multiplier: 4),
                $0.leadingAnchor.constraint(equalTo: self.helpTitleLabel.leadingAnchor)
            ])
        }
        
        self.helpScrollView.addSubview(urgencyButtons[0]) {
            $0.addTarget(self, action: #selector(self.onTapUrgencyButton), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: self.urgencyLabel.bottomAnchor, multiplier: 2),
                $0.leadingAnchor.constraint(equalTo: self.helpTitleLabel.leadingAnchor),
                $0.widthAnchor.constraint(equalToConstant: 90),
                $0.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        self.helpScrollView.addSubview(urgencyButtons[1]) {
            $0.addTarget(self, action: #selector(self.onTapUrgencyButton), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: self.urgencyLabel.bottomAnchor, multiplier: 2),
                $0.leadingAnchor.constraint(equalTo: self.urgencyButtons[0].trailingAnchor, constant: 25),
                $0.widthAnchor.constraint(equalToConstant: 90),
                $0.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        self.helpScrollView.addSubview(urgencyButtons[2]) {
            $0.addTarget(self, action: #selector(self.onTapUrgencyButton), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: self.urgencyLabel.bottomAnchor, multiplier: 2),
                $0.leadingAnchor.constraint(equalTo: self.urgencyButtons[1].trailingAnchor, constant: 25),
                $0.widthAnchor.constraint(equalToConstant: 90),
                $0.heightAnchor.constraint(equalToConstant: 40)
            ])
        }
        
        self.helpScrollView.addSubview(descriptionLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: self.urgencyButtons[0].bottomAnchor, multiplier: 4),
                $0.leadingAnchor.constraint(equalTo: self.helpTitleLabel.leadingAnchor)
            ])
        }
        
        self.helpScrollView.addSubview(descriptionDisplayBox) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.descriptionLabel.bottomAnchor, constant: 10),
                $0.leadingAnchor.constraint(equalTo: self.helpTitleLabel.leadingAnchor),
                $0.widthAnchor.constraint(equalToConstant: 320),
                $0.heightAnchor.constraint(equalToConstant: 120)
            ])
        }
        
        self.helpScrollView.addSubview(descriptionTextView) {
            $0.delegate = self
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.descriptionDisplayBox.topAnchor, constant: 16),
                $0.leadingAnchor.constraint(equalTo: self.descriptionDisplayBox.leadingAnchor, constant: 16),
                $0.widthAnchor.constraint(equalTo: self.descriptionDisplayBox.widthAnchor, constant: -20),
                $0.heightAnchor.constraint(equalTo: self.descriptionDisplayBox.heightAnchor, constant: -20),
            ])
        }
        
        self.helpScrollView.addSubview(budgetLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: self.descriptionDisplayBox.bottomAnchor, multiplier: 4),
                $0.leadingAnchor.constraint(equalTo: self.helpTitleLabel.leadingAnchor)
            ])
        }
        
        self.helpScrollView.addSubview(budgetDisplayBox) {
            $0.cornerRadius = 30
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: self.budgetLabel.bottomAnchor, multiplier: 2),
                $0.leadingAnchor.constraint(equalTo: self.helpTitleLabel.leadingAnchor),
                $0.widthAnchor.constraint(equalToConstant: 305),
                $0.heightAnchor.constraint(equalToConstant: 100)
            ])
        }
        
        self.budgetDisplayBox.addSubview(budgetTextFieldDisplayBox) {
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: self.budgetDisplayBox.centerYAnchor),
                $0.leadingAnchor.constraint(equalToSystemSpacingAfter: self.budgetDisplayBox.leadingAnchor, multiplier: 3),
                $0.widthAnchor.constraint(equalToConstant: 114),
                $0.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        self.budgetTextFieldDisplayBox.addSubview(budgetTextView) {
            $0.delegate = self
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.budgetTextFieldDisplayBox.topAnchor, constant: 6),
                $0.leadingAnchor.constraint(equalTo: self.budgetTextFieldDisplayBox.leadingAnchor, constant: 40),
                $0.widthAnchor.constraint(equalToConstant: self.budgetTextFieldDisplayBox.bounds.width / 5),
                $0.heightAnchor.constraint(equalTo: self.budgetTextFieldDisplayBox.heightAnchor, constant: -10),
            ])
        }
        
        self.budgetDisplayBox.addSubview(availableBudget) {
            NSLayoutConstraint.activate([
                $0.centerYAnchor.constraint(equalTo: self.budgetTextFieldDisplayBox.topAnchor, constant: 8),
                $0.leadingAnchor.constraint(lessThanOrEqualToSystemSpacingAfter: self.budgetTextFieldDisplayBox.trailingAnchor, multiplier: 1)
            ])
        }
        
        self.budgetDisplayBox.addSubview(actualBudgetLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: self.availableBudget.bottomAnchor),
                $0.leadingAnchor.constraint(equalTo: self.availableBudget.leadingAnchor)
            ])
        }
        
        self.helpScrollView.addSubview(mediumLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: self.budgetDisplayBox.bottomAnchor, multiplier: 4),
                $0.leadingAnchor.constraint(equalTo: self.helpTitleLabel.leadingAnchor)
            ])
        }
        
        self.helpScrollView.addSubview(mediumButtons[0]) {
            $0.addTarget(self, action: #selector(onTapMediumButton), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: self.mediumLabel.bottomAnchor, multiplier: 2),
                $0.leadingAnchor.constraint(equalTo: self.helpTitleLabel.leadingAnchor),
                $0.widthAnchor.constraint(equalToConstant: 60),
                $0.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
        
        self.helpScrollView.addSubview(mediumButtons[1]) {
            $0.addTarget(self, action: #selector(onTapMediumButton), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: mediumButtons[0].topAnchor),
                $0.leadingAnchor.constraint(equalTo: self.mediumButtons[0].trailingAnchor, constant: 25),
                $0.widthAnchor.constraint(equalToConstant: 60),
                $0.heightAnchor.constraint(equalToConstant: 60)
            ])
        }
        
        self.helpScrollView.addSubview(inPersonLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: self.mediumButtons[0].bottomAnchor, multiplier: 1),
                $0.centerXAnchor.constraint(equalTo: self.mediumButtons[0].centerXAnchor)
            ])
        }
        
        self.helpScrollView.addSubview(onlineLabel) {
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: self.mediumButtons[1].bottomAnchor, multiplier: 1),
                $0.centerXAnchor.constraint(equalTo: self.mediumButtons[1].centerXAnchor)
            ])
        }
        
        self.helpScrollView.addSubview(submitButton) {
            $0.addTarget(self, action: #selector(submitRequest), for: .touchUpInside)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalToSystemSpacingBelow: self.mediumButtons[1].bottomAnchor, multiplier: 4),
                $0.leadingAnchor.constraint(equalTo: self.mediumButtons[1].trailingAnchor, constant: 85),
                $0.widthAnchor.constraint(equalToConstant: 100),
                $0.heightAnchor.constraint(equalToConstant: 40),
            ])
        }
        
        NSLayoutConstraint.activate([
            self.helpScrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: self.submitButton.bottomAnchor, constant: 25),
        ])
    }
    
    @objc func didTapButton(_ selector: UIButton) {
        selector.layer.borderWidth = 1
    }
    
    @objc func onTapUrgencyButton(_ selector: UIButton) {
        let urgency = TutoringRequestUrgency.init(textRepresentation: selector.titleLabel!.text!).textRepresentation
        self.urgencyButtonFlag = true
        
        if urgency ==  TutoringRequestUrgency.init(textRepresentation: "Today").textRepresentation {
            selector.layer.borderWidth = 3
            urgencyButtons[1].layer.borderWidth = 1
            urgencyButtons[2].layer.borderWidth = 1
            self.requestModel.urgency = TutoringRequestUrgency.today.rawValue
        }
        else if urgency == TutoringRequestUrgency.init(textRepresentation: "Tomorrow").textRepresentation {
            selector.layer.borderWidth = 3
            urgencyButtons[0].layer.borderWidth = 1
            urgencyButtons[2].layer.borderWidth = 1
            self.requestModel.urgency = TutoringRequestUrgency.tomorrow.rawValue
        }
        else if urgency == TutoringRequestUrgency.init(textRepresentation: "This week").textRepresentation {
            selector.layer.borderWidth = 3
            urgencyButtons[0].layer.borderWidth = 1
            urgencyButtons[1].layer.borderWidth = 1
            self.requestModel.urgency = TutoringRequestUrgency.thisWeek.rawValue
        }
    }

    @objc func onTapMediumButton(_ selector: UIButton) {
        let tag = selector.tag
        self.mediumButtonFlag = true
        if tag == 0 {
            selector.layer.borderWidth = 3
            mediumButtons[1].layer.borderWidth = 1
            self.requestModel.platform = TutoringMedium.inPerson.rawValue
        }
        else if tag == 1 {
            selector.layer.borderWidth = 3
            mediumButtons[0].layer.borderWidth = 1
            self.requestModel.platform = TutoringMedium.online.rawValue
        }
    }
    
    func fieldsEmpty() -> Bool {
        if subjectsTextField.text!.isEmpty || !urgencyButtonFlag || descriptionTextView.text!.isEmpty
            || budgetTextView.text!.isEmpty || !mediumButtonFlag {
            return true
        }

        return false
    }
    
    @objc func submitRequest(_ selector: UIButton) {
        // Verify that all fields are filled correctly.
        if fieldsEmpty() {
            self.present(self.emptyFieldsAlert, animated: true)
        } else if invalidInputCost(inputPoints: Int(budgetTextView.text!)!, userBalance: self.profileManager.profile.pointBalance) {
            self.present(self.verifyPointsAlert, animated: true)
        } else {
            // Populate the model
            self.requestModel.requesterId = self.profileManager.profile.userId
            self.requestModel.subject = self.subjectsTextField.text!
            self.requestModel.description = self.descriptionTextView.text!
            self.requestModel.costInPoints = self.budgetTextView.text!
            // Set up and send request
            self.requestManager.setUpRequestManager(requestModel: self.requestModel)
            self.requestManager.setUpRequest()
            self.requestManager.postRequestData()

            print(requestModel)
            self.present(self.submitRequestAlert, animated: true)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView.tag == 0 {
                textView.text = "What do you need help with?"
                textView.textColor = UIColor.lightGray
            } else {
                textView.text = "0"
                textView.textColor = UIColor.lightGray
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func invalidInputCost(inputPoints: Int, userBalance: Int) -> Bool {
        if inputPoints <= 0 || inputPoints > userBalance {
            return true
        }

        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.descriptionTextView.resignFirstResponder()
        self.subjectsTextField.resignFirstResponder()
        return true
    }
}

extension HelpController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        subjects.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        subjects[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        subjectsTextField.text = subjects[row]
    }
}
