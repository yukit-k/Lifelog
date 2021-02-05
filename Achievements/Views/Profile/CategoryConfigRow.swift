//
//  CategoryConfigRow.swift
//  Achievements
//
//  Created by Yuki Takahashi on 03/02/2021.
//

import SwiftUI

struct CategoryConfigRow: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var modelData: ModelData
    
    @ObservedObject var categoryItem: CategoryItem
    @ObservedObject var draftCategory: UserCategory
    
    @State private var showingSheet = false
    
    var body: some View {
        NavigationLink(destination: SubCategoryConfig(categoryItem: categoryItem, draftCategory: draftCategory)) {
            HStack {
//                if editMode?.wrappedValue == .active {
//                    Text("Edit")
//                        .foregroundColor(.accentColor)
//                        .onTapGesture {
//                            self.showingSheet.toggle()
//                        }
//                }
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
            .sheet(isPresented: $showingSheet) {
                AddEditCategory(categoryItem: categoryItem, draftCategory: draftCategory)
            }

        }
    }
}
