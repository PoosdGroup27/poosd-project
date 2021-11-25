//
//  TuteeManager.swift
//  TutorTrade
//
//  Created by brock davis on 11/14/21.
//

import Foundation

internal class TuteeManager {
    
    private var tuteeCache: [String: Tutee] = [:]
    
    func getTutee(withId tuteeId: String) -> Tutee? {
        
        print("Requesting profile for tutee with id: \(tuteeId)")
        
        if let tutee = tuteeCache[tuteeId] {
            return tutee
        }
        
        let request = URLRequest(url: URL(string: Properties.backendBaseEndpoint + Properties.tuteePath + "/" + tuteeId)!)
        
        var tutee: Tutee?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            defer {
                semaphore.signal()
            }
            
            if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                print("received an error response")
                tutee = nil
            }
            tutee = try! JSONDecoder().decode(APIResponse<Tutee>.self, from: data!).body
            
        }.resume()
        
        semaphore.wait()
        
        if let tutee = tutee {
            tuteeCache[tutee.userId] = tutee
        }
        
        return tutee
    }
    
    func getTutees(withIds tuteeIds: [String]) -> [String: Tutee] {
        
        var tuteeProfiles: [String: Tutee] = [:]
        
        for tuteeId in tuteeIds {
            tuteeProfiles[tuteeId] = self.getTutee(withId: tuteeId)
        }
        
        return tuteeProfiles
    }
}
