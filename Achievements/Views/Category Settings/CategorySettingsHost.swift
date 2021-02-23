//
//  CategorySettings.swift
//  Achievements
//
//  Created by Yuki Takahashi on 02/02/2021.
//

import SwiftUI

struct CategorySettingsHost: View {
    @State var isEditing = false
    @Environment(\.editMode) var editMode
    @EnvironmentObject var modelData: ModelData
    @StateObject var draftCategory = UserCategory()
    @State private var showingSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if isEditing == false {
                        CategorySettingsSummary(userCategory: modelData.userCategory)
                    } else {
                        CategorySettingsEditor(draftCategory: draftCategory)
                            .onDisappear {
                                modelData.userCategory = draftCategory
                                modelData.userCategory.save()
                            }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Category Settings")
                .navigationBarTitleDisplayMode(.inline)
                .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.isEditing.toggle()
                        }) {
                            Text(isEditing ? "Done" : "Edit")
                                .frame(width: 80, height: 40)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            self.showingSheet.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showingSheet) {
                    AddCategory()
                }
            }
            .onAppear {
                draftCategory.categories = modelData.userCategory.categories
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CategorySettingsHost_Previews: PreviewProvider {
    static var previews: some View {
        CategorySettingsHost()
            .environmentObject(ModelData())
    }
}
