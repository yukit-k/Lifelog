//
//  SubCategorySettingsSummary.swift
//  Achievements
//
//  Created by Yuki Takahashi on 14/02/2021.
//

import SwiftUI

struct SubCategorySettingsSummary: View {
    @EnvironmentObject var modelData: ModelData
    @ObservedObject var categoryItem: CategoryItem
    var body: some View {
        Section(header: Text("Cateogyry")) {
            HStack {
                Text(categoryItem.category.icon ?? "")
                Text(categoryItem.category.name)
                Spacer()
                if categoryItem.category.unit != nil {
                    Text("(Unit: \(categoryItem.category.unit!))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.trailing)
                }
            }
            .foregroundColor(.secondary)
        }
        Section(header: Text("Sub Cateogyry")) {
            ForEach(categoryItem.category.subCategories, id: \.self) { subCategory in
                HStack {
                    Text(subCategory.icon ?? "")
                    Text(subCategory.name)
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
    }
}
