//
//  TutoringRequestUrgency.swift
//  TutorTrade
//
//  Created by brock davis on 11/14/21.
//

import Foundation

enum TutoringRequestUrgency: String, Codable {
    case today = "TODAY"
    case tomorrow = "TOMORROW"
    case thisWeek = "THIS_WEEK"
    
    var textRepresentation: String {
        get {
            switch self {
            case .today:
                return "Today"
            case .tomorrow:
                return "Tomorrow"
            case .thisWeek:
                return "This week"
            }
        }
    }
    
    init(textRepresentation: String) {
        switch textRepresentation {
        case "Today":
            self = .today
        case "Tomorrow":
            self = .tomorrow
        default:
            self = .thisWeek
        }
    }
}
