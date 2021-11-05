//
//  Notification.swift
//  TutorTrade
//
//  Created by brock davis on 11/2/21.
//

import Foundation

extension Notification.Name {
    
    public static let tutorProfileLoaded: Notification.Name = .init(rawValue: "tutorProfileDidLoad")
    
    public static let tutorProfileUpdated: Notification.Name = .init(rawValue: "tutorProfileDidUpdate")
    
    public static let tutorProfileUpdatedFailed: Notification.Name = .init(rawValue: "tutorProfileUpdateDidFail")
}
