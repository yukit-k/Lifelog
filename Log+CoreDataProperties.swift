//
//  Log+CoreDataProperties.swift
//  Achievements
//
//  Created by Yuki Takahashi on 17/01/2021.
//
//

import Foundation
import CoreData


extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }

    @NSManaged public var taskDate: Date?
    @NSManaged public var fromPosition: Int16
    @NSManaged public var toPosition: Int16
    @NSManaged public var percentageDay: Double
    @NSManaged public var percentageToDate: Double
    @NSManaged public var rating: Int16
    @NSManaged public var comment: String?
    @NSManaged public var id: UUID?
    @NSManaged public var status: String?
    @NSManaged public var material: Material?
    
    public var wrappedTaskDate: Date {
        taskDate ?? Date()
    }

}

extension Log : Identifiable {

}
