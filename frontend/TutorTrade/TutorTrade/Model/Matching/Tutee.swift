//
//  Tutee.swift
//  TutorTrade
//
//  Created by brock davis on 11/14/21.
//

import UIKit
 
struct Tutee: Codable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try values.decode(String.self, forKey: .userId)
        self.name = try values.decode(String.self, forKey: .name)
        self.profilePhoto = UIImage(named: "DefaultUserImage")?.resizedTo(CGSize(width: 350, height: 350))
        self.school = try values.decode(String.self, forKey: .school)
        self.rating = try values.decode(Double.self, forKey: .rating)
        self.phoneNumber = try values.decode(String.self, forKey: .phoneNumber)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encode(name, forKey: .name)
        try container.encode(school, forKey: .school)
        try container.encode(rating, forKey: .rating)
        try container.encode(phoneNumber, forKey: .phoneNumber)
    }
    
    
    let userId: String
    
    let name: String
    
    let profilePhoto: UIImage?
    
    let school: String
    
    let rating: Double
    
    let phoneNumber: String
    
    enum CodingKeys: String, CodingKey {
        case userId
        case name
        case school
        case rating
        case phoneNumber
    }
}
