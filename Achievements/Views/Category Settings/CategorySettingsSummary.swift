//
//  CategorySettingsSummary.swift
//  Achievements
//
//  Created by Yuki Takahashi on 14/02/2021.
//

import SwiftUI

struct CategorySettingsSummary: View {
    @ObservedObject var userCategory: UserCategory
    var body: some View {
        ForEach(Array(userCategory.categories.enumerated()), id: \.1.id) { i, category in
            NavigationLink(destination: SubCategorySettingsHost(categoryItem: CategoryItem(category: category, categoryIndex: i))) {
                HStack {
                    Text(category.icon ?? "")
                    Text(category.name)
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
    }
}
