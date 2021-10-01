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

    convenience init(scrollWidth: CGFloat, scrollHeight: CGFloat) {
        self.init(frame: CGRect(x: 10, y: 10, width: scrollWidth, height: scrollHeight))
        self.backgroundColor = .white
        self.contentSize = CGSize(width: 0, height: scrollHeight * 2)
        self.addSubview(subjectRequestView)
        self.addSubview(urgencyLabel)
        self.addSubview(nowButton)
        self.addSubview(todayButton)
        self.addSubview(thisWeekButton)
        self.addSubview(submitRequestButton)
        print(self.frame.width)
        submitRequestButton.addTarget(self, action: #selector(didTapSubmitRequestButton), for: .touchUpInside)
    }
    
    @objc func didTapSubmitRequestButton() {
        print("Pressed the button!")
        print(subjectRequestView.text ?? "no text entered")
    }
}
