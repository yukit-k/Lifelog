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
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Category Name")
                        .frame(width: 150)

//                    CustomTextField(text: $categoryItem.category.name, isFirstResponder: true)

                    TextField("", text: $categoryItem.category.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }
                HStack {
                    Text("Icon (Emoji)")
                        .frame(width: 150)

                    TextField("", text: $categoryItem.category.icon.bounds)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                    TextFieldWrapperView(text: $categoryItem.category.icon.bounds)
//                        .padding(6)
//                        .frame(width: 60)
//                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.secondary, lineWidth: 0.1))
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
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    
    func save()  {
        if categoryItem.category.name != "" {
            if categoryItem.categoryIndex != nil {
                draftCategory.categories[categoryItem.categoryIndex!] = categoryItem.category
            } else {
                if draftCategory.categories.firstIndex(where: { $0.name == categoryItem.category.name }) != nil {
                    self.showingError = true
                    self.errorTitle = "Invalid Name"
                    self.errorMessage = "The same category already exists. Please change the name."
                    return
                } else {
                    draftCategory.categories.append(categoryItem.category)
                }
            }
            if categoryItem.category.icon == "" || categoryItem.category.icon == nil {
                self.showingError = true
                self.errorTitle = "Invalid Icon"
                self.errorMessage = "Please enter something for the icon. To be used in the add button."
                return
            }
            modelData.userCategory = draftCategory
            modelData.userCategory.save()
            self.presentationMode.wrappedValue.dismiss()
        } else {
            self.showingError = true
            self.errorTitle = "Invalid Name"
            self.errorMessage = "Please enter something for the name."
            return
        }

    }
}
