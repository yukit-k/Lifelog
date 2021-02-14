////
////  SubCategoryConfigRow.swift
////  Achievements
////
////  Created by Yuki Takahashi on 03/02/2021.
////
//
//import SwiftUI
//
//struct SubCategoryConfigRow: View {
//    @ObservedObject var categoryItem: CategoryItem
//    var body: some View {
//        HStack {
//            Text(categoryItem.subCategory.icon ?? "")
//            Text(categoryItem.subCategory.name)
//            Spacer()
//            if categoryItem.subCategory.unit != nil {
//                Text("(Unit: \(categoryItem.subCategory.unit!))")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                    .padding(.trailing)
//            }
//        }
//    }
//}
//
//struct SubCategoryConfigEditRow: View {
//    @ObservedObject var categoryItem: CategoryItem
//    var body: some View {
//        HStack {
//            Text(categoryItem.subCategory.icon ?? "")
//            Text(categoryItem.subCategory.name)
//            Spacer()
//            if categoryItem.subCategory.unit != nil {
//                Text("(Unit: \(categoryItem.subCategory.unit!))")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                    .padding(.trailing)
//            }
//        }
//    }
//}
