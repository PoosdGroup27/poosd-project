//
//  RequestManager.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 10/7/21.
//

import Foundation

final class RequestManager {
    
    let url = "https://1k0cm1e1n9.execute-api.us-east-1.amazonaws.com/prod/request/create"
    var requestURL: URL?
    let jsonEncoder = JSONEncoder()
    var requestData: Data?
    var request: URLRequest?
    
    convenience init(requestModel: RequestModel) {
        self.init()
        setUpRequestManager(requestModel: requestModel)
        setUpRequest()
        postRequestData()
    }

    func setUpRequestManager(requestModel: RequestModel) {
        requestURL = URL(string: url)
        requestData = try? jsonEncoder.encode(requestModel)
        request = URLRequest(url: requestURL!)
    }
    
    func setUpRequest() {
        guard let body = try? JSONSerialization.jsonObject(with: requestData!, options: .allowFragments) as? [String: Any] else {
            print("Error getting serialized object inside of request manager.")
            return
        }

        request?.httpMethod = "POST"
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request?.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
    }
    
    func postRequestData() {
        let task = URLSession.shared.dataTask(with: request!) { data, _, error in
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
