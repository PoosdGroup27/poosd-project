//
//  SubjectsResponse.swift
//  TutorTrade
//
//  Created by brock davis on 10/15/21.
//

import Foundation

struct SubjectsResponse : Codable {
    
    let statusCode: Int
    
    let body: [String]
}
