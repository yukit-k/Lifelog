//
//  UserProfile.swift
//  Achievements
//
//  Created by Yuki Takahashi on 04/02/2021.
//
//

import SwiftUI

class UserProfile: ObservableObject {
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }
    @Published var notification: Bool {
        didSet {
            UserDefaults.standard.set(notification, forKey: "notification")
        }
    }
    @Published var usericon: String {
        didSet {
            UserDefaults.standard.set(usericon, forKey: "usericon")
        }
    }
        
    init() {
        self.username = UserDefaults.standard.string(forKey: "username") ?? "Your Name"
        self.notification = UserDefaults.standard.bool(forKey: "notification")
        self.usericon = UserDefaults.standard.string(forKey: "usericon") ?? "😺"
    }
}
