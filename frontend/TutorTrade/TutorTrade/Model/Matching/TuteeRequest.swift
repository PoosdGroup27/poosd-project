//
//  TuteeRequest.swift
//  TutorTrade
//
//  Created by brock davis on 11/14/21.
//

import Foundation

struct TuteeRequest: Codable {
    
    let requestId: String
    
    let requesterId: String
    
    let subject: String
    
    let urgency: TutoringRequestUrgency
    
    let preferredMedium: TutoringMedium
    
    let budget: Int
    
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case requestId
        case requesterId
        case subject
        case urgency
        case preferredMedium = "platform"
        case budget = "costInPoints"
        case description
    }
}
