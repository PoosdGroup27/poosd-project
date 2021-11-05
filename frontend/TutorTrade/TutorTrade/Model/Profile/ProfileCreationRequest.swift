//
//  ProfileCreationRequest.swift
//  TutorTrade
//
//  Created by brock davis on 11/4/21.
//

import Foundation

struct ProfileCreationRequest : Codable {
    let userId: String
    let phoneNumber: String
    let name: String
    let school: String
    let major: String
    let subjectsTeach: Set<String>
}
