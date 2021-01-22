//
//  LogDetail.swift
//  Achievements
//
//  Created by Yuki Takahashi on 22/01/2021.
//

import SwiftUI

struct MaterialLogRow: View {
    var log: Log
    static let logDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(log.wrappedRecordDate, formatter: Self.logDateFormat)" )
                    .font(.subheadline)
            
                EmojiRating(rating: log.rating)
                    .font(.largeTitle)
            }
            Text(log.wrappedComment)
                .font(.headline)
        }
    }
}
