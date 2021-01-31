//
//  Category.swift
//  Achievements
//
//  Created by Yuki Takahashi on 30/01/2021.
//

import Foundation

struct Category: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var icon: String?
    var unit: String?
    var subCategories: [Category]?
}
