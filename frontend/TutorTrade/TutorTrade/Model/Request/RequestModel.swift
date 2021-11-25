//
//  RequestModel.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/6/21.
//

import Foundation

struct RequestModel: Codable {
    var requesterId: String? = DefaultAuthManager.shared.userId
    var subject: String? = nil
    var costInPoints: String? = nil
    var urgency: String? = nil
    var platform: String? = nil
    var description: String? = nil
}
