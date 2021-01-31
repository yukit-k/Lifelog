//
//  ProfileEditor.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 04/01/2021.
//

import SwiftUI

struct SettingEditor: View {
    @Binding var userSettings: UserSettings
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.title)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            Form {
                Section(header: Text("Profile")){
                    HStack {
                        Text("Username")
                            .font(.headline)
                            .frame(width: 100)
                        Divider()
                        TextField("Your Name", text: $userSettings.username)
                    }
                    HStack {
                        Toggle(isOn: $userSettings.notification) {
                            Text("Notification")
                                .font(.headline)
                                .frame(width: 100)
                        }
                    }

                }
                Section(header: Text("Category")){
                    List {
                        ForEach(userSettings.categories, id: \.self) { category in
                            CategoryConfigRow(category: category)
                                .listRowBackground(Color("listHeader"))
                                ForEach(category.subCategories ?? []) { subCategory in
                                    CategoryConfigRow(category: subCategory)
                                        .padding(.leading, 20)
                                }
                            Button(action: {
                                self.addRow()
                            }) {
                                Image(systemName: "plus")
                                    .padding(.leading, 30)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
    private func addRow() {
        //category.subCategories.append(Category(name: "New"))
    }
    
    func delete(at offsets: IndexSet) {
        userSettings.categories.remove(atOffsets: offsets)
    }
    func move(from source: IndexSet, to destination: Int) {
        userSettings.categories.move(fromOffsets: source, toOffset: destination)
    }
}

struct SettingEditor_Previews: PreviewProvider {
    static var previews: some View {
        SettingEditor(userSettings: .constant(UserSettings()))
    }
}
