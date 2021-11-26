//
//  CompleteTuteeRequestManager.swift
//  TutorTrade
//
//  Created by brock davis on 11/20/21.
//

import Foundation

internal class MatchingManager {
    
    private let tuteeManager = TuteeManager()
    private let tuteeRequestManager = TuteeRequestManager()
    
    var matchedRequests: [CompleteTuteeRequest]? {
        get {
            
            let availableMatches = getAvailableMatches()
            guard availableMatches != nil && !availableMatches!.isEmpty else {
                return []
            }
            
            let requests = getRequests(requestIds: availableMatches!.map {$0.requestId})
            
            guard !requests.isEmpty else {
                return []
            }
            
            let profiles = getTuteeProfiles(tuteeIds: requests.values.map {$0.requesterId})
            
            guard !profiles.isEmpty else {
                return []
            }
            
            var matchedRequests: [CompleteTuteeRequest] = []
            
            for request in requests.values {
                
                if let tuteeProfile = profiles[request.requesterId] {
                    matchedRequests.append(CompleteTuteeRequest(tutee: tuteeProfile, request: request))
                }
            }
            
            return matchedRequests
        }
    }
    
    private func getAvailableMatches() -> [MatchingRequest]? {
        
        
        let userId = DefaultTutorProfileManager.shared!.profile.userId
        let availableMatchesRequest = URLRequest(url: URL(string: Properties.backendBaseEndpoint + Properties.matchingRequestsPath + "/" + userId)!)
        var availableMatches: [MatchingRequest] = []
        
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: availableMatchesRequest) { data, response, error in
            
            defer {
                semaphore.signal()
            }
            
            if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                return
            }
            
            let response = try? JSONDecoder().decode(Dictionary<String, TuteeRequestStatus>.self, from: data!)
            
            if let response = response {
                for requestId in response.keys {
                    availableMatches.append(MatchingRequest(requestId: requestId, status: response[requestId]!)) 
                }
            }
            
        }.resume()
        
        semaphore.wait()
        return availableMatches
    }
    
    private func getRequests(requestIds: [String]) -> [String: TuteeRequest] {
        tuteeRequestManager.requests(forRequestIds: requestIds)
    }
    
    private func getTuteeProfiles(tuteeIds: [String]) -> [String: Tutee] {
        tuteeManager.getTutees(withIds: tuteeIds)
    }
    
    func matchWith(requestId: String) {
        updateMatch(requestId: requestId, statusUpdate: .chatting)
    }
    
    func unmatchWith(requestId: String) {
        updateMatch(requestId: requestId, statusUpdate: .unanswered)
    }
    
    func declineMatchWith(requestId: String) {
        updateMatch(requestId: requestId, statusUpdate: .denied)
    }
    
    private func updateMatch(requestId: String, statusUpdate: TuteeRequestStatus) {
        var request = URLRequest(url: URL(string: Properties.backendBaseEndpoint + Properties.matchPath + "/" + requestId)!)
        let match = Match(tutorId: DefaultTutorProfileManager.shared!.profile.userId, statusUpdate: statusUpdate)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(match)
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                print("Unable to update match to: \(statusUpdate.rawValue)")
            } else {
                print("Sucessfully updated match to: \(statusUpdate.rawValue)")
            }
        }.resume()
    }
}


