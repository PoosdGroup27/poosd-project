//
//  StudentModel.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 11/9/21.
//

import Foundation

struct StudentModel: Codable {
    let name: String
    let school: String
    let subject: String
    let rating: Double
    let urgency: String
    let description: String
    let budget: Int
    let preferredMedium: String
}
