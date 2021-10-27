//
//  RequestScrollView.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 9/29/21.
//

import UIKit

protocol RequestScrollViewDelegate {
    func onTapSubmitButton(subject: String, urgency: String, description: String, preferredMedium: String, budget: String)
}

class RequestScrollView: UIScrollView, UITextFieldDelegate {
    
    private enum PreferredMediumEnum : String {
        case inPerson = "IN_PERSON"
        case online = "ONLINE"
    }

    private enum UrgencyEnum: String {
        case today = "IMMEDIATE" // change this to today later on
        case tomorrow = "TOMORROW"
        case thisWeek = "THIS_WEEK"
    }
    
    var scrollWidth: CGFloat = 0.0
    var scrollHeight: CGFloat = 0.0
    var subject: String = ""
    var urgency: String = ""
    var descriptionText: String = ""
    var preferredMedium: String = ""
    var budget: String = ""
    var requestScrollViewDelegate: RequestScrollViewDelegate!
    
    let subjectRequestView: SubjectView! = {
        let view = SubjectView()
        return view
    }()
    
    let submitRequestButton: SubmitButtonView! = {
        let view = SubmitButtonView()
        return view
    }()
    
    let urgencyView: UrgencyView! = {
        let view = UrgencyView()
        return view
    }()
    
    let descriptionRequestView: DescriptionView! = {
        let view = DescriptionView()
        return view
    }()
    
    let preferredMediumView: PreferredMediumView! = {
        let view = PreferredMediumView()
        return view
    }()
    
    let pointsView: PointsView! = {
        let view = PointsView()
        return view
    }()

    convenience init(scrollWidth: CGFloat, scrollHeight: CGFloat) {
        self.init(frame: CGRect(x: 10, y: 10, width: scrollWidth, height: scrollHeight))
        
        // Configuring scrollview
        self.backgroundColor = .white
        self.contentSize = CGSize(width: 0, height: scrollHeight + 210)
        
        
        // Adding delegates to text fields
        self.subjectRequestView.subjectTextField.delegate = self
        self.descriptionRequestView.descriptionTextField.delegate = self
        
        // Adding subviews
        self.addSubview(subjectRequestView)
        self.addSubview(urgencyView)
        self.addSubview(descriptionRequestView)
        self.addSubview(preferredMediumView)
        self.addSubview(pointsView)
        self.addSubview(submitRequestButton)
        
        // Adding button targets
        addButtonTargets()
    }

    func setScrollViewInputs() {
        self.subject = subjectRequestView.subjectTextField.text ?? "no user input"
        self.descriptionText = descriptionRequestView.descriptionTextField.text ?? "no user input"
        self.budget = pointsView.pointsTextField.text ?? "no user input"
    }

    func addButtonTargets() {
        addSubmitButtonActions()
        addUrgencyButtonActions()
        addPreferredMediumButtonActions()
        addPointsButtonActions()
    }
    
    func addSubmitButtonActions() {
        submitRequestButton.submitButton.addTarget(self, action: #selector(onTapSubmitButton), for: .touchDown)
        submitRequestButton.submitButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    func addUrgencyButtonActions() {
        urgencyView.nowButton.addTarget(self, action: #selector(onTapUrgencyButtons), for: .touchDown)
        urgencyView.nowButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        urgencyView.todayButton.addTarget(self, action: #selector(onTapUrgencyButtons), for: .touchDown)
        urgencyView.todayButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        urgencyView.thisWeekButton.addTarget(self, action: #selector(onTapUrgencyButtons), for: .touchDown)
        urgencyView.thisWeekButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    func addPreferredMediumButtonActions() {
        preferredMediumView.inPersonButton.addTarget(self, action: #selector(onTapInPersonButton), for: .touchDown)
        preferredMediumView.inPersonButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        preferredMediumView.onlineButton.addTarget(self, action: #selector(onTapOnlineButton), for: .touchDown)
        preferredMediumView.onlineButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    func addPointsButtonActions() {
        pointsView.addPointsButton.addTarget(self, action: #selector(onTapButton), for: .touchDown)
        pointsView.addPointsButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        pointsView.reducePointsButton.addTarget(self, action: #selector(onTapButton), for: .touchDown)
        pointsView.reducePointsButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    // Button animations
    @objc func didTapButton(_ selector: UIButton) {
        print(self.preferredMedium)
        print(self.urgency)
        selector.layer.borderWidth = 1
    }
    
    @objc func onTapButton(_ selector: UIButton) {
        selector.layer.borderWidth = 3
    }
    
    @objc func onTapUrgencyButtons(_ selector: UIButton) {
        selector.layer.borderWidth = 3
        if (selector.titleLabel?.text == "Today") {
            self.urgency = UrgencyEnum.today.rawValue
        } else if (selector.titleLabel?.text == "Tomorrow") {
            self.urgency = UrgencyEnum.tomorrow.rawValue
        } else {
            self.urgency = UrgencyEnum.thisWeek.rawValue
        }
    }
    
    @objc func onTapInPersonButton(_ selector: UIButton) {
        selector.layer.borderWidth = 3
        self.preferredMedium = PreferredMediumEnum.inPerson.rawValue
    }
    
    @objc func onTapOnlineButton(_ selector: UIButton) {
        selector.layer.borderWidth = 3
        self.preferredMedium = PreferredMediumEnum.online.rawValue
    }
    
    @objc func onTapSubmitButton(_ selector: UIButton) {
        selector.layer.borderWidth = 3
        setScrollViewInputs()
        requestScrollViewDelegate.onTapSubmitButton(subject: subject, urgency: urgency, description: descriptionText, preferredMedium: preferredMedium, budget: budget)
    }

    // Hide keyboard fucntions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.subjectRequestView.subjectTextField.resignFirstResponder()
        self.descriptionRequestView.descriptionTextField.resignFirstResponder()
        return true
    }
}
