//
//  UIScrollableButtonArray.swift
//  TutorTrade
//
//  Created by brock davis on 11/29/21.
//

import UIKit

class UIScrollableButtonArray: UIView {

    private let buttons: [UIButton]
    
    private let indexIndicatorButtons: [UIButton]
    
    private let scrollView: UIScrollView
    
    private let stackView: UIStackView
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }

    init() {
        super.init(frame: .zero)
    }
}
