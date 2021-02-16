//
//  SubCategorySettingsEditor.swift
//  Achievements
//
//  Created by Yuki Takahashi on 14/02/2021.
//

import SwiftUI

struct SubCategorySettingsEditor: View {
    @EnvironmentObject var modelData: ModelData
    @ObservedObject var categoryItem: CategoryItem
    var subCategories: [SubCategory] {
        categoryItem.category.subCategories
    }

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
            ForEach(Array(subCategories.enumerated()), id: \.1.id) { i, subCategory in
                HStack {
                    TextField("", text: $categoryItem.category.subCategories[i].icon.bounds)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 40)
                    TextField("", text: $categoryItem.category.subCategories[i].name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                    TextField("", text: $categoryItem.category.subCategories[i].unit.bounds)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 80)
                }
            }
            .onDelete(perform: deleteSubCategory)
        }
    }
    
    func deleteSubCategory(at offsets: IndexSet) {
//        subCategories.remove(atOffsets: offsets)
//        categoryItem.category.subCategories = subCategories
        categoryItem.category.subCategories.remove(atOffsets: offsets)

    }
}
