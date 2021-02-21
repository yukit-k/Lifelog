//
//  CategorySettingsEditor.swift
//  Achievements
//
//  Created by Yuki Takahashi on 14/02/2021.
//

import SwiftUI

struct CategorySettingsEditor: View {
    @EnvironmentObject var modelData: ModelData
    @ObservedObject var draftCategory: UserCategory
    
    var body: some View {
        Section(header: Text("Category")) {
            ForEach(draftCategory.categories.indices, id: \.self) { index in
                HStack {
                    EmojiTextFieldWrapperView(text: $draftCategory.categories[index].icon.bounds)
                        .padding(6)
                        .frame(width: 60)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.secondary, lineWidth: 0.1))
//                    TextField("", text: $draftCategory.categories[index].icon.bounds)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .frame(width: 40)
                    TextField("", text: $draftCategory.categories[index].name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Spacer()
                    TextField("", text: $draftCategory.categories[index].unit.bounds)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 60)
                }
            }
            .onDelete(perform: deleteCategory)
        }
    }
    
    func deleteCategory(at offsets: IndexSet) {
        draftCategory.categories.remove(atOffsets: offsets)
    }
}
