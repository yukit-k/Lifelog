//
//  CategoryItem.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import SwiftUI

struct CategoryItem: View {
    var log: Log
    static let updatedDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            self.log.image.map({
                UIImage(data: $0)
                    .map({
                            Image(uiImage: $0)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 155, height:155)
                                .cornerRadius(5)
                    })
            })
            
            HStack {
                Text(log.wrappedName)
                    .foregroundColor(.primary)
                    .font(.caption)
                Spacer()
                Text("\(log.wrappedActivityDate, formatter: Self.updatedDateFormat)" )
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .padding(.leading, 15)
    }
}

struct CategoryItem_Previews: PreviewProvider {
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let log1 = Log(context: context)
        log1.name = "Test book"
        log1.category = "Book"
        log1.updatedDate = Date()
        return CategoryItem(log: log1)
            //.environment(\.managedObjectContext, context)
        
    }
}
