//
//  RequestManager.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/7/21.
//

import Foundation

final class RequestManager {
    
    let url = "endpoint"
    
    func postRequestData(requestModel: RequestModel) {
        let requestURL = URL(string: url)
        var request = URLRequest(url: requestURL!)
        let jsonEncoder = JSONEncoder()
        let requestData = try? jsonEncoder.encode(requestModel)
        let jsonBody = String(data: requestData!, encoding: String.Encoding.utf16)
        
        // method, body, headers
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: jsonBody ?? "error", options: .fragmentsAllowed)
        
        // make the request
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("SUCCESS: \(response)")
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }

// Potentially use these for cleaner code
//    struct RequestResponse: Codable {
//        let result: RequestResult
//        let status: String
//    }
//
//    struct RequestResult: Codable {
//
//    }
}
