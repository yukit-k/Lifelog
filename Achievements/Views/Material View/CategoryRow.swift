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
//    @FetchRequest(entity: Material.entity(), sortDescriptors: [
//        NSSortDescriptor(keyPath: \Material.updateDate, ascending: false)
//    ]) var materials: FetchedResults<Material>

    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(fetchRequest.wrappedValue, id: \.self) { material in
                        NavigationLink(destination: MaterialDetail(material: material)) {
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
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var landmarks = ModelData().landmarks
    
    static var previews: some View {
        CategoryRow(filter: "Book")
    }
}
