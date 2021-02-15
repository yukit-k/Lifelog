//
//  CategoryFilterSheet.swift
//  Achievements
//
//  Created by Yuki Takahashi on 07/02/2021.
//

import SwiftUI

struct CategoryFilterSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var categoryFilter: CategoryFilter
    @EnvironmentObject var modelData: ModelData
        
    var body: some View {
        VStack {
            List {
                ForEach(Array(modelData.userCategory.categories.enumerated()), id: \.1.id) { i, category in
                    DisclosureGroup {
                        ForEach(category.subCategories, id: \.self) { subCategory in
                            SubCategoryFilterRow(subCategory: subCategory)
                                .padding(.leading, 20)
                                .onTapGesture {
                                    categoryFilter.category = category
                                    categoryFilter.subCategory = subCategory
                                    categoryFilter.isFiltered = true
                                    presentationMode.wrappedValue.dismiss()
                                }
                        }
                    } label: {
                        CategoryFilterRow(category: category)
                            .listRowBackground(Color("listHeader"))
                            .onTapGesture {
                                categoryFilter.category = category
                                categoryFilter.subCategory = SubCategory(name: "")
                                categoryFilter.isFiltered = true
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
                if categoryFilter.isFiltered {
                    Text("Clear Filter")
                        .foregroundColor(.blue)
                        .padding(.leading, 10)
                        .onTapGesture {
                            categoryFilter.clear()
                            presentationMode.wrappedValue.dismiss()
                        }

                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Category Filter")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
