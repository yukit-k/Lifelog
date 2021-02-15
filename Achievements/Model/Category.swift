//
//  Category.swift
//  Achievements
//
//  Created by Yuki Takahashi on 30/01/2021.
//

import SwiftUI

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
