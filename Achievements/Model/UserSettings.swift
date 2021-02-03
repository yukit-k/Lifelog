//
//  Profile.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import SwiftUI

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
    
    @Published var categories = [Category]()
//    var subCategories = [SubCategory]()
//    var categoryItems = [CategoryItem]()
    
//    static let `default` = UserSettings()
        
    init() {
        self.username = UserDefaults.standard.string(forKey: "username") ?? "Your Name"
        self.notification = UserDefaults.standard.bool(forKey: "notification")
        
        let decoder = JSONDecoder()
        
//        if let categories = defaults.data(forKey: "categories") {
//            if let decoded = try? decoder.decode([Category].self, from: categories) {
//                self.categories = decoded
//            }
//        } else {
//            self.categories = [
//                Category(name: "Book", icon: "📚", unit: "page"),
//                Category(name: "Task", icon: "🧾", unit: "minutes"),
//                Category(name: "Exercise", icon: "🏃‍♀️", unit: "minutes"),
//                Category(name: "Health", icon: "💖"),
//                Category(name: "Cook", icon: "🥕"),
//                Category(name: "Others", icon: "🗂")
//            ]
//        }
//        if let subCategories = defaults.data(forKey: "subCategories") {
//            if let decoded = try? decoder.decode([SubCategory].self, from: subCategories) {
//                self.subCategories = decoded
//            }
//        } else {
//            self.subCategories = [
//                            SubCategory(categoryName: "Book", name: "Not Selected"),
//                            SubCategory(categoryName: "Book", name: "Picture Book"),
//                            SubCategory(categoryName: "Book", name: "Fiction"),
//                            SubCategory(categoryName: "Book", name: "Non-Fiction"),
//                            SubCategory(categoryName: "Book", name: "Textbook"),
//                            SubCategory(categoryName: "Book", name: "Others"),
//                            SubCategory(categoryName: "Task", name: "Not Selected"),
//                            SubCategory(categoryName: "Task", name: "Study"),
//                            SubCategory(categoryName: "Task", name: "Choir"),
//                            SubCategory(categoryName: "Task", name: "Hobby"),
//                            SubCategory(categoryName: "Task", name: "Job"),
//                            SubCategory(categoryName: "Task", name: "Others"),
//                            SubCategory(categoryName: "Exercise", name: "Not Selected"),
//                            SubCategory(categoryName: "Exercise", name: "Running"),
//                            SubCategory(categoryName: "Exercise", name: "Walking"),
//                            SubCategory(categoryName: "Exercise", name: "Cycling"),
//                            SubCategory(categoryName: "Exercise", name: "Indoor"),
//                            SubCategory(categoryName: "Exercise", name: "Outdoor"),
//                            SubCategory(categoryName: "Exercise", name: "Others"),
//                            SubCategory(categoryName: "Health", name: "Not Selected"),
//                            SubCategory(categoryName: "Health", name: "Height", unit:"cm"),
//                            SubCategory(categoryName: "Health", name: "Weight", unit:"kg"),
//                            SubCategory(categoryName: "Health", name: "BMI"),
//                            SubCategory(categoryName: "Health", name: "Others"),
//                            SubCategory(categoryName: "Cook", name: "Not Selected"),
//                            SubCategory(categoryName: "Cook", name: "Dinner"),
//                            SubCategory(categoryName: "Cook", name: "Lunch"),
//                            SubCategory(categoryName: "Cook", name: "Breakfast"),
//                            SubCategory(categoryName: "Cook", name: "Desert"),
//                            SubCategory(categoryName: "Cook", name: "Others"),
//                            SubCategory(categoryName: "Others", name: "Not Selected"),
//                            SubCategory(categoryName: "Others", name: "Others")
//            ]
//        }
        if let categories = UserDefaults.standard.data(forKey: "categories") {
            if let decoded = try? decoder.decode([Category].self, from: categories) {
                self.categories = decoded
            }
        } else {
            self.categories = [
                Category(name: "Book", icon: "📚", unit: "page", subCategories: [
                    SubCategory(name: "Not Selected"),
                    SubCategory(name: "Picture Book"),
                    SubCategory(name: "Fiction"),
                    SubCategory(name: "Non-Fiction"),
                    SubCategory(name: "Textbook"),
                    SubCategory(name: "Others")]),
                Category(name: "Task", icon: "🧾", unit: "minutes", subCategories: [
                    SubCategory(name: "Not Selected"),
                    SubCategory(name: "Study"),
                    SubCategory(name: "Choir"),
                    SubCategory(name: "Hobby"),
                    SubCategory(name: "Job"),
                    SubCategory(name: "Others")]),
                Category(name: "Exercise", icon: "🏃‍♀️", unit: "minutes", subCategories: [
                    SubCategory(name: "Not Selected"),
                    SubCategory(name: "Running"),
                    SubCategory(name: "Walking"),
                    SubCategory(name: "Cycling"),
                    SubCategory(name: "Indoor"),
                    SubCategory(name: "Outdoor"),
                    SubCategory(name: "Others")]),
                Category(name: "Health", icon: "💖", subCategories: [
                    SubCategory(name: "Not Selected"),
                    SubCategory(name: "Height", unit:"cm"),
                    SubCategory(name: "Weight", unit:"kg"),
                    SubCategory(name: "BMI"),
                    SubCategory(name: "Others")]),
                Category(name: "Cook", icon: "🥕", subCategories: [
                    SubCategory(name: "Not Selected"),
                    SubCategory(name: "Dinner"),
                    SubCategory(name: "Lunch"),
                    SubCategory(name: "Breakfast"),
                    SubCategory(name: "Desert"),
                    SubCategory(name: "Others")]),
                Category(name: "Others", icon: "🗂", subCategories: [
                    SubCategory(name: "Not Selected"),
                    SubCategory(name: "Others")])
            ]
        }
    }
    func save() -> Void {

        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(categories) {
            UserDefaults.standard.set(encoded, forKey: "categories")
        }
//        if let encoded = try? encoder.encode(categories) {
//            defaults.set(encoded, forKey: "subCategories")
//       }
    }
    
//    static let `default` = UserSettings()
    
//    func getSubCategories(categoryName: String) -> [SubCategory] {
//
//        return self.subCategories.filter {$0.categoryName == categoryName}
//    }

    func getCategoryIcon(name: String) -> String {
        if let found = self.categories.first(where: {$0.name == name}) {
            return found.icon ?? ""
        } else {
            return ""
        }
    }
    func getSubCategoryIcon(name: String, categoryName: String) -> String {
        if let found = self.categories.first(where: {$0.name == categoryName}) {
            if let found2 = found.subCategories.first(where: {$0.name == name}) {
                return found2.icon ?? ""
            } else {
                return ""
            }
        } else {
            return ""
        }
    }
    func getCategory(name: String) -> Category? {
        if let found = self.categories.first(where: {$0.name == name}) {
            return found
        } else {
            return nil
        }
    }
}
