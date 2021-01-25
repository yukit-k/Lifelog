//
//  AchievementRow.swift
//  Achievements
//
//  Created by Yuki Takahashi on 02/01/2021.
//

import SwiftUI

struct ActivityRow<TargetView: View>: View {
    //@Environment(\.managedObjectContext) var moc
    //var landmark: Landmark
    var log: Log
    let logDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    var nextView: TargetView
    
    var body: some View {
        NavigationLink(destination: nextView) {
            HStack {
                log.wrappedMaterial.image.map({
                    UIImage(data: $0)
                        .map({
                                Image(uiImage: $0)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                        })
                })
                VStack(alignment: .leading) {
                    HStack {
                        Text(log.wrappedMaterial.getCategoryIcon(log.wrappedMaterial.wrappedCategory))
                            .font(.caption)
                        Text(log.wrappedMaterial.wrappedName)
                            .font(.headline)
                    }

                    HStack {
                        Text("\(log.wrappedRecordDate, formatter: self.logDateFormat)" )
                        Text("\(log.taskVolume, specifier: "%.0f") \(log.wrappedMaterial.wrappedTaskUnit)" )
                        if self.log.isToDo {
                            Text(" To Do ")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(2)
                                .foregroundColor(.white)
                                .background(Color.orange.opacity(0.85))
                                .clipShape(Capsule())
                        } else {
                            Text(" Done ")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .padding(2)
                                .foregroundColor(.white)
                                .background(Color.green.opacity(0.85))
                                .clipShape(Capsule())
                            EmojiRating(rating: log.rating)

                        }

                    }
                        .font(.subheadline)

                }
                Spacer()
            }
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
        log1.material?.image = UIImage(named: "defaultBook")?.pngData()
        log1.rating = 4
        log1.comment = "This was a great book"
        log1.recordDate = Date()
        return ActivityRow(log: log1, nextView: ActivityDetailBook(log: log1)).environment(\.managedObjectContext, context)
//        Group {
//            AchievementRow(landmark: landmarks[0])
//            AchievementRow(landmark: landmarks[1])
//        }
//        .previewLayout(.fixed(width: 300, height: 70))
//
        
    }
}
