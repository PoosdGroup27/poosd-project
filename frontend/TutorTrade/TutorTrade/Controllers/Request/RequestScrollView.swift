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
    
    let subjectRequestView: UITextField! = {
        let textField = SubjectRequestView()
        return textField
    }()
    
    let submitRequestButton: UIButton! = {
        let button = SubmitRequestButton()
        return button
    }()
    
    let urgencyView: UrgencyView! = {
        let view = UrgencyView()
        return view
    }()
    
    let descriptionRequestView: UITextField! = {
        let textField = DescriptionTextField()
        return textField
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
        self.backgroundColor = .white
        self.contentSize = CGSize(width: 0, height: scrollHeight + 50)
        
        self.subjectRequestView.delegate = self
        self.descriptionRequestView.delegate = self

        self.addSubview(subjectRequestView)
        self.addSubview(urgencyView)
//        self.addSubview(submitRequestButton)
        self.addSubview(descriptionRequestView)
        self.addSubview(preferredMediumView)
        self.addSubview(pointsView)
        
        addButtonTargets()
    }
    
    func addButtonTargets() {
        submitRequestButton.addTarget(self, action: #selector(onTapButton), for: .touchDown)
        submitRequestButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        urgencyView.nowButton.addTarget(self, action: #selector(onTapButton), for: .touchDown)
        urgencyView.nowButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        urgencyView.todayButton.addTarget(self, action: #selector(onTapButton), for: .touchDown)
        urgencyView.todayButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        urgencyView.thisWeekButton.addTarget(self, action: #selector(onTapButton), for: .touchDown)
        urgencyView.thisWeekButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        preferredMediumView.inPersonButton.addTarget(self, action: #selector(onTapButton), for: .touchDown)
        preferredMediumView.inPersonButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        preferredMediumView.onlineButton.addTarget(self, action: #selector(onTapButton), for: .touchDown)
        preferredMediumView.onlineButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    @objc func didTapButton(_ selector: UIButton) {
        print(selector.titleLabel?.text ?? "error" )
        selector.layer.borderWidth = 1
    }
    
    @objc func onTapButton(_ selector: UIButton) {
        selector.layer.borderWidth = 3
    }

    // Hide keyboard fucntions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.subjectRequestView.resignFirstResponder()
        self.descriptionRequestView.resignFirstResponder()
        return true
    }
}
