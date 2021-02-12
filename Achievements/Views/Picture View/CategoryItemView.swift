//
//  CategoryItem.swift
//  Landmarks
//
//  Created by Yuki Takahashi on 03/01/2021.
//

import SwiftUI

struct CategoryItemView: View {
    var log: Log
    static let updatedDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        //formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "dd-MMM"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomTrailing) {
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
                Text("\(log.wrappedSubCategoryIcon)\(log.wrappedSubCategory.uppercased())")
                    .font(.system(size: 8))
                    .padding(6)
                    .foregroundColor(.white)
                    .background(Color.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(x: -5, y: -5)
            }
            
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

struct CategoryItemView_Previews: PreviewProvider {
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let log1 = Log(context: context)
        log1.name = "Test book"
        log1.category = "Book"
        log1.updatedDate = Date()
        return CategoryItemView(log: log1)
            //.environment(\.managedObjectContext, context)
        
    }
}
