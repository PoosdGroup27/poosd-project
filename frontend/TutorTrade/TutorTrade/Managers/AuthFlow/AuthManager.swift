//
//  AuthManager.swift
//  TutorTrade
//
//  Created by brock davis on 10/28/21.
//

import UIKit
import JWTDecode

internal class AuthManager {
    
    static var shared = AuthManager()
    
    var isLoggedIn: Bool
    var verificationCode: Bool
    private var userPhoneNumber: String?
    private var userId: String?
    private var idToken: String?
    private var accessToken: String?
    private var authHeader: (String?, String?)
    private let audience = "https://1k0cm1e1n9.execute-api.us-east-1.amazonaws.com/prod/"
    private let scopes = "openid sms offline_access read:profile read:requests write:request"
    
    private init() {
        
        if (UserDefaults.standard.getIsLoggedIn()) {
            isLoggedIn = UserDefaults.standard.getIsLoggedIn()
            userPhoneNumber = UserDefaults.standard.getUserPhoneNumber()
            userId = UserDefaults.standard.getUserId()
            idToken = UserDefaults.standard.getIdToken()
            accessToken = UserDefaults.standard.getAccessToken()
            authHeader.0 = UserDefaults.standard.getAuthHeaderZero()
            authHeader.1 = UserDefaults.standard.getAuthHeaderOne()
            verificationCode = false
            return
        }

        isLoggedIn = false
        verificationCode = false
        userPhoneNumber = nil
        userId = nil
        idToken = nil
        authHeader = (nil, nil)
    }
    
    func setIdToken(idToken: String) {
        self.idToken = idToken
    }
    
    func getIdToken() -> String? {
        return self.idToken
    }
    
    func setAccessToken(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func getAccessToken() -> String? {
        return self.accessToken
    }
    
    func setUserPhoneNumber(userPhoneNumber: String) {
        self.userPhoneNumber = userPhoneNumber
    }
    
    func getUserPhoneNumber() -> String? {
        return self.userPhoneNumber
    }

    func setUserId(userId: String) {
        self.userId = userId
    }
    
    func getUserId() -> String? {
        return self.userId
    }
    
    func setAuthHeader(header: String?, accessToken: String?) {
        self.authHeader = (header, "Bearer " + accessToken!)
    }
    
    func getAuthHeader() -> (String?, String?) {
        return self.authHeader
    }
    
    func getAuthScopes() -> String? {
        return self.scopes
    }
    
    func getAuthAudience() -> String? {
        return self.audience
    }
    
    func setIsLoggedIn(isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
    }

    func getIsLoggedIn() -> Bool {
        return self.isLoggedIn
    }
}
