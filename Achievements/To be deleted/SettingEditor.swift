////
////  ProfileEditor.swift
////  Landmarks
////
////  Created by Yuki Takahashi on 04/01/2021.
////
//
//import SwiftUI
//
//struct CategoryConfigEditRow: View {
//    @Binding var category: Category
//
//    var body: some View {
//        NavigationLink(destination: SubCategoryConfigEditView(category: $category)) {
//            HStack {
//                Text(category.icon ?? "")
//                Text(category.name)
//                Spacer()
//                if category.unit != nil {
//                    Text("(Unit: \(category.unit!))")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                        .padding(.trailing)
//                }
//            }
//        }
//    }
//}
//
//struct SubCategoryConfigEditView: View {
//    @Binding var category: Category
//
//    var body: some View {
//        List {
//            Section(header: Text("Category")) {
//                HStack {
//                    Text(category.icon ?? "")
//                        .frame(width: 40)
//                    Text(category.name)
//                        .padding(.leading, 5)
//                    Spacer()
//                    Text(category.unit ?? "")
//                        .frame(width: 100)
//                        .padding(.trailing, 25)
//                }
//            }
//            Section(header: Text("Sub Category")) {
//                ForEach(category.subCategories.indices, id: \.self) { index in
//                    SubCategoryConfigEditRow(subCategory: $category.subCategories[index])
//                }
//                .onDelete(perform: self.delete)
//                .onMove(perform: self.move)
//                Button(action: {
//                    self.add()
//                }) {
//                    HStack {
//                        Image(systemName: "plus")
//                            .padding(.leading, 20)
//                        Text("Add Category")
//                    }
//                }
//            }
//        }
//        .listStyle(InsetGroupedListStyle())
//    }
//    func delete(at offsets: IndexSet) {
//        category.subCategories.remove(atOffsets: offsets)
//    }
//    func move(from source: IndexSet, to destination: Int) {
//        category.subCategories.move(fromOffsets: source, toOffset: destination)
//    }
//    private func add() {
//        category.subCategories.append(SubCategory(name: "New Sub Category"))
//    }
//
//
//}
//
//struct SubCategoryConfigEditRow: View {
//    @Binding var subCategory: SubCategory
//
//    var body: some View {
//        HStack {
//            TextField("", text: $subCategory.icon.bounds)
//                .frame(width: 40)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//            TextField("Category", text: $subCategory.name)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//            TextField("unit", text: $subCategory.unit.bounds)
//                .frame(width: 100)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//        }
//    }
//}
//
//extension Binding where
//    Value: MutableCollection,
//    Value: RangeReplaceableCollection
//{
//    subscript(
//        _ index: Value.Index,
//        default defaultValue: Value.Element
//    ) -> Binding<Value.Element> {
//        Binding<Value.Element> {
//            guard index < self.wrappedValue.endIndex else {
//                return defaultValue
//            }
//            return self.wrappedValue[index]
//        } set: { newValue in
//
//            // It is possible that the index we are updating
//            // is beyond the end of our array so we first
//            // need to append items to the array to ensure
//            // we are within range.
//            while index >= self.wrappedValue.endIndex {
//                self.wrappedValue.append(defaultValue)
//            }
//
//            self.wrappedValue[index] = newValue
//        }
//    }
//}
//
//struct SettingEditor: View {
//    @ObservedObject var userSettings: UserSettings
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Text("Settings")
//                    .font(.title)
//                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//                List {
//                    Section(header: Text("Profile")){
//                        HStack {
//                            Text("Username")
//                                .font(.headline)
//                                .frame(width: 100)
//                            Divider()
//                            TextField("Your Name", text: $userSettings.username)
//                        }
//                        HStack {
//                            Toggle(isOn: $userSettings.notification) {
//                                Text("Notification (coming soon)")
//                                    .font(.headline)
//                            }
//                        }
//                    }
//                    Section(header: Text("Category")){
//
////                        VStack(alignment: .leading) {
////                            HStack {
////                                Text("Icon")
////                                    .font(.subheadline)
////                                    .foregroundColor(.secondary)
////                                    .frame(width: 40)
////                                Text("Category Name")
////                                    .padding(.leading, 5)
////                                    .font(.subheadline)
////                                    .foregroundColor(.secondary)
////                                Spacer()
////                                Text("Unit")
////                                    .padding(.trailing, 85)
////                                    .font(.subheadline)
////                                    .foregroundColor(.secondary)
////                            }
//                        ForEach(userSettings.categories.indices, id: \.self) { index in
//                            Text(userSettings.categories[index].name)
//                            //CategoryConfigEditRow(category: $userSettings.categories[userSettings.categories.firstIndex(where: {category == $0})!])
////                                    .listRowBackground(Color("listHeader"))
//                            }
//                            .onDelete(perform: delete)
//                            .onMove(perform: move)
////                        }
//                        Button(action: {
//                            self.add()
//                        }) {
//                            HStack {
//                                Image(systemName: "plus")
//                                    .padding(.leading, 20)
//                                Text("Add Category")
//                            }
//                        }
//                    }
//    //                Section(header: Text("Sub Category")) {
//    //                    ForEach(Array(userSettings.subCategories.sorted {$0.categoryId < $1.categoryId}.enumerated()), id: \.1.id) { index, item in
//    //                        if (index == 0) || (userSettings.subCategories[index].categoryId ==  userSettings.subCategories[index-1].categoryName) {
//    //                            Text(item.name)
//    //                        }
//    //                        SubCategoryConfigEditRow(subCategory: $userSettings.subCategories[index])
//    //                                //SubCategoryConfigEditRow(category: $userSettings.subCategories[i])
//    //                                    .padding(.leading, 20)
//    //                    }
//    //                    ForEach(Array(userSettings.categoryItems.enumerated()), id: \.1.id) { i, category in
//    //                        Section(header: Text(category.name), footer: Text("footer")) {
//    //                            ForEach(Array(category.subCategories.enumerated()) ?? [], id: \.1.id) { j, subCategory in
//    //                                SubCategoryConfigEditRow(category: $userSettings.categoryItems[i].subCategories[j])
//    //                                    .padding(.leading, 20)
//    //                            }
//    //                        }
//    //                    }
//    //                }
//
//                }
//                .listStyle(InsetGroupedListStyle())
//                .navigationTitle("Settings")
//                .navigationBarHidden(true)
//            }
////            .navigationBarItems(trailing: EditButton())
//        }
//    }
//    private func addCategory() {
//        //category.subCategories.append(Category(name: "New"))
//    }
//    private func add() {
//        self.userSettings.categories.append(Category(name: "New Category", subCategories: [SubCategory(name: "Not Selected")]))
//    }
//
//    func delete(at offsets: IndexSet) {
//        self.userSettings.categories.remove(atOffsets: offsets)
//    }
//    func move(from source: IndexSet, to destination: Int) {
//        self.userSettings.categories.move(fromOffsets: source, toOffset: destination)
//    }
//}
//
//struct SettingEditor_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingEditor(userSettings: UserSettings())
//    }
//}
