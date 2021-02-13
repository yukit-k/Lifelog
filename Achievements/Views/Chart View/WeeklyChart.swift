//
//  WeeklyChart.swift
//  Achievements
//
//  Created by Yuki Takahashi on 13/02/2021.
//

import SwiftUI

struct WeeklyChart: View {
    var prevWeekLogs: [Log]
    var thisWeekLogs: [Log]
    
    let calendar = Calendar.current
    
    func countLogs(_ logs: [Log], _ weekday: Int) -> Int {
        logs.filter {
            calendar.component(.weekday, from: $0.wrappedActivityDate) == weekday + 1
        }.count
    }
    
    func weekAbbrFromInt(_ weekday: Int) -> String {
        let wk = calendar.shortWeekdaySymbols
        return wk[weekday]
    }
    
    var body: some View {
        HStack {
            Spacer()
            ForEach(0..<7) { weekday in
                VStack {
                    HStack(spacing: 0) {
                        Spacer()
                        VStack {
                            Spacer()
                            if self.countLogs(thisWeekLogs, weekday) > 0 {
                                Text("\(self.countLogs(thisWeekLogs, weekday))")
                                    .font(.footnote)
                                    //.rotationEffect(.degrees(-90))
                                    .offset(y: 10)
                                    .zIndex(1)
                            }
                            Rectangle()
                                .fill(Color.accentColor)
                                .frame(width: 15, height: CGFloat(self.countLogs(thisWeekLogs, weekday)) * 10.0)
                        }
                        
                        VStack {
                            Spacer()
                            if self.countLogs(prevWeekLogs, weekday) > 0 {
                                Text("\(self.countLogs(prevWeekLogs, weekday))")
                                    .font(.footnote)
                                    //.rotationEffect(.degrees(-90))
                                    .offset(y: 10)
                                    .zIndex(1)
                            }
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: 15, height: CGFloat(self.countLogs(prevWeekLogs, weekday)) * 10.0)
                        }
                        Spacer()
                    }
              
                    Text("\(self.weekAbbrFromInt(weekday))")
                        .font(.footnote)
                        .frame(height: 20)
                }
        
            }
            Spacer()
        }
    }
}
//
//struct WeeklyChart_Previews: PreviewProvider {
//    static var previews: some View {
//        WeeklyChart()
//    }
//}
