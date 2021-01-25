//
//  LogDetail.swift
//  Achievements
//
//  Created by Yuki Takahashi on 22/01/2021.
//

import SwiftUI

struct ItemDetailLogRow<TargetView: View>: View {
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
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(log.wrappedRecordDate, formatter: self.logDateFormat)" )
                            .font(.headline)
                        Text("\(log.taskVolume, specifier: "%.0f") \(log.wrappedMaterial.wrappedTaskUnit)" )
                            .font(.subheadline)
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
                        Spacer()
                    }
                    Text(log.wrappedComment)
                        .font(.subheadline)

                }
                Spacer()
                log.image1.map({
                    UIImage(data: $0)
                        .map({
                                Image(uiImage: $0)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                        })
                })
            }
        }
    }
}
