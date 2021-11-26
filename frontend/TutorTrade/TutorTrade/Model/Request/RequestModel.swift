//
//  RequestModel.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/6/21.
//

import Foundation

struct RequestModel: Codable {
    var requesterId: String = "create"
    var subject: String = ""
    var costInPoints: String = ""
    var urgency: String = ""
    var platform: String = ""
    var description: String = ""
}
