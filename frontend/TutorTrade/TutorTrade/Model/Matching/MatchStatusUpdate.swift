//
//  Match.swift
//  TutorTrade
//
//  Created by brock davis on 11/20/21.
//

import Foundation

internal struct MatchStatusUpdate: Codable {
    
    let tutorId: String
    
    let statusUpdate: TuteeRequestStatus
}
