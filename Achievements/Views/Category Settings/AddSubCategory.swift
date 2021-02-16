//
//  AddEditSubCategory.swift
//  Achievements
//
//  Created by Yuki Takahashi on 03/02/2021.
//

import SwiftUI

struct AddSubCategory: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modelData: ModelData

    @ObservedObject var categoryItem: CategoryItem
    //@ObservedObject var draftCategory: UserCategory
    
    @State private var showingError = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""

    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Icon")
                        .frame(width: 100)
                    EmojiTextFieldWrapperView(text: $categoryItem.subCategory.icon.bounds)
                        .padding(6)
                        .frame(width: 60)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.secondary, lineWidth: 0.1))
                }
                HStack {
                    Text("Name")
                        .frame(width: 100)

                    TextField("", text: $categoryItem.subCategory.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Unit")
                        .frame(width: 100)
                    TextField("(optional)", text: $categoryItem.subCategory.unit.bounds)
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
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    func save()  {
        // do something
        if categoryItem.subCategory.name == "" {
            self.showingError = true
            self.errorTitle = "Invalid Name"
            self.errorMessage = "Make sure to enter something for \nthe new item."
            return
        } else {
            categoryItem.category.subCategories.append(categoryItem.subCategory)
            modelData.userCategory.categories[categoryItem.categoryIndex!] = categoryItem.category
            modelData.userCategory.save()
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}
