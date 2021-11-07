//
//  TutorProfile.swift
//  TutorTrade
//
//  Created by brock davis on 10/10/21.
//

import Foundation
import UIKit

struct TutorProfile : Codable {
    internal init(name: String, userId: String, profilePhoto: UIImage? = nil, pointBalance: Int, school: String, major: String, tutoringSubjects: Set<String>, rating: Double, phoneNumber: String) {
        self.name = name
        self.userId = userId
        self.profilePhoto = profilePhoto
        self.pointBalance = pointBalance
        self.school = school
        self.major = major
        self.tutoringSubjects = tutoringSubjects
        self.rating = rating
        self.phoneNumber = phoneNumber
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        userId = try values.decode(String.self, forKey: .userId)
        profilePhoto = UIImage(named: "DefaultProfilePhoto")!
        pointBalance = try values.decode(Int.self, forKey: .points)
        school = try values.decode(String.self, forKey: .school)
        major = try values.decode(String.self, forKey: .major)
        tutoringSubjects = try values.decode(Set<String>.self, forKey: .tutoringSubects)
        rating = try values.decode(Double.self, forKey: .rating)
        phoneNumber = try values.decode(String.self, forKey: .phoneNumber)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
    }
    
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case school = "school"
        case major = "major"
        case points = "points"
        case name = "name"
        case rating = "rating"
        case tutoringSubects = "subjectsTeach"
        case phoneNumber = "phoneNumber"
    }
    
    var name: String
    
    var firstName: String {
        get {
            String(name.split(separator: " ").first!)
        }
    }
    
    var lastName: String {
        get {
            String(name.split(separator: " ").last!)
        }
    }
    
    var userId: String
    
    var profilePhoto: UIImage?
    
    var pointBalance: Int
    
    var school: String
    
    var major: String
    
    var tutoringSubjects: Set<String>
    
    var rating: Double
    
    var phoneNumber: String
}
