////
////  CategoryConfigRow.swift
////  Achievements
////
////  Created by Yuki Takahashi on 03/02/2021.
////
//
//import SwiftUI
//
//struct CategoryConfigRow: View {
//    @ObservedObject var categoryItem: CategoryItem
//    var body: some View {
//        NavigationLink(destination: SubCategorySettingsHost(categoryItem: categoryItem)) {
//            HStack {
//                Text(categoryItem.category.icon ?? "")
//                Text(categoryItem.category.name)
//                Spacer()
//                if categoryItem.category.unit != nil {
//                    Text("(Unit: \(categoryItem.category.unit!))")
//                       .font(.caption)
//                       .foregroundColor(.secondary)
//                       .padding(.trailing)
//                }
//            }
//        }
//    }
//}
//
//struct CategoryConfigEditRow: View {
//    @ObservedObject var categoryItem: CategoryItem
//    var body: some View {
//        HStack {
//            TextField("", text: $categoryItem.category.icon.bounds)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .frame(width: 40)
//            TextField("", text: $categoryItem.category.name)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//            Spacer()
//            TextField("", text: $categoryItem.category.unit.bounds)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .frame(width: 100)
//        }
//    }
//}
