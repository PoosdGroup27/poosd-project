//
//  AuthModel.swift
//  TutorTrade
//
//  Created by Sebastian Hernandez on 11/6/21.
//

import UIKit

struct AuthCredentials: Codable {
//    var isLoggedIn: Bool // computed var
    var idToken: String?
    var accessToken: String?
//    var bearerToken: String // computed var
//    var authHeader: (String, String) // computed var
//    var audience = "https://1k0cm1e1n9.execute-api.us-east-1.amazonaws.com/prod/" // computed var
//    var scopes = "openid sms offline_access user" // computed var
}
