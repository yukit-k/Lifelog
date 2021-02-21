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
                            CategoryItemView(log: log)
                        }
                    }
                }
            }
            .frame(height: 190)
        }
    }
    
    init(categoryName: String, categoryIcon: String) {
        fetchRequest = FetchRequest<Log>(
            entity: Log.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Log.updatedDate, ascending: false)
            ],
            predicate: NSCompoundPredicate(type: .and, subpredicates: [
                                            NSPredicate(format: "category == %@", categoryName),
                                            NSPredicate(format: "isToDo == false")
            ])
        )
        self.categoryName = categoryName
        self.categoryIcon = categoryIcon
    }
}

struct CategoryRow_Previews: PreviewProvider {    
    static var previews: some View {
        CategoryRow(categoryName: "Book", categoryIcon: "📚")
    }
}
