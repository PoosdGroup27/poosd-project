//
//  PreferredTutoringMedium.swift
//  TutorTrade
//
//  Created by brock davis on 11/14/21.
//

import Foundation

enum TutoringMedium: String, Codable {
    case inPerson = "IN_PERSON"
    case online = "ONLINE"
    
    var textRepresentation: String {
        get {
            switch self {
            case .inPerson:
                return "In person"
            case .online:
                return "Online"
            }
        }
    }
    
    init(textRepresentation: String) {
        switch textRepresentation {
        case "In person":
            self = .inPerson
        default:
            self = .online
        }
    }
}
