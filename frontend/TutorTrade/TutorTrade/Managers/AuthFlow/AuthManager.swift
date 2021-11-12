//
//  AuthManager.swift
//  TutorTrade
//
//  Created by brock davis on 10/28/21.
//


import UIKit
import JWTDecode

protocol AuthManager {
    var credentials: AuthCredentials? { get set }
}

class DefaultAuthManager: AuthManager, Codable {

    private(set) static var shared: DefaultAuthManager = {
        if let data = UserDefaults.standard.data(forKey: authManagerKey) {
            if let credentials = try? JSONDecoder().decode(AuthCredentials.self, from: data) {
                return DefaultAuthManager(credentials: credentials)
            }
        }
        return DefaultAuthManager(credentials: nil)
    }()
    
    private static let authManagerKey = "DefaultAuthManager.shared"

    var isLoggedIn: Bool {
        get {
            guard  _credentials != nil else {
                return false
            }
            
            let accessToken = _credentials!.accessToken
            let jwt = try! decode(jwt: accessToken!)
            
            return !jwt.expired
        }
    }
    
    var userId: String? {
        get {
            
            guard  _credentials != nil else {
                return nil
            }
            
            let idToken = _credentials!.idToken
            let jwt = try! decode(jwt: idToken!)
            
            let id = jwt.subject!
            
            return String(id[id.index(id.startIndex, offsetBy: 4)...])
        }
    }
    
    var userPhoneNumber: String? {
        get {
            guard  _credentials != nil else {
                return nil
            }
            
            let idToken = _credentials!.idToken
            let jwt = try! decode(jwt: idToken!)
            
            return jwt.claim(name: "phone_number").string!
        }
    }

    var authHeader: (String, String)? {
        get {
            guard  _credentials != nil else {
                return nil
            }
            
            let header = "Authorization"
            let bearerToken = "Bearer" + _credentials!.accessToken!
            return (header, bearerToken)
        }
    }
    
    var audience: String {
        get {
            Properties.backendBaseEndpoint
        }
    }
    
    var scopes: String {
        get {
//            let jwt = try! decode(jwt: _credentials.accessToken)
            return "openid sms offline_access user"
        }
    }
    
    private init(credentials: AuthCredentials?) {
        self._credentials = credentials
    }
    
    private var _credentials: AuthCredentials?
    
    var credentials: AuthCredentials? {
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
            let data = try? JSONEncoder().encode(self._credentials!)
            UserDefaults.standard.set(data, forKey: Self.authManagerKey)
        }
    }
    
    func logOut() {
        self._credentials = nil
        UserDefaults.standard.removeObject(forKey: Self.authManagerKey)
    }
}
