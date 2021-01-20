//
//  AchievementRow.swift
//  Achievements
//
//  Created by Yuki Takahashi on 02/01/2021.
//

import SwiftUI

struct AchievementRow: View {
    @Environment(\.managedObjectContext) var moc
    //var landmark: Landmark
    var task: CommonTask
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    var body: some View {
        HStack {
            task.image.map({
                UIImage(data: $0)
                    .map({
                            Image(uiImage: $0)
                                .resizable()
                                .frame(width: 50, height: 50)
                    })
            })
            VStack(alignment: .leading) {
                Text(task.title ?? "Unknown Ttile")
                    .font(.headline)
                
                HStack {
                    Text(task.taskType ?? "Unknown Type")
                        .font(.subheadline)
                    Text("\(task.recordDate ?? Date(), formatter: Self.taskDateFormat)" )
                        .font(.subheadline)
                }
            }

//            landmark.image
//                .resizable()
//                .frame(width: 50, height: 50)
//            Text(landmark.name)
            
            Spacer()
            
            EmojiRating(rating: task.rating)
                .font(.headline)

//            if landmark.isFavorite {
//                Image(systemName: "star.fill")
//                    .foregroundColor(.yellow)
//            }
        }
    }
}

struct AchievementRow_Previews: PreviewProvider {
    //    static var landmarks = ModelData().landmarks
    //
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let taskTest = CommonTask(context: context)
        taskTest.title = "Test book"
        taskTest.shortDesc = "Some interesting book."
        taskTest.genre = "Fantasy"
        taskTest.rating = 4
        taskTest.comment = "This was a great book"
        taskTest.recordDate = Date()
        return AchievementRow(task: taskTest).environment(\.managedObjectContext, context)
//        Group {
//            AchievementRow(landmark: landmarks[0])
//            AchievementRow(landmark: landmarks[1])
//        }
//        .previewLayout(.fixed(width: 300, height: 70))
//
        
    }
}
