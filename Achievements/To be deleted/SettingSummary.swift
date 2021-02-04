////
////  SettingSummary.swift
////  Achievements
////
////  Created by Yuki Takahashi on 28/01/2021.
////
//
//import SwiftUI
//
//struct SubCategoryConfigRow: View {
//    var category: SubCategory
//    var body: some View {
//        HStack {
//            Text(category.icon ?? "")
//            Text(category.name)
//            Spacer()
//            if category.unit != nil {
//                Text("(Unit: \(category.unit!))")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                    .padding(.trailing)
//            }
//        }
//    }
//}
//
//struct SettingSummary: View {
//    @ObservedObject var userSettings: UserSettings
//    @State private var flags: [Bool] = []
//
//    init(userSettings: UserSettings) {
//        _flags = State(initialValue: Array(repeating: false, count: userSettings.categories.count))
//        self.userSettings = userSettings
//    }
//
//    var body: some View {
//        VStack {
//            Text("Settings")
//                .font(.title)
//                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
//            List {
//                Section(header: Text("Profile")){
//                    HStack {
//                        Text("Username")
//                            .font(.headline)
//                            .frame(width: 100)
//                        Divider()
//                        Text(userSettings.username)
//                            .padding(4)
//                    }
//                    HStack {
//                        Text("Notification")
//                            .font(.headline)
//                            .frame(width: 100)
//                        Divider()
//                        Text(userSettings.notification ? "On (coming soon)" : "Off (coming soon)")
//                            .padding(4)
//                    }
//
//                }
//                Section(header: Text("Category")){
//                    ForEach(Array(userSettings.categories.enumerated()), id: \.1.id) { i, category in
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
//                    .onDelete(perform: deleteCategory)
//                }
//
//            }
//            .listStyle(InsetGroupedListStyle())
//        }
//    }
//    func deleteCategory(at offsets: IndexSet) {
//        self.userSettings.categories.remove(atOffsets: offsets)
//    }
//}
//
//struct SettingSummary_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingSummary(userSettings: UserSettings())
//    }
//}
