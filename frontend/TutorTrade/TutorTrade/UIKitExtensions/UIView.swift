//
//  UIView.swift
//  TutorTrade
//
//  Created by brock davis on 10/26/21.
//

import UIKit

extension UIView {
    
    // Provides interface to succinctly add and configure a subview
    @discardableResult
    func addSubview<T: UIView>(_ subview: T, then closure: (T) -> Void) -> T {
        self.addSubview(subview)
        closure(subview)
        return subview
    }
}
