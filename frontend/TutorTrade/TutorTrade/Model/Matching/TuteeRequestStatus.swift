//
//  TuteeRequestStatus.swift
//  TutorTrade
//
//  Created by brock davis on 11/20/21.
//

import Foundation

internal enum TuteeRequestStatus: String, Codable {
    case accepted = "ACCEPTED"
    case denied = "DENIED"
    case chatting = "CHATTING"
    case unanswered = "UNANSWERED"
}
