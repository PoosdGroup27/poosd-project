//
//  AuthManager.swift
//  TutorTrade
//
//  Created by brock davis on 10/28/21.
//

import JWTDecode

internal class AuthManager {
    
    static var shared = AuthManager()
    
    var isLoggedIn: Bool
    var typedPhoneNumber: String
    var verificationCode: Bool
    private var userPhoneNumber: String?
    private var userId: String?
    private var stringToken: String?
    private var token: JWT?
    private var authHeader: (String?, String?)
    private let audience = "https://1k0cm1e1n9.execute-api.us-east-1.amazonaws.com/prod/"
    private let scopes = "openid sms offline_access read:profile read:requests write:request"
    
    private init() {
        isLoggedIn = false
        typedPhoneNumber = ""
        verificationCode = false
        userPhoneNumber = nil
        userId = nil
        stringToken = nil
        token = nil
        authHeader = (nil, nil)
    }

    func setTypedPhoneNumber(phoneNumber: String) {
        self.typedPhoneNumber = phoneNumber
    }
    
    func setJWTToken(token: String) {
        self.token = try? decode(jwt: token)
    }
    
    func setUserPhoneNumber(userPhoneNumber: String) {
        self.userPhoneNumber = userPhoneNumber
    }

    func setUserId(userId: String) {
        self.userId = userId
    }
    
    func setAuthHeader(header: String?, accessToken: String?) {
        self.authHeader = (header, accessToken)
    }
    
    func getUserPhoneNumber() -> String? {
        return self.userPhoneNumber
    }

    func getUserId() -> String? {
        return self.userId
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
}
