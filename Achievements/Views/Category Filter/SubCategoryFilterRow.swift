//
//  SubCategoryFilterRow.swift
//  Achievements
//
//  Created by Yuki Takahashi on 15/02/2021.
//

import SwiftUI

struct SubCategoryFilterRow: View {
    @EnvironmentObject var categoryFilter: CategoryFilter
    var subCategory: SubCategory
    
    var body: some View {
        HStack {
            if (categoryFilter.subCategory.name == subCategory.name) {
                Image(systemName: "checkmark")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .font(.headline)
            }
            Text(subCategory.icon ?? "")
            Text(subCategory.name)
                .foregroundColor(categoryFilter.subCategory.name == subCategory.name ? .blue : .primary)
            Spacer()
            if subCategory.unit != nil {
                Text("(Unit: \(subCategory.unit!))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.trailing)
            }
        }
    }
}
