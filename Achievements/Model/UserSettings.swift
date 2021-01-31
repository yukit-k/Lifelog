//
//  Profile.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import Foundation

struct UserSettings {
    var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }
    
    var notification: Bool {
        didSet {
            UserDefaults.standard.set(notification, forKey: "notification")
        }
    }
    
    var categories: [Category] {
        didSet {
            UserDefaults.standard.set(categories, forKey: "categories")
        }
    }
        
    init() {
        self.username = UserDefaults.standard.string(forKey: "username") ?? "Your Name"
        self.notification = UserDefaults.standard.bool(forKey: "notification")
        self.categories = UserDefaults.standard.object(forKey: "categories") as? [Category] ?? [
            Category(name: "Book", icon: "📚", unit: "page", subCategories: [Category(name: "Not Selected"), Category(name: "Picture Book"), Category(name: "Fiction"), Category(name: "Non-Fiction"), Category(name: "Textbook"), Category(name: "Others")]),
            Category(name: "Task", icon: "🧾", unit: "minutes", subCategories: [Category(name: "Not Selected"), Category(name: "Study"), Category(name: "Choir"), Category(name: "Hobby"), Category(name: "Job"), Category(name: "Others")]),
            Category(name: "Exercise", icon: "🏃‍♀️", unit: "minutes", subCategories: [Category(name: "Not Selected"), Category(name: "Running"), Category(name: "Walking"), Category(name: "Cycling"), Category(name: "Indoor"), Category(name: "Outdoor"), Category(name: "Others")]),
            Category(name: "Health", icon: "💖", subCategories: [Category(name: "Not Selected"), Category(name: "Height", unit:"cm"), Category(name: "Weight", unit:"kg"), Category(name: "BMI"), Category(name: "Others")]),
            Category(name: "Cook", icon: "🥕", subCategories: [Category(name: "Not Selected"), Category(name: "Dinner"), Category(name: "Lunch"), Category(name: "Breakfast"), Category(name: "Desert"), Category(name: "Others")]),
            Category(name: "Others", icon: "🗂", subCategories: [Category(name: "Not Selected"), Category(name: "Others")])
        ]
        
    }
    
    func getSubCategories(categoryName: String) -> [Category] {
        if let found = self.categories.first(where: {$0.name == categoryName}) {
            return found.subCategories ?? []
        } else {
            return []
        }
    }
    
    func getCategoryIcon(categoryName: String) -> String {
        if let found = self.categories.first(where: {$0.name == categoryName}) {
            return found.icon ?? ""
        } else {
            return ""
        }
    }
}
