//
//  Material+CoreDataProperties.swift
//  Achievements
//
//  Created by Yuki Takahashi on 17/01/2021.
//
//

import Foundation
import CoreData


extension Material {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Material> {
        return NSFetchRequest<Material>(entityName: "Material")
    }

    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var id: UUID?
    @NSManaged public var author: String?
    @NSManaged public var category: String?
    @NSManaged public var genre: String?
    @NSManaged public var image: Data?
    @NSManaged public var total: String?
    @NSManaged public var log: NSSet?
    
    public var wrappedName: String {
        name ?? "Unknown Name"
    }
    
    public var logArray: [Log] {
        let set = log as? Set<Log> ?? []
        
        return set.sorted {
            $0.wrappedTaskDate < $1.wrappedTaskDate
        }
    }

}

// MARK: Generated accessors for log
extension Material {

    @objc(addLogObject:)
    @NSManaged public func addToLog(_ value: Log)

    @objc(removeLogObject:)
    @NSManaged public func removeFromLog(_ value: Log)

    @objc(addLog:)
    @NSManaged public func addToLog(_ values: NSSet)

    @objc(removeLog:)
    @NSManaged public func removeFromLog(_ values: NSSet)

}

extension Material : Identifiable {

}
