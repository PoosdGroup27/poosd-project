//
//  Match.swift
//  TutorTrade
//
//  Created by brock davis on 11/28/21.
//

import Foundation

internal struct Match {
    
    let request: TuteeRequest
    
    let tutee: Tutee
    
    var status: TuteeRequestStatus
    
    var role: RequestRole {
        (request.requesterId == DefaultAuthManager.shared.userId!) ? .tutee : .tutor
    }
}
