//
//  DisplaySettingsManager.swift
//  TutorTrade
//
//  Created by brock davis on 10/14/21.
//

import Foundation

class DisplaySettingsManager {
    
    static let shared = DisplaySettingsManager()
    
    private var cachedAppDisplaySettings : AppDisplaySettings?
    
    var appDisplaySettings : AppDisplaySettings? {
        get {
            if let cachedAppDisplaySettings = cachedAppDisplaySettings {
                return cachedAppDisplaySettings
            }
            
            let url = URL(string: Properties.backendBaseEndpoint + Properties.subjectsPath)!
            let request = URLRequest(url: url)
            
            var subjectsResponse: SubjectsResponse?
            let semaphore = DispatchSemaphore(value: 0)
            let requestTask = URLSession.shared.dataTask(with: request) { data, response, error in
                defer { semaphore.signal()}
                subjectsResponse = try! JSONDecoder().decode(SubjectsResponse.self, from: data!)
            }
            requestTask.resume()
            semaphore.wait()
            cachedAppDisplaySettings = AppDisplaySettings(tutoringSubjects: subjectsResponse!.body)
            return cachedAppDisplaySettings
        }
    }
}
