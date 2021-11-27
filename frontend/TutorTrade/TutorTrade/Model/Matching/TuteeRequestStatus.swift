//
//  TuteeRequestStatus.swift
//  TutorTrade
//
//  Created by brock davis on 11/20/21.
//

import Foundation

internal enum TuteeRequestStatus: String, Codable {
    case undecided = "UNDECIDED"
    case accepted = "ACCEPTED"
    case declined = "DECLINED"
    case chatting = "CHATTING"
    case completed = "COMPLETED"
    case reviewed = "REVIEWED"
}
