//
//  SubCategoryConfig.swift
//  Achievements
//
//  Created by Yuki Takahashi on 03/02/2021.
//

import SwiftUI

struct SubCategoryConfig: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var modelData: ModelData
    
    @ObservedObject var categoryItem: CategoryItem
    @ObservedObject var draftCategory: UserCategory
    
    @State private var showingSheet = false

    var body: some View {
            VStack {
                HStack {
                    EditButton()
                        .padding(.horizontal, 20)
                    Spacer()
                    Button(action: {
                        self.showingSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding(.horizontal, 20)
                }
                .padding()

                List {
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
                    }
                    Section(header: Text("Sub Cateogyry")) {
                        ForEach(Array(categoryItem.category.subCategories.enumerated()), id: \.1.id) { i, subCategory in
                            SubCategoryConfigRow(categoryItem: CategoryItem(category: categoryItem.category, categoryIndex: categoryItem.categoryIndex, subCategory: subCategory, subCategoryIndex: i), draftCategory: draftCategory)
        //                        SubCategoryConfigRow(userSettings: draftSettings, categoryName: category.name)
                        }
                        .onDelete(perform: deleteSubCategory)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Sub Category Settings")

            }
            .onAppear {

            }
            .sheet(isPresented: $showingSheet) {
                AddEditSubCategory(categoryItem: categoryItem, draftCategory: draftCategory)
                    .onDisappear {
                        // Do something
                    }

            }
        
    }    
    
    func deleteSubCategory(at offsets: IndexSet) {
        categoryItem.category.subCategories.remove(atOffsets: offsets)
        draftCategory.categories[categoryItem.categoryIndex!] = categoryItem.category
        modelData.userCategory = draftCategory
    }
}
