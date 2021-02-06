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
            if NSLocale.current.languageCode == "ja" {
                self.categories = [
                    Category(name: "本", icon: "📚", unit: "ページ", subCategories: [
                        SubCategory(name: "未選択"),
                        SubCategory(name: "絵本"),
                        SubCategory(name: "フィクション"),
                        SubCategory(name: "ノンフィクション"),
                        SubCategory(name: "テキスト"),
                        SubCategory(name: "その他")]),
                    Category(name: "タスク", icon: "🧾", unit: "分", subCategories: [
                        SubCategory(name: "未選択"),
                        SubCategory(name: "勉強"),
                        SubCategory(name: "家事"),
                        SubCategory(name: "趣味"),
                        SubCategory(name: "仕事"),
                        SubCategory(name: "その他")]),
                    Category(name: "エクササイズ", icon: "🏃‍♀️", unit: "分", subCategories: [
                        SubCategory(name: "未選択"),
                        SubCategory(name: "ランニング"),
                        SubCategory(name: "ウォーキング"),
                        SubCategory(name: "サイクリング"),
                        SubCategory(name: "ダンス"),
                        SubCategory(name: "アウトドア"),
                        SubCategory(name: "その他")]),
                    Category(name: "健康", icon: "💖", subCategories: [
                        SubCategory(name: "未選択"),
                        SubCategory(name: "身長", unit:"cm"),
                        SubCategory(name: "体重", unit:"kg"),
                        SubCategory(name: "BMI"),
                        SubCategory(name: "その他")]),
                    Category(name: "料理", icon: "🥕", subCategories: [
                        SubCategory(name: "未選択"),
                        SubCategory(name: "夕食"),
                        SubCategory(name: "ランチ"),
                        SubCategory(name: "朝食"),
                        SubCategory(name: "デザート"),
                        SubCategory(name: "その他")]),
                    Category(name: "その他", icon: "🗂", subCategories: [
                        SubCategory(name: "未選択"),
                        SubCategory(name: "その他")])
                ]
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
