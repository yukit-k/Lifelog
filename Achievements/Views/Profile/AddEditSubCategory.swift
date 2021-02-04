//
//  AddEditSubCategory.swift
//  Achievements
//
//  Created by Yuki Takahashi on 03/02/2021.
//

import SwiftUI

struct AddEditSubCategory: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modelData: ModelData

    @ObservedObject var categoryItem: CategoryItem
    @ObservedObject var draftCategory: UserCategory
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Cateogry Name")
                        .frame(width: 150)

                    TextField("", text: $categoryItem.subCategory.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Icon (Optional)")
                        .frame(width: 150)
                    TextFieldWrapperView(text: $categoryItem.subCategory.icon.bounds)
                        .padding(6)
                        .frame(width: 60)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.secondary, lineWidth: 0.1))

                }
                HStack {
                    Text("Unit (Optional)")
                        .frame(width: 150)

                    TextField("", text: $categoryItem.subCategory.unit.bounds)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }

                
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
//                    SaveButton(function: { self.save() })
                    Button(action: {
                        self.save()
                    }) {
                        Text("Save")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
            .navigationBarTitle(categoryItem.subCategoryIndex != nil ? Text("Edit Sub Category") : Text("Add Sub Category"))
        }
        
    }
    
    func save()  {
        // do something
        if categoryItem.subCategory.name != "" {
            if categoryItem.subCategoryIndex != nil {
                draftCategory.categories[categoryItem.categoryIndex!].subCategories[categoryItem.subCategoryIndex!] = categoryItem.subCategory
            } else {
                draftCategory.categories[categoryItem.categoryIndex!].subCategories.append(categoryItem.subCategory)
            }
            modelData.userCategory = draftCategory
            modelData.userCategory.save()
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}
