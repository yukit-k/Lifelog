//
//  CategoryFilterRow.swift
//  Achievements
//
//  Created by Yuki Takahashi on 15/02/2021.
//

import SwiftUI


struct CategoryFilterRow: View {
    @EnvironmentObject var categoryFilter: CategoryFilter
    var category: Category

    var body: some View {
        HStack {
            if (categoryFilter.category.name == category.name && categoryFilter.subCategory.name == "") {
                Image(systemName: "checkmark")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .font(.headline)
            }
            Text(category.icon ?? "")
            Text(category.name)
                .foregroundColor(categoryFilter.category.name == category.name ? .blue : .primary)
            Spacer()
            if category.unit != nil {
                Text("(Unit: \(category.unit!))")
                   .font(.caption)
                   .foregroundColor(.secondary)
                   .padding(.trailing)
            }
        }
    }
}
