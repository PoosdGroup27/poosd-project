//
//  DisplaySettingsManager.swift
//  TutorTrade
//
//  Created by brock davis on 10/14/21.
//

import Foundation

class DisplaySettingsManager {
    
    static let shared = DisplaySettingsManager()
    
    private static let userDefaultsKey = "AppDisplaySettings.shared"
    private var cachedAppDisplaySettings : AppDisplaySettings?
    
    private func persistDisplaySettingsToDisk() {
        DispatchQueue.global(qos: .background).async {
            UserDefaults.standard.set(try? JSONEncoder().encode(self.cachedAppDisplaySettings), forKey: Self.userDefaultsKey)
        }
    }
    
    var appDisplaySettings : AppDisplaySettings? {
        get {
            if let cachedAppDisplaySettings = cachedAppDisplaySettings {
                return cachedAppDisplaySettings
            }
            
            if let data = UserDefaults.standard.data(forKey: Self.userDefaultsKey) {
                if let storedDisplaySettings = try? JSONDecoder().decode(AppDisplaySettings.self, from: data) {
                    cachedAppDisplaySettings = storedDisplaySettings
                    return cachedAppDisplaySettings
                }
            }
            
            let request = URLRequest(url: URL(string: Properties.backendBaseEndpoint + Properties.subjectsPath)!)
            
            var subjectsResponse: APIResponse<[String]>?
            let semaphore = DispatchSemaphore(value: 0)
            let requestTask = URLSession.shared.dataTask(with: request) { data, response, error in
                defer { semaphore.signal()}
                if error != nil {
                    subjectsResponse = APIResponse(statusCode: 200, body: [])
                    return
                }
                subjectsResponse = try! JSONDecoder().decode(APIResponse<[String]>.self, from: data!)
            }
            requestTask.resume()
            semaphore.wait()
            cachedAppDisplaySettings = AppDisplaySettings(tutoringSubjects: subjectsResponse!.body)
            persistDisplaySettingsToDisk()
            return cachedAppDisplaySettings
        }
    }
}
