//
//  AuthManager.swift
//  TutorTrade
//
//  Created by brock davis on 10/28/21.
//

import UIKit
import JWTDecode

protocol AuthManager {
    var credentials: AuthCredentials { get set }
}

class DefaultAuthManager: AuthManager, Codable {

    private(set) static var shared: DefaultAuthManager?
    private static let authManagerKey = "DefaultAuthManager.shared"

    var isLoggedIn: Bool {
        get {
            let accessToken = _credentials.accessToken
            let jwt = try! decode(jwt: accessToken!)
            
            return jwt.expired
        }
    }
    
    var userPhoneNumber: String {
        get {
            let idToken = _credentials.idToken
            let jwt = try! decode(jwt: idToken!)
            
            return jwt.claim(name: "phone_number").string!
        }
    }

    var authHeader: (String, String) {
        get {
            let header = "Authorization"
            let bearerToken = "Bearer" + _credentials.accessToken!
            return (header, bearerToken)
        }
    }
    
    var audience: [String]? {
        get {
            let jwt = try! decode(jwt: _credentials.accessToken!)
            return jwt.audience
        }
    }
    
    var scopes: String {
        get {
//            let jwt = try! decode(jwt: _credentials.accessToken)
            return "openid sms offline_access user"
        }
    }
    
    init(credentials: AuthCredentials) {
        self._credentials = credentials
    }
    
    private var _credentials: AuthCredentials
    
    var credentials: AuthCredentials {
        get {
            _credentials
        } set {
            _credentials = newValue
            persistAuthCredentialsToDisk()
        }
    }
    
    fileprivate func persistAuthCredentialsToDisk() {
        print("Persisting credentials to disk")
        DispatchQueue.global(qos: .background).async {
            let data = try? JSONEncoder().encode(self._credentials)
            UserDefaults.standard.set(data, forKey: Self.authManagerKey)
        }
        
        print(UserDefaults.standard.object(forKey: Self.authManagerKey))
    }
}
