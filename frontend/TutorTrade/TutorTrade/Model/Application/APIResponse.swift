//
//  SubjectsResponse.swift
//  TutorTrade
//
//  Created by brock davis on 10/15/21.
//

import Foundation

struct APIResponse<T: Codable> : Codable {
    
    let statusCode: Int
    
    let body: T
}
