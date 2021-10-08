//
//  RequestManager.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/7/21.
//

import Foundation

final class RequestManager {
    
    let url = "https://1k0cm1e1n9.execute-api.us-east-1.amazonaws.com/prod/request/create"
    
    func postRequestData(requestModel: RequestModel) {
        let requestURL = URL(string: url)
        let jsonEncoder = JSONEncoder()
        let requestData = try? jsonEncoder.encode(requestModel)
        var request = URLRequest(url: requestURL!)

        guard let body = try? JSONSerialization.jsonObject(with: requestData!, options: .allowFragments) as? [String: Any] else {
            print("error!")
            return
        }

        // Give the request a method, body, headers
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        // make the request
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let response = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print("RESPONSE: \(response)")
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}
