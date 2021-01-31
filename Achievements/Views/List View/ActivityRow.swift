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
                log.image.map({
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
                        Text(log.wrappedCategoryIcon)
                            .font(.caption)
                        Text(log.wrappedName)
                            .font(.headline)
                    }

                    HStack {
                        Text("\(log.wrappedActivityDate, formatter: self.logDateFormat)" )
                        if log.amount > 0 {
                            Text("\(log.amount, specifier: "%.0f") \(log.wrappedUnit)")
                        }
                        Spacer()
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
                        }
                        EmojiRating(rating: log.rating)

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
        log1.name = "Test book"
        log1.category = "Book"
        log1.updatedDate = Date()
        log1.subCategory = "Fantasy"
        log1.image = UIImage(named: "defaultBook")?.pngData()
        log1.rating = 4
        log1.comment = "This was a great book"
        log1.activityDate = Date()
        return ActivityRow(log: log1, nextView: ActivityDetail(log: log1)).environment(\.managedObjectContext, context)
    }
}
