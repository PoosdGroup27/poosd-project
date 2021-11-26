//
//  MatchingRequest.swift
//  TutorTrade
//
//  Created by brock davis on 11/20/21.
//

import Foundation

internal struct MatchingRequest: Codable {
    
    let requestId: String
    
    let status: TuteeRequestStatus
    
}
