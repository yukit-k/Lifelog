//
//  UserCategory.swift
//  Achievement
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import SwiftUI

class UserCategory: ObservableObject {
    @Published var categories = [Category]()
        
    init() {
        let decoder = JSONDecoder()
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
    }
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
