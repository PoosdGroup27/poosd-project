//
//  ReviewManager.swift
//  TutorTrade
//
//  Created by brock davis on 11/29/21.
//

import Foundation

internal class ReviewManager {
    
    func addReview(forUserId userId: String, review: Review) {
        var request = URLRequest(url: URL(string: Properties.backendBaseEndpoint + Properties.reviewPath + "/" + userId)!)
        request.httpMethod = "PUT"
        request.httpBody = try? JSONEncoder().encode(review)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil || (response as! HTTPURLResponse).statusCode != 200 {
                print("Error while posting review")
            } else {
                print("Sucessfully posted review: \(review)")
            }
            
        }.resume()
    }
}
