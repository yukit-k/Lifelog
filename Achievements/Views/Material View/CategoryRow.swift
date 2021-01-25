//
//  CategoryRow.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import SwiftUI

struct CategoryRow: View {
//    var categoryName: String
//    @Environment(\.managedObjectContext) var moc
    var fetchRequest: FetchRequest<Material>
    var categoryName: String
    var categoryNameWithIcon: String
//    @FetchRequest(entity: Material.entity(), sortDescriptors: [
//        NSSortDescriptor(keyPath: \Material.updateDate, ascending: false)
//    ]) var materials: FetchedResults<Material>

    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryNameWithIcon)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 15)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(fetchRequest.wrappedValue, id: \.self) { material in
                        NavigationLink(destination: ItemDetail(material: material)) {
                            CategoryItem(material: material)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
    
    init(filter: String) {
        fetchRequest = FetchRequest<Material>(entity: Material.entity(), sortDescriptors: [ NSSortDescriptor(keyPath: \Material.updateDate, ascending: false)
        ], predicate: NSPredicate(format: "category == %@", filter))
        categoryName = filter
        switch filter {
        case Material.Category.Book.rawValue: categoryNameWithIcon = Material.CategoryIcon.Book.rawValue + filter
        case Material.Category.Task.rawValue: categoryNameWithIcon = Material.CategoryIcon.Task.rawValue + filter
        case Material.Category.Cook.rawValue: categoryNameWithIcon = Material.CategoryIcon.Cook.rawValue + filter
        case Material.Category.Exercise.rawValue: categoryNameWithIcon = Material.CategoryIcon.Exercise.rawValue + filter
        default: categoryNameWithIcon = Material.CategoryIcon.Others.rawValue + filter
        }
    }
}

struct CategoryRow_Previews: PreviewProvider {    
    static var previews: some View {
        CategoryRow(filter: "Book")
    }
}
