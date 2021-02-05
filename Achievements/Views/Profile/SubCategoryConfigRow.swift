//
//  SubCategoryConfigRow.swift
//  Achievements
//
//  Created by Yuki Takahashi on 03/02/2021.
//

import SwiftUI

struct SubCategoryConfigRow: View {
    @Environment(\.editMode) var editMode
    
    @ObservedObject var categoryItem: CategoryItem
    @ObservedObject var draftCategory: UserCategory
    
    @State private var showingSheet = false
    
    var body: some View {
        HStack {
//            if editMode?.wrappedValue == .active {
//                Text("Edit")
//                    .foregroundColor(.accentColor)
//                    .onTapGesture {
//                        self.showingSheet.toggle()
//                    }
//            }
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
        .sheet(isPresented: $showingSheet) {
            AddEditSubCategory(categoryItem: categoryItem, draftCategory: draftCategory)
        }
    }
}
