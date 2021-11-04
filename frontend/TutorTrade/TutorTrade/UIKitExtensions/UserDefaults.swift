//
//  UserDefaults.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 11/4/21.
//

import UIKit
import JWTDecode

extension UserDefaults {
    
    func setIsLoggedIn(isLoggedIn: Bool) {
        set(isLoggedIn, forKey: "isLoggedIn")
        synchronize()
    }
    
    func getIsLoggedIn() -> Bool {
        return bool(forKey: "isLoggedIn")
    }
    
    func setUserPhoneNumber(userPhoneNumber: String?) {
        set(userPhoneNumber, forKey: "userPhoneNumber")
        synchronize()
    }
    
    func getUserPhoneNumber() -> String? {
        return string(forKey: "userPhoneNumber")
    }
    
    func setUserId(userId: String?) {
        set(userId, forKey: "userId")
        synchronize()
    }
    
    func getUserId() -> String? {
        return string(forKey: "userId")
    }
    
    func setIdToken(idToken: String?) {
        set(idToken, forKey: "idToken")
        synchronize()
    }
    
    func getIdToken() -> String? {
        return string(forKey: "idToken")
    }
    
    func setAccessToken(accessToken: String?) {
        set(accessToken, forKey: "accessToken")
        synchronize()
    }
    
    func getAccessToken() -> String? {
        return string(forKey: "accessToken")
    }
    
    func setAuthHeaderZero(authorization: String?) {
        set(authorization, forKey: "authorization")
        synchronize()
    }
    
    func getAuthHeaderZero() -> String? {
        return string(forKey: "authorization")
    }
    
    func setAuthHeaderOne(bearerToken: String?) {
        set(bearerToken, forKey: "bearerToken")
        synchronize()
    }
    
    func getAuthHeaderOne() -> String? {
        return string(forKey: "bearerToken")
    }
}
