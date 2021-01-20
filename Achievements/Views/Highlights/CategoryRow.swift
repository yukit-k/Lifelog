//
//  CategoryRow.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import SwiftUI

struct CategoryRow: View {
    var categoryName: String
    //var items: [Landmark]
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CommonTask.entity(), sortDescriptors: [
        NSSortDescriptor(keyPath: \CommonTask.recordDate, ascending: false),
        NSSortDescriptor(keyPath: \CommonTask.title, ascending: true)
    ]) var tasks: FetchedResults<CommonTask>

    var body: some View {
        VStack(alignment: .leading) {
            Text(categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(tasks) { task in
                        NavigationLink(destination: AchievementDetail(task: task)) {
                            CategoryItem(task: task)
                        }
                    }
                }
            }
            .frame(height: 185)
        }
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var landmarks = ModelData().landmarks
    
    static var previews: some View {
        CategoryRow(categoryName: "Book")
    }
}
