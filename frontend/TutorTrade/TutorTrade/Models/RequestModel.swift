//
//  RequestModel.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/6/21.
//

import Foundation

struct RequestModel: Codable {
    var urgency: Int
    var preferredMedium: Int
    var subject: String
    var description: String
    var budget: String
}
