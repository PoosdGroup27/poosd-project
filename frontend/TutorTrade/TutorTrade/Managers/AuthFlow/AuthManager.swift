//
//  AuthManager.swift
//  TutorTrade
//
//  Created by brock davis on 10/28/21.
//

import Foundation

internal class AuthManager {
    
    static var shared = AuthManager()
    
    var isLoggedIn: Bool
    
    var phoneNumber: String
    
    var userId: String
    
    private init() {
        isLoggedIn = false
        phoneNumber = "+13868711300"
        userId = "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"
    }
    
}
