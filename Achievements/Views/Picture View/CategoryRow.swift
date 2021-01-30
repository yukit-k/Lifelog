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
    var fetchRequest: FetchRequest<Log>
    var categoryName: String
    var categoryIcon: String
//    @FetchRequest(entity: Material.entity(), sortDescriptors: [
//        NSSortDescriptor(keyPath: \Material.updateDate, ascending: false)
//    ]) var materials: FetchedResults<Material>

    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryIcon + categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 15)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(fetchRequest.wrappedValue, id: \.self) { log in
                        NavigationLink(destination: ActivityDetail(log: log)) {
                            CategoryItem(log: log)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
    
    init(filter: String) {
        fetchRequest = FetchRequest<Log>(entity: Log.entity(), sortDescriptors: [ NSSortDescriptor(keyPath: \Log.updatedDate, ascending: false)
        ], predicate: NSPredicate(format: "category == %@", filter))
        categoryName = filter
        categoryIcon = Log.getCategoryIcon(categoryName)
    }
}

struct CategoryRow_Previews: PreviewProvider {    
    static var previews: some View {
        CategoryRow(filter: "Book")
    }
}
