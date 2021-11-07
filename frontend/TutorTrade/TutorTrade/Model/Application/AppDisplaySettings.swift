//
//  AppDisplaySettings.swift
//  TutorTrade
//
//  Created by brock davis on 10/14/21.
//

import Foundation


struct AppDisplaySettings : Codable {
    
    let tutoringSubjects : [String]
    
    internal init(tutoringSubjects: [String]) {
        self.tutoringSubjects = tutoringSubjects
    }
}
