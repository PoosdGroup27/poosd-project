//
//  TutorProfileManager.swift
//  TutorTrade
//
//  Created by brock davis on 10/10/21.
//

import Foundation

protocol TutorProfileManager {
    
    var profile : TutorProfile { get set}
    
}

class DefaultTutorProfileManager : TutorProfileManager {
    
    var profile : TutorProfile
    var profileListeners : [(TutorProfile) -> ()]?
    
    init(profileListeners :  [(TutorProfile) -> ()]? = nil ) {
        self.profileListeners = profileListeners
        
        profile = TutorProfile(firstName: "Hudson", lastName: "Davis", profilePhoto: nil, pointBalance: 100, school: "University of Central Florida", major: "Computer Science", tutoringSubjects: Set<String>(["Mathematics"]), rating: 4.9)
    }
    
    func updateSchool(updatedSchool : String) {
        
    }
    
    func updateMajor(updatedMajor : String) {
        
    }
    
    func addTutoringSubject(subject : String) {
        
    }
    
    func removeTutoringSubject(subject : String) {
        
    }
    
}
