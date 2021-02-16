//
//  AddEditCategory.swift
//  Achievements
//
//  Created by Yuki Takahashi on 03/02/2021.
//

import SwiftUI

struct AddCategory: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var modelData: ModelData
    
    @State var category: Category = Category(name: "", subCategories: [])
    
    @State private var showingError = false
    @State private var errorTitle: String = ""
    @State private var errorMessage: String = ""
        
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Icon")
                        .frame(width: 100)
                    EmojiTextFieldWrapperView(text: $category.icon.bounds)
                        .padding(6)
                        .frame(width: 60)
                        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.secondary, lineWidth: 0.1))
                }
                HStack {
                    Text("Name")
                        .frame(width: 100)
                    TextField("", text: $category.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text("Unit")
                        .frame(width: 100)

                    TextField("(optional)", text: $category.unit.bounds)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
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
            .navigationBarTitle(Text("Add New Category"))
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    
    func save()  {
        if category.name == "" {
            self.showingError = true
            self.errorTitle = "Invalid Name"
            self.errorMessage = "Please enter something for the name."
            return
        } else if category.icon == "" || category.icon == nil {
            self.showingError = true
            self.errorTitle = "Invalid Icon"
            self.errorMessage = "Please enter something for the icon. To be used in the add button."
            return
        } else if modelData.userCategory.categories.firstIndex(where: { $0.name == category.name }) != nil {
            self.showingError = true
            self.errorTitle = "Invalid Name"
            self.errorMessage = "The same category already exists. Please change the name."
            return
        } else {
            modelData.userCategory.categories.append(category)
            modelData.userCategory.save()
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}
