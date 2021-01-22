//
//  Material+CoreDataClass.swift
//  Achievements
//
//  Created by Yuki Takahashi on 21/01/2021.
//
//

import Foundation
import CoreData

@objc(Material)
public class Material: NSManagedObject {
    enum Category: String, CaseIterable, Identifiable {
        case book = "Book"
        case task = "Task"
        case watch = "Watch"
        case others = "Others"

        var id: String { self.rawValue }
    }

}
