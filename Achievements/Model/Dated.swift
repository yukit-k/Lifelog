//
//  Dated.swift
//  Achievements
//
//  Created by Yuki Takahashi on 06/02/2021.
//

import Foundation

protocol Dated {
    var date: Date { get }
}

extension Log: Dated {
    var date: Date {
        return activityDate ?? Date()
    }
}

extension Array where Element: Dated {
    func groupedBy(dateComponents: Set<Calendar.Component>) -> [Date: [Element]] {
        let initial: [Date: [Element]] = [:]
        let groupedByDateComponents = reduce(into: initial) { acc, cur in
            let components = Calendar.current.dateComponents(dateComponents, from: cur.date)
            let date = Calendar.current.date(from: components)!
            let existing = acc[date] ?? []
            acc[date] = existing + [cur]
        }
        
        return groupedByDateComponents
    }
}

