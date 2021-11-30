//
//  TuteeRequestManager.swift
//  TutorTrade
//
//  Created by brock davis on 11/14/21.
//

import Foundation

internal class TuteeRequestManager {
    
    func request(forRequestId requestId: String) -> TuteeRequest? {
            
        let tuteeRequestHTTPRequest = URLRequest(url: URL(string: Properties.backendBaseEndpoint + Properties.requestPath + "/" + requestId)!)
        let semaphore = DispatchSemaphore(value: 0)
        
        var tuteeRequest: TuteeRequest?
        
        URLSession.shared.dataTask(with: tuteeRequestHTTPRequest) { data, response, error in
        
            defer {
                semaphore.signal()
            }
                
            if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                print("Error while getting request")
                tuteeRequest = nil
                return
            }
            tuteeRequest = try? JSONDecoder().decode(APIResponse<TuteeRequest>.self, from: data!).body
        }.resume()
        
        semaphore.wait()
        return tuteeRequest
    }
    
    func requests(forRequestIds requestIds: [String]) -> [String: TuteeRequest] {
        
        var requests: [String: TuteeRequest] = [:]
        
        for requestId in requestIds {
            requests[requestId] = self.request(forRequestId: requestId)
        }
        
        return requests
    }
}
