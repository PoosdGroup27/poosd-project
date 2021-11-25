//
//  Match.swift
//  TutorTrade
//
//  Created by brock davis on 11/24/21.
//

import UIKit

class MatchView: UIView {
    
//    var profileImage: UIImage {
//        get {
//
//        }
//    }
//
//    var name: String {
//        get {
//
//        }
//    }
//
//    var points: Int {
//        get {
//
//        }
//    }
//
//    var rating: Double {
//        get {
//
//        }
//    }
//
//    var subject: String {
//        get {
//
//        }
//    }
//
//    var status: TuteeRequestStatus {
//        get {
//
//        }
//    }
//
//    var role: RequestRole {
//        get {
//
//        }
//    }
    
    private let optionsButton: UIButton = .matchOptionsButton
    private let pointsBox: BorderedDisplayBoxView = .matchDisplayBox(boxType: .pointsBox)
    private let ratingBox: BorderedDisplayBoxView = .matchDisplayBox(boxType: .ratingBox)
    private let subjectBox: BorderedDisplayBoxView = .matchDisplayBox(boxType: .subjectBox)
    private let lineView: UIView = .matchLineSeperator
    
    
//    private let profileImageView: UIImageView
//    private let pointsLabel: UILabel
//    private let ratingLabel: UILabel
//    private let subjectLabel: UILabel
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    init(withProfileImage: UIImage, withName: String, withPoints: Int, withRating: Double, withSubject: String, withStatus: TuteeRequestStatus, withRole: RequestRole) {
        
        super.init(frame: .zero)
        
        
    }

}
