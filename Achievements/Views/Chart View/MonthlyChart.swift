//
//  MonthlyChart.swift
//  Achievements
//
//  Created by Yuki Takahashi on 13/02/2021.
//

import SwiftUI

struct MonthlyChart: View {
    var prevMonthLogs: [Log]
    var thisMonthLogs: [Log]
    
    let calendar = Calendar.current
    
    func countLogs(_ logs: [Log], _ day: Int) -> Int {
        logs.filter {
            calendar.component(.day, from: $0.wrappedActivityDate) == day + 1
        }.count
    }

    func countCumLogs(_ logs: [Log], _ day: Int) -> Int {
        logs.filter {
            calendar.component(.day, from: $0.wrappedActivityDate) < day + 1
        }.count
    }

    func monthAbbrFromInt(_ month: Int) -> String {
        let wk = calendar.shortMonthSymbols
        return wk[month]
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Spacer()
                ForEach(0..<31) { day in
                    VStack {
                        HStack(spacing: 0) {
                            Spacer()
                            VStack(spacing: 0) {
                                Spacer()
                                if self.countCumLogs(thisMonthLogs, day+1) > 0 {
                                    Text("\(self.countCumLogs(thisMonthLogs, day+1))")
                                        .font(.footnote)
//                                        .rotationEffect(.degrees(-90))
                                        .offset(y: self.countLogs(thisMonthLogs, day) > 0 ? 10 : -10)
                                        .zIndex(1)
                                }
                                if self.countLogs(thisMonthLogs, day) > 0 {
                                    Text("\(self.countLogs(thisMonthLogs, day))")
                                        .font(.footnote)
                                        //.rotationEffect(.degrees(-90))
                                        .offset(y: 17)
                                        .zIndex(2)
                                }
                                Rectangle()
                                    .fill(Color.accentColor)
                                    .frame(width: 25, height: CGFloat(self.countLogs(thisMonthLogs, day)) * 10.0)
                                Rectangle()
                                    .fill(Color.accentColor)
                                    .opacity(0.2)
                                    .frame(width: 25, height: CGFloat(self.countCumLogs(thisMonthLogs, day)) * 10.0)
                            }
                            
                            VStack(spacing: 0) {
                                Spacer()
                                Rectangle()
                                    .fill(Color.green)
                                    .frame(width: 25, height: CGFloat(self.countLogs(prevMonthLogs, day)) * 10.0)
                                Rectangle()
                                    .fill(Color.green)
                                    .opacity(0.2)
                                    .frame(width: 25, height: CGFloat(self.countCumLogs(prevMonthLogs, day)) * 10.0)
                            }
                            Spacer()
                        }
                  
                        Text("\(day+1)")
                            .font(.footnote)
                            .frame(height: 20)
                    }
            
                }
                Spacer()
            }
        }
    }
}
//
//struct MonthlyChart_Previews: PreviewProvider {
//    static var previews: some View {
//        MonthlyChart()
//    }
//}
