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
            ZStack(alignment: .bottom) {
                HStack(spacing: 0) {
                    Spacer()
                    ForEach(0..<31) { day in
                        VStack(spacing: 0) {
                            HStack(spacing: 0) {
                                Spacer()
                                VStack(spacing: 0) {
                                    Spacer()
                                    if self.countLogs(thisMonthLogs, day) == 1 {
                                        Text("\(self.countLogs(thisMonthLogs, day))")
                                            .font(.footnote)
                                            .offset(y: -5)
                                            .zIndex(2)
                                    } else if self.countLogs(thisMonthLogs, day) > 1 {
                                        Text("\(self.countLogs(thisMonthLogs, day))")
                                            .font(.footnote)
                                            .foregroundColor(.white)
                                            //.rotationEffect(.degrees(-90))
                                            .offset(y: CGFloat(self.countLogs(thisMonthLogs, day) - 1) * 5.0 + 12.0)
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
                      
                            Text("\(sequenceString(day+1))")
                                .font(.footnote)
                                .frame(height: 20)
                                .padding(.top, 10)
                        }
                
                    }
                    Spacer()
                }
                .zIndex(1)
                ForEach(0..<max(self.countCumLogs(prevMonthLogs, 31), self.countCumLogs(thisMonthLogs, 31))) { mark in
                    if (mark % 5 == 0) {
                        Rectangle()
                            .fill(Color.gray)
                            .offset(y: CGFloat(mark) * -10.0 - 30.0)
                            .frame(height: 1.0)
                        HStack{
                            Text("\(mark)")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .offset(y: CGFloat(mark) * -10.0 - 30.0)
                    }
                }
            }
        }
    }
    func sequenceString(_ num: Int) -> String {
        if [1, 21, 31].contains(num)  {
            return "\(num)st"
        } else if [2, 22].contains(num) {
            return "\(num)nd"
        } else if [3, 23].contains(num) {
            return "\(num)rd"
        } else {
            return "\(num)th"
        }
    }
}
//
//struct MonthlyChart_Previews: PreviewProvider {
//    static var previews: some View {
//        MonthlyChart()
//    }
//}
