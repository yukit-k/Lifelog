//
//  TodayTaskItemView.swift
//  Achievements
//
//  Created by Yuki Takahashi on 07/02/2021.
//

import SwiftUI

struct TodayTaskItemView: View {
    @ObservedObject var log: Log
    var isCompleted: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(isCompleted ? Color.blue : Color.gray, lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 5).fill(isCompleted ? Color.blue : Color.white))
                .frame(height: 60)
            HStack {
                log.image.map({
                    UIImage(data: $0)
                        .map({
                                Image(uiImage: $0)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width:45, height:45)
                                    .clipped()
                                    .padding(.leading, 5)
                        })
                })
                VStack(alignment: .leading) {
                    HStack {
                        if isCompleted {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                        }
                        Text(log.wrappedName)
                            .font(.headline)
                            .foregroundColor(isCompleted ? .white : .primary)
                        Spacer()
                    }
                    Text("\(log.wrappedCategoryIcon)\(log.wrappedCategory) / \(log.wrappedSubCategory)")
                        .font(.caption)
                        .foregroundColor(isCompleted ? .white : .primary)
                }
                Spacer()
            }
        }
    }
}

struct TodayTaskItemView_Previews: PreviewProvider {
    static var previews: some View {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let log1 = Log(context: context)
        log1.name = "Test book"
        log1.category = "Book"
        log1.subCategory = "Fantasy"
        log1.image = UIImage(named: "defaultBook")?.pngData()
        log1.rating = 4
        log1.comment = "This was a great book"
        log1.activityDate = Date()
        log1.updatedDate = Date()
        return TodayTaskItemView(log: log1, isCompleted: false).environment(\.managedObjectContext, context)
    }
}
