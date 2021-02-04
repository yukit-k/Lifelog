//
//  AddEditCategory.swift
//  Achievements
//
//  Created by Yuki Takahashi on 03/02/2021.
//

import SwiftUI

struct AddEditCategory: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modelData: ModelData
    
    @ObservedObject var categoryItem: CategoryItem
    @ObservedObject var draftCategory: UserCategory
    
    @State private var showingError = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
    @State private var showingOverrideAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Cateogry Name")
                        .frame(width: 150)

                    TextField("", text: $categoryItem.category.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Icon (Optional)")
                        .frame(width: 150)

                    TextFieldWrapperView(text: $categoryItem.category.icon.bounds)
                        .padding(6)
                        .frame(width: 60)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.secondary, lineWidth: 0.1))
                        //.textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Unit (Optional)")
                        .frame(width: 150)

                    TextField("", text: $categoryItem.category.unit.bounds)
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
            .navigationBarTitle(categoryItem.categoryIndex != nil ? Text("Edit Category") : Text("Add Category"))
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        
    }
    
    
    func save()  {
        if categoryItem.category.name != "" {
            if categoryItem.categoryIndex != nil {
                draftCategory.categories[categoryItem.categoryIndex!] = categoryItem.category
            } else {
                if draftCategory.categories.firstIndex(where: { $0.name == categoryItem.category.name }) != nil {
                    self.showingError = true
                    self.errorTitle = "Invalid Name"
                    self.errorMessage = "The same category already exists"
                    return
                } else {
                    draftCategory.categories.append(categoryItem.category)
                }
            }
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
