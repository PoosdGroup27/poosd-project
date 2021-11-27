//
//  TutorProfileManager.swift
//  TutorTrade
//
//  Created by brock davis on 10/10/21.
//

import Foundation

protocol TutorProfileManager: AnyObject {
    
    var profile : TutorProfile { get set}
    
}

class DefaultTutorProfileManager : TutorProfileManager, Codable {
    
    private(set) static var shared: DefaultTutorProfileManager?
    private static let userDefaultsKey = "DefaultTutorProfileManager.shared"
    private static let baseUserEndpoint = URL(string: Properties.backendBaseEndpoint + Properties.userPath)!
    
    init(profile: TutorProfile) {
        self._profile = profile
    }
    
    private var _profile: TutorProfile
    
    private var userURL: URL {
        get {
            URL(string: Self.baseUserEndpoint.absoluteString + "/" + _profile.userId)!
        }
    }
    
    var profile : TutorProfile {
        get {
            _profile
        } set {
            _profile = newValue
            var request = URLRequest(url: userURL)
            request.httpMethod = "PATCH"
            request.httpBody = try! JSONEncoder().encode(newValue)
            print("Request: \(String(data: request.httpBody!, encoding: .utf8) ?? "Error")")
            request.allowsCellularAccess = true
            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    NotificationCenter.default.post(name: .tutorProfileUpdatedFailed, object: self)
                } else {
                    NotificationCenter.default.post(name: .tutorProfileUpdated, object: self)
                    print("response: \(String(data: data!, encoding: .utf8) ?? "Error")")
                    self.persistProfileToDisk()
                }
            }.resume()
        }
    }
    
    fileprivate func persistProfileToDisk() {
        DispatchQueue.global(qos: .background).async {
            let data = try? JSONEncoder().encode(self._profile)
            UserDefaults.standard.set(data, forKey: Self.userDefaultsKey)
        }
    }
    
    
    static func loadProfile(withId id: String, callback: @escaping (Bool) -> Void) {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey) {
            let storedProfile = try? JSONDecoder().decode(TutorProfile.self, from: data)
            if storedProfile?.userId == id {
                print("Loaded profile from user defaults")
                Self.shared = DefaultTutorProfileManager(profile: storedProfile!)
                callback(true)
                return
            }
        }
        let url = URL(string: Self.baseUserEndpoint.absoluteString + "/" + id)!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil || (response! as! HTTPURLResponse).statusCode != 200 {
                callback(false)
                return
            }
            if let response = try? JSONDecoder().decode(APIResponse<TutorProfile>.self, from: data!) {
                Self.shared = DefaultTutorProfileManager(profile: response.body)
                Self.shared!.persistProfileToDisk()
                callback(true)
                NotificationCenter.default.post(name: .tutorProfileLoaded, object: self)
                return
            }
            callback(false)
            return
            
        }.resume()
    }
    
    static func createProfile(request createProfileRequest: ProfileCreationRequest, completionHander: @escaping (Bool) -> Void) {
        let url = URL(string: baseUserEndpoint.absoluteString + "/" + createProfileRequest.userId)!
        print("Request: \(createProfileRequest)")
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allowsCellularAccess = true
        request.httpBody = try! JSONEncoder().encode(createProfileRequest)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil || (response! as! HTTPURLResponse).statusCode != 200 {
                completionHander(false)
                return
            }
            let response = try! JSONDecoder().decode(APIResponse<TutorProfile>.self, from: data!)
            Self.shared = DefaultTutorProfileManager(profile: response.body)
            Self.shared!.persistProfileToDisk()
            completionHander(true)
            NotificationCenter.default.post(name: .tutorProfileLoaded, object: self)
        }.resume()
    }
    
    func logOut() {
        UserDefaults.standard.removeObject(forKey: Self.userDefaultsKey)
    }
}
