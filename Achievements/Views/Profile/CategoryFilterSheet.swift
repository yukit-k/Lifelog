//
//  CategoryFilterSheet.swift
//  Achievements
//
//  Created by Yuki Takahashi on 07/02/2021.
//

import SwiftUI

struct CategoryFilterSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var isFiltered: Bool
    @ObservedObject var filterCategory: CategoryItem
    var userCategory: UserCategory
    
    var body: some View {
        VStack {
            List {
                ForEach(Array(userCategory.categories.enumerated()), id: \.1.id) { i, category in
                    DisclosureGroup {
                        ForEach(category.subCategories, id: \.self) { subCategory in
                            SubCategoryFilterRow(categoryItem: CategoryItem(category: category, subCategory: subCategory))
                                .padding(.leading, 20)
                                .onTapGesture {
                                    filterCategory.category = category
                                    filterCategory.categoryIndex = i
                                    filterCategory.subCategory = subCategory
                                    isFiltered = true
                                    presentationMode.wrappedValue.dismiss()
                                }
                        }
                    } label: {
                        CategoryFilterRow(categoryItem: CategoryItem(category: category), filterCategory: filterCategory)
                            .listRowBackground(Color("listHeader"))
                            .onTapGesture {
                                filterCategory.category = category
                                filterCategory.categoryIndex = i
                                isFiltered = true
                                presentationMode.wrappedValue.dismiss()
                            }
                    }
                }
                if isFiltered {
                    Text("Clear Filter")
                        .foregroundColor(.blue)
                        .onTapGesture {
                            filterCategory.category = Category(name: "", subCategories: [])
                            filterCategory.subCategory = SubCategory(name: "")
                            isFiltered = false
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

struct CategoryFilterRow: View {
    @ObservedObject var categoryItem: CategoryItem
    @ObservedObject var filterCategory: CategoryItem
    
    var body: some View {
        HStack {
            if filterCategory.category.name == categoryItem.category.name {
                Image(systemName: "checkmark")
                    .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    .font(.headline)
            }
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
    }
}

struct SubCategoryFilterRow: View {
    @ObservedObject var categoryItem: CategoryItem
    
    var body: some View {
        HStack {
            Text(categoryItem.subCategory.icon ?? "")
            Text(categoryItem.subCategory.name)
            Spacer()
            if categoryItem.subCategory.unit != nil {
                Text("(Unit: \(categoryItem.subCategory.unit!))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.trailing)
            }
        }
    }
}
