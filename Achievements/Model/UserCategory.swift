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
                        SubCategory(name: "-"),
                        SubCategory(name: "絵本", icon: "🦊"),
                        SubCategory(name: "フィクション", icon: "👻"),
                        SubCategory(name: "ノンフィクション", icon: "👩‍🎓"),
                        SubCategory(name: "テキスト", icon: "📑"),
                        SubCategory(name: "その他", icon: "🔖")]),
                    Category(name: "タスク", icon: "🧾", unit: "分", subCategories: [
                        SubCategory(name: "-"),
                        SubCategory(name: "勉強", icon: "🏫"),
                        SubCategory(name: "家事", icon: "🧹"),
                        SubCategory(name: "趣味", icon: "😃"),
                        SubCategory(name: "仕事", icon: "💼"),
                        SubCategory(name: "その他", icon: "🔖")]),
                    Category(name: "エクササイズ", icon: "🏃‍♀️", unit: "分", subCategories: [
                        SubCategory(name: "-"),
                        SubCategory(name: "ランニング", icon: "🏃‍♀️"),
                        SubCategory(name: "ウォーキング", icon: "🚶‍♀️"),
                        SubCategory(name: "サイクリング", icon: "🚲"),
                        SubCategory(name: "ダンス", icon: "💃"),
                        SubCategory(name: "アウトドア", icon: "⚽️"),
                        SubCategory(name: "その他", icon: "🔖")]),
                    Category(name: "健康", icon: "💖", subCategories: [
                        SubCategory(name: "-"),
                        SubCategory(name: "身長", icon: "↑", unit:"cm"),
                        SubCategory(name: "体重", icon: "→", unit:"kg"),
                        SubCategory(name: "BMI", icon: "⚖️"),
                        SubCategory(name: "その他", icon: "🔖")]),
                    Category(name: "料理", icon: "🥕", subCategories: [
                        SubCategory(name: "-"),
                        SubCategory(name: "夕食", icon: "🍱"),
                        SubCategory(name: "ランチ", icon: "🥪"),
                        SubCategory(name: "朝食", icon: "🍳"),
                        SubCategory(name: "デザート", icon: "🍰"),
                        SubCategory(name: "その他", icon: "🔖")]),
                    Category(name: "その他", icon: "🗂", subCategories: [
                        SubCategory(name: "-"),
                        SubCategory(name: "その他", icon: "🔖")])
                ]
            } else {
                self.categories = [
                    Category(name: "Book", icon: "📚", unit: "page", subCategories: [
                        SubCategory(name: "-"),
                        SubCategory(name: "Picture Book", icon: "🦊"),
                        SubCategory(name: "Fiction", icon: "👻"),
                        SubCategory(name: "Non-Fiction", icon: "👩‍🎓"),
                        SubCategory(name: "Textbook", icon: "📑"),
                        SubCategory(name: "Others", icon: "🔖")]),
                    Category(name: "Task", icon: "🧾", unit: "minutes", subCategories: [
                        SubCategory(name: "-"),
                        SubCategory(name: "Study", icon: "🏫"),
                        SubCategory(name: "Choir", icon: "🧹"),
                        SubCategory(name: "Hobby", icon: "😃"),
                        SubCategory(name: "Job", icon: "💼"),
                        SubCategory(name: "Others", icon: "🔖")]),
                    Category(name: "Exercise", icon: "🏃‍♀️", unit: "minutes", subCategories: [
                        SubCategory(name: "-"),
                        SubCategory(name: "Running", icon: "🏃‍♀️"),
                        SubCategory(name: "Walking", icon: "🚶‍♀️"),
                        SubCategory(name: "Cycling", icon: "🚲"),
                        SubCategory(name: "Indoor", icon: "💃"),
                        SubCategory(name: "Outdoor", icon: "⚽️"),
                        SubCategory(name: "Others", icon: "🔖")]),
                    Category(name: "Health", icon: "💖", subCategories: [
                        SubCategory(name: "-"),
                        SubCategory(name: "Height", icon: "↑", unit:"cm"),
                        SubCategory(name: "Weight", icon: "→", unit:"kg"),
                        SubCategory(name: "BMI", icon: "⚖️"),
                        SubCategory(name: "Others", icon: "🔖")]),
                    Category(name: "Cook", icon: "🥕", subCategories: [
                        SubCategory(name: "-"),
                        SubCategory(name: "Dinner", icon: "🍱"),
                        SubCategory(name: "Lunch", icon: "🥪"),
                        SubCategory(name: "Breakfast", icon: "🍳"),
                        SubCategory(name: "Desert", icon: "🍰"),
                        SubCategory(name: "Others", icon: "🔖")]),
                    Category(name: "Others", icon: "🗂", subCategories: [
                        SubCategory(name: "-"),
                        SubCategory(name: "Others", icon: "🔖")])
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
