//
//  SubCategoryConfig.swift
//  Achievements
//
//  Created by Yuki Takahashi on 03/02/2021.
//

import SwiftUI

struct SubCategorySettingsHost: View {
    @State var isEditing = false
    @Environment(\.editMode) var editMode
    @EnvironmentObject var modelData: ModelData
    @ObservedObject var categoryItem: CategoryItem
//    @StateObject var draftCategory = UserCategory()
    @State private var showingSheet = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    if isEditing == false {
                        SubCategorySettingsSummary(categoryItem: categoryItem)
                    } else {
                        SubCategorySettingsEditor(categoryItem: categoryItem)
                            .onDisappear {
                                modelData.userCategory.categories[categoryItem.categoryIndex!] = categoryItem.category
                                modelData.userCategory.save()
                            }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Sub Category Settings")
                .navigationBarTitleDisplayMode(.inline)
                .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.isEditing.toggle()
                        }) {
                            Text(isEditing ? "Done" : "Edit")
                                .frame(width: 80, height: 40)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            self.showingSheet.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingSheet) {
                    AddSubCategory(categoryItem: categoryItem)
                        .onDisappear {
                            categoryItem.subCategory = SubCategory(name: "")
                        }
                }
            }
        }
    }
}
