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
    
    private init() {
        isLoggedIn = false
        
    }
    
}
