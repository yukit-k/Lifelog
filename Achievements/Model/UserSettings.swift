//
//  Profile.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import Foundation

class UserSettings: ObservableObject {
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
    
    @Published var categories: [Category] {
        didSet {
            UserDefaults.standard.set(categories, forKey: "categories")
        }
    }
    
    public var bookGenre = ["Not Selected", "Picture Book", "Fiction", "Non-Fiction", "Textbook", "Others"]
    public var taskGenre = ["Not Selected", "Study", "Choir", "Hobby", "Job", "Others"]
    public var exerciseGenre = ["Not Selected", "Running", "Walking", "Cycling", "Indoor", "Outdoor", "Others"]
    public var cookGenre = ["Not Selected", "Dinner", "Lunch", "Breakfast", "Desert", "Others"]
    public var othersGenre = ["Not Selected", "Others"]
    
    init() {
        self.username = UserDefaults.standard.string(forKey: "username") ?? "Nana"
        self.categories = UserDefaults.standard.object(forKey: "categories") as? [Category] ?? [
            Category(name: "Book", icon: "📚"),
            Category(name: "Task", icon: "🧾"),
            Category(name: "Exercise", icon: "🏃‍♀️"),
            Category(name: "Cook", icon: "🥕"),
            Category(name: "Others", icon: "🗂")
        ]
        self.notification = false
    }
}
