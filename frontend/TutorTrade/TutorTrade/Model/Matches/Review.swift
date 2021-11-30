//
//  Review.swift
//  TutorTrade
//
//  Created by brock davis on 11/29/21.
//

import Foundation

internal struct Review: Codable {
    let rating: Int
    let subject: String
    let reviewEvaluation: String
}
