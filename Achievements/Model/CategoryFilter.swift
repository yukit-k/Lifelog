//
//  CategoryFilter.swift
//  Achievements
//
//  Created by Yuki Takahashi on 15/02/2021.
//

import SwiftUI

class CategoryFilter: ObservableObject {
    @Published var isFiltered: Bool
    @Published var category: Category
    @Published var subCategory: SubCategory
    
    init(isFiltered: Bool = false, category: Category = Category(name: "", subCategories: []), subCategory: SubCategory = SubCategory(name: "")) {
        self.isFiltered = isFiltered
        self.category = category
        self.subCategory = subCategory
    }
    
    func clear() {
        self.isFiltered = false
        self.category = Category(name: "", subCategories: [])
        self.subCategory = SubCategory(name: "")
    }
    
    func filterLogs(_ logs: FetchedResults<Log>) -> [Log] {
        logs.filter { log in
            ((self.isFiltered == false) ||
                (self.isFiltered == true &&
                    ((self.subCategory.name == "" && log.wrappedCategory == self.category.name) ||
                        (self.subCategory.name == log.wrappedSubCategory && log.wrappedCategory == self.category.name)
                     )
                 )
            )
        }
    }

}

