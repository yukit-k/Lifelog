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
    
    @State private var showingError = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""

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
                    TextField("", text: $categoryItem.subCategory.icon.bounds)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    TextFieldWrapperView(text: $categoryItem.subCategory.icon.bounds)
//                        .padding(6)
//                        .frame(width: 60)
//                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.secondary, lineWidth: 0.1))

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
                categoryItem.category.subCategories[categoryItem.subCategoryIndex!] = categoryItem.subCategory
            } else {
                categoryItem.category.subCategories.append(categoryItem.subCategory)
            }
            draftCategory.categories[categoryItem.categoryIndex!] = categoryItem.category
            modelData.userCategory = draftCategory
            modelData.userCategory.save()
            self.presentationMode.wrappedValue.dismiss()
        } else {
            self.showingError = true
            self.errorTitle = "Invalid Name"
            self.errorMessage = "Make sure to enter something for \nthe new item."
            return
        }
    }
}
