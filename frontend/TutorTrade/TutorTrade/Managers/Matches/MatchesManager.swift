//
//  MatchesManager.swift
//  TutorTrade
//
//  Created by brock davis on 11/28/21.
//

import Foundation

internal class MatchesManager {
    
    private let tuteeManager = TuteeManager()
    private let tuteeRequestManager = TuteeRequestManager()
    
    var matches: [Match]? {
        get {
            
            let matches = getMatches()
            guard matches != nil && !matches!.isEmpty else {
                return []
            }
            
            let requests = tuteeRequestManager.requests(forRequestIds: matches!.values.map {$0.requestId})
            
            guard !requests.isEmpty else {
                return []
            }
            
            let profiles = tuteeManager.getTutees(withIds: requests.values.map {$0.requesterId})
            
            guard !profiles.isEmpty else {
                return []
            }
            
            var completeMatches: [Match] = []
            
            for request in requests.values {
                
                if let tuteeProfile = profiles[request.requesterId] {
                    completeMatches.append(Match(request: request, tutee: tuteeProfile, status: matches![request.requestId]!.status))
                }
            }
            
            return completeMatches
        }
    }
    
    private func getMatches() -> [String: MatchingRequest]? {
        
        let userId = DefaultTutorProfileManager.shared!.profile.userId
        let matchesRequest = URLRequest(url: URL(string: Properties.backendBaseEndpoint + Properties.matchesPath + "/" + userId)!)
        var matches: [String: MatchingRequest] = [:]
        
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: matchesRequest) { data, response, error in
            
            defer {
                semaphore.signal()
            }
            
            if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                return
            }
            
            let response = try? JSONDecoder().decode(Dictionary<String, TuteeRequestStatus>.self, from: data!)
            
            if let response = response {
                for requestId in response.keys {
                    matches[requestId] = MatchingRequest(requestId: requestId, status: response[requestId]!)
                }
            }
            
        }.resume()
        
        semaphore.wait()
        return matches
    }
    
    func updateMatch(requestId: String, toStatus status: TuteeRequestStatus) {
        var request = URLRequest(url: URL(string: Properties.backendBaseEndpoint + Properties.matchPath + "/" + requestId)!)
        let match = MatchStatusUpdate(tutorId: DefaultTutorProfileManager.shared!.profile.userId, statusUpdate: status)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(match)
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                print("Unable to update match to: \(status.rawValue)")
            } else {
                print("Sucessfully updated match to: \(status.rawValue)")
            }
        }.resume()
    }
}
