//
//  RequestModel.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/6/21.
//

import Foundation

struct RequestModel: Codable {
    var requesterId: String? = "4f49b004-8d43-4561-af02-8ea0364fe300"
    var subject: String? = nil
    var costInPoints: String? = nil
    var urgency: String? = nil
    var platform: String? = nil
    var description: String? = nil
}
