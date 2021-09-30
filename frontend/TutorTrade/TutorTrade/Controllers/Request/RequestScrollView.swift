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

    convenience init(scrollWidth: CGFloat, scrollHeight: CGFloat) {
        self.init(frame: CGRect(x: 10, y: 10, width: scrollWidth, height: scrollHeight))
        self.backgroundColor = .white
        self.contentSize = CGSize(width: 0, height: scrollHeight * 2)
        self.addSubview(subjectRequestView)
    }
}
