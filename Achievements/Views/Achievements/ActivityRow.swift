//
//  AchievementRow.swift
//  Achievements
//
//  Created by Yuki Takahashi on 02/01/2021.
//

import SwiftUI

struct ActivityRow: View {
    //@Environment(\.managedObjectContext) var moc
    //var landmark: Landmark
    var log: Log
    static let logDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    var body: some View {
        HStack {
            log.material?.image.map({
                UIImage(data: $0)
                    .map({
                            Image(uiImage: $0)
                                .resizable()
                                .frame(width: 50, height: 50)
                    })
            })
            VStack(alignment: .leading) {
                Text(log.material?.name ?? "Unknown Name")
                    .font(.headline)
                
                HStack {
                    Text(log.material?.category ?? "Others")
                        .font(.subheadline)
                    Text("\(log.recordDate ?? Date(), formatter: Self.logDateFormat)" )
                        .font(.subheadline)
                }
            }

//            landmark.image
//                .resizable()
//                .frame(width: 50, height: 50)
//            Text(landmark.name)
            
            Spacer()
            
            EmojiRating(rating: log.rating)
                .font(.headline)

//            if landmark.isFavorite {
//                Image(systemName: "star.fill")
//                    .foregroundColor(.yellow)
//            }
        }
    }
}

struct ActivityRow_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let log1 = Log(context: context)
        log1.material?.name = "Test book"
        log1.material?.category = "Book"
        log1.material?.updateDate = Date()
        log1.material?.genre = "Fantasy"
        log1.rating = 4
        log1.comment = "This was a great book"
        log1.recordDate = Date()
        return ActivityRow(log: log1).environment(\.managedObjectContext, context)
//        Group {
//            AchievementRow(landmark: landmarks[0])
//            AchievementRow(landmark: landmarks[1])
//        }
//        .previewLayout(.fixed(width: 300, height: 70))
//
        
    }
}
