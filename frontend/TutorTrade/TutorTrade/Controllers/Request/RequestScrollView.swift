//
//  RequestScrollView.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 9/29/21.
//

import UIKit

class RequestScrollView: UIScrollView, UITextFieldDelegate {
    
    var scrollWidth: CGFloat = 0.0
    var scrollHeight: CGFloat = 0.0
    var subject: String = ""
    var urgency: Int = 0
    var descriptionText: String = ""
    var preferredMedium: Int = 0
    var budget: String = ""
    var requestModel: RequestModel! = nil
    
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
        self.requestModel = RequestModel(urgency: urgency, preferredMedium: preferredMedium, subject: subject, description: descriptionText, budget: budget)
    }

    func setRequestModel() {
        requestModel.subject = subjectRequestView.subjectTextField.text ?? "no user input"
        requestModel.description = descriptionRequestView.descriptionTextField.text ?? "no user input"
        requestModel.budget = pointsView.pointsTextField.text ?? "no user input"
        requestModel.urgency = self.urgency
        requestModel.preferredMedium = self.preferredMedium
    }
    
    // Adding all of the targets to the buttons in request page
    func addButtonTargets() {
        submitRequestButton.submitButton.addTarget(self, action: #selector(onTapSubmitButton), for: .touchDown)
        submitRequestButton.submitButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        urgencyView.nowButton.addTarget(self, action: #selector(onTapUrgencyButtons), for: .touchDown)
        urgencyView.nowButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        urgencyView.todayButton.addTarget(self, action: #selector(onTapUrgencyButtons), for: .touchDown)
        urgencyView.todayButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        urgencyView.thisWeekButton.addTarget(self, action: #selector(onTapUrgencyButtons), for: .touchDown)
        urgencyView.thisWeekButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        preferredMediumView.inPersonButton.addTarget(self, action: #selector(onTapPreferredMediumButtons), for: .touchDown)
        preferredMediumView.inPersonButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        preferredMediumView.onlineButton.addTarget(self, action: #selector(onTapPreferredMediumButtons), for: .touchDown)
        preferredMediumView.onlineButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        pointsView.addPointsButton.addTarget(self, action: #selector(onTapButton), for: .touchDown)
        pointsView.addPointsButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        pointsView.reducePointsButton.addTarget(self, action: #selector(onTapButton), for: .touchDown)
        pointsView.reducePointsButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    // Button animations
    @objc func didTapButton(_ selector: UIButton) {
        print(selector.titleLabel?.text ?? "error" )
        selector.layer.borderWidth = 1
    }
    
    @objc func onTapButton(_ selector: UIButton) {
        selector.layer.borderWidth = 3
    }
    
    @objc func onTapUrgencyButtons(_ selector: UIButton) {
        selector.layer.borderWidth = 3
        if (selector.titleLabel?.text == "Now") {
            self.urgency = 0
        } else if (selector.titleLabel?.text == "Today") {
            self.urgency = 1
        } else {
            self.urgency = 2
        }
        
        print(self.urgency)
    }
    
    @objc func onTapPreferredMediumButtons(_ selector: UIButton) {
        selector.layer.borderWidth = 3
        if (selector.titleLabel?.text == "Person") {
            self.preferredMedium = 0
        } else if (selector.titleLabel?.text == "Online") {
            self.preferredMedium = 1
        }

        print(self.preferredMedium)
    }
    
    @objc func onTapSubmitButton(_ selector: UIButton) {
        selector.layer.borderWidth = 3
        
        setRequestModel()
        
        print(requestModel ?? "Model error")
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
