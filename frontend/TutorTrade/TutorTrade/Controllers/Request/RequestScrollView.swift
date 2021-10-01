//
//  RequestScrollView.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 9/29/21.
//

import UIKit

class RequestScrollView: UIScrollView {
    
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
    
    let nowButton: NowButton! = {
        let button = NowButton()
        return button
    }()
    
    let todayButton: TodayButton! = {
        let button = TodayButton()
        return button
    }()
    
    let thisWeekButton: ThisWeekButton! = {
        let button = ThisWeekButton()
        return button
    }()
    
    let urgencyLabel: UrgencyLabel! = {
        let label = UrgencyLabel()
        return label
    }()
    
    let descriptionRequestView: UITextField! = {
        let textField = DescriptionTextField()
        return textField
    }()
    
    let preferredMediumView: PreferredMediumView! = {
        let label = PreferredMediumView()
        return label
    }()

    convenience init(scrollWidth: CGFloat, scrollHeight: CGFloat) {
        self.init(frame: CGRect(x: 10, y: 10, width: scrollWidth, height: scrollHeight))
        self.backgroundColor = .white
        self.contentSize = CGSize(width: 0, height: scrollHeight)

        self.addSubview(subjectRequestView)
        self.addSubview(urgencyLabel)
        self.addSubview(nowButton)
        self.addSubview(todayButton)
        self.addSubview(thisWeekButton)
        self.addSubview(submitRequestButton)
        self.addSubview(descriptionRequestView)
        self.addSubview(preferredMediumView)
        
        submitRequestButton.addTarget(self, action: #selector(didTapSubmitRequestButton), for: .touchUpInside)
        nowButton.addTarget(self, action: #selector(didTapNowButton), for: .touchUpInside)
        todayButton.addTarget(self, action: #selector(didTapTodayButton), for: .touchUpInside)
        thisWeekButton.addTarget(self, action: #selector(didTapThisWeekButton), for: .touchUpInside)
    }
    
    @objc func didTapSubmitRequestButton() {
        print("Pressed the button!")
        print(subjectRequestView.text ?? "no text entered")
    }
    
    @objc func didTapNowButton() {
        print("Pressed the now!")
    }
    
    @objc func didTapTodayButton() {
        print("Pressed the today!")
    }
    
    @objc func didTapThisWeekButton() {
        print("Pressed the this week!")
    }
}
