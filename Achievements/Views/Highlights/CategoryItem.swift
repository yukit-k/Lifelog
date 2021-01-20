//
//  CategoryItem.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import SwiftUI

struct CategoryItem: View {
    @Environment(\.managedObjectContext) var moc
    var task: CommonTask
    
    var body: some View {
        VStack(alignment: .leading) {
            self.task.image.map({
                UIImage(data: $0)
                    .map({
                            Image(uiImage: $0)
                                .resizable()
                                .frame(width: 155, height:155)
                                .cornerRadius(5)
                    })
            })
            
            Text(task.title ?? "Unknown Title")
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}

struct CategoryItem_Previews: PreviewProvider {
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let bookTest = CommonTask(context: context)
        bookTest.title = "Test book"
        bookTest.shortDesc = "Some interesting book."
        bookTest.genre = "Fantasy"
        bookTest.rating = 4
        bookTest.comment = "This was a great book"
        bookTest.recordDate = Date()
        return CategoryItem(task: bookTest).environment(\.managedObjectContext, context)
        
    }
}
