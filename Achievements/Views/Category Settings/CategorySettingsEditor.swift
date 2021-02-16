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
        Section(header: Text("Cateogyry")) {
            ForEach(draftCategory.categories.indices, id: \.self) { index in
                HStack {
                    TextField("", text: $draftCategory.categories[index].icon.bounds)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 40)
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
