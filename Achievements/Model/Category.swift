//
//  Category.swift
//  Achievements
//
//  Created by Yuki Takahashi on 30/01/2021.
//

import Foundation

struct Category: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var icon: String?
    var unit: String?
    var subCategories: [SubCategory]
    
    var wrappedIcon: String {
        icon ?? ""
    }
    var wrappedUnit: String {
        unit ?? ""
    }
}

struct SubCategory: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var icon: String?
    var unit: String?
    
    var wrappedIcon: String {
        icon ?? ""
    }
    var wrappedUnit: String {
        unit ?? ""
    }
}

class CategoryItem: ObservableObject {
    @Published var category: Category
    @Published var categoryIndex: Int?
    @Published var subCategory: SubCategory
    @Published var subCategoryIndex: Int?
    
    
    init(category: Category, categoryIndex: Int? = nil, subCategory: SubCategory = SubCategory(name: ""), subCategoryIndex: Int? = nil) {
        self.category = category
        self.categoryIndex = categoryIndex
        self.subCategory = subCategory
        self.subCategoryIndex = subCategoryIndex
    }
    
    
    init() {
        self.category = Category(name: "", subCategories: [SubCategory(name: "")])
//        self.categoryIndex = 0
        self.subCategory = SubCategory(name: "")
//        self.subCategoryIndex = 0
    }
    
    func setCategory(category: Category, index: Int? = nil)  -> CategoryItem {
        self.category = category
        self.categoryIndex = index
        return self
    }

    func setSubCategory(subCategory: SubCategory, index: Int? = nil) -> CategoryItem {
        self.subCategory = subCategory
        self.subCategoryIndex = index
        return self
    }
}
