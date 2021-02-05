//
//  CategorySettings.swift
//  Achievements
//
//  Created by Yuki Takahashi on 02/02/2021.
//

import SwiftUI

struct CategorySettings: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var modelData: ModelData
    
    @StateObject var draftCategory: UserCategory = UserCategory()
    //@StateObject var categoryItem: CategoryItem = CategoryItem(category: Category(name: "", subCategories: []))
    @State private var showingSheet = false
//    @State private var flags: [Bool] = []
//
//    init() {
//        _flags = State(initialValue: Array(repeating: false, count: draftSettings.categories.count))
//    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    EditButton()
                        .padding(.horizontal, 20)
                    Spacer()
                    Button(action: {
                        self.showingSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .padding(.horizontal, 20)
                }
                .padding()
                List {
                    ForEach(Array(draftCategory.categories.enumerated()), id: \.1.id) { i, category -> CategoryConfigRow in
                        let categoryItem = CategoryItem(category: category, categoryIndex: i)
                        CategoryConfigRow(categoryItem: categoryItem, draftCategory: draftCategory)
//                            .onDisappear {
//                                modelData.userCategory = draftCategory
//                            }

        //                        DisclosureGroup(isExpanded: $flags[i]) {
        //                            ForEach(category.subCategories, id: \.self) { subCategory in
        //                                SubCategoryConfigRow(category: subCategory)
        //                                    .padding(.leading, 20)
        //                            }
        //                        } label: {
        //                            CategoryConfigRow(category: category)
        //                                .listRowBackground(Color("listHeader"))
        //                        }
        //                    }

                    }
                    .onDelete(perform: deleteCategory)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Category Settings")
                .navigationBarTitleDisplayMode(.inline)
//                .navigationBarHidden(true)
//                .toolbar {
    //                ToolbarItem(placement: .navigationBarTrailing) {
    //                    EditButton()
    //                }
//                    ToolbarItem(placement: .navigationBarLeading) {
//                        Button(action: {
//
//                        }) {
//                            Image(systemName: "plus")
//                        }
//                    }
//                }
            }

        }
        .onAppear {
            draftCategory.categories = modelData.userCategory.categories
        }
        .sheet(isPresented: $showingSheet) {
            AddEditCategory(categoryItem: CategoryItem(category: Category(name: "", subCategories: [])), draftCategory: draftCategory)
                .onDisappear {
                    modelData.userCategory = draftCategory
                    modelData.userCategory.save()
                }

        }
    }
    
    func deleteCategory(at offsets: IndexSet) {
        modelData.userCategory.categories.remove(atOffsets: offsets)
        draftCategory.categories = modelData.userCategory.categories
        modelData.userCategory.save()
    }
}

struct CategorySettings_Previews: PreviewProvider {
    static var previews: some View {
        CategorySettings()
            .environmentObject(ModelData())
    }
}
