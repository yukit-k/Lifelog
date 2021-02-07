//
//  Material+CoreDataProperties.swift
//  Achievements
//
//  Created by Yuki Takahashi on 21/01/2021.
//
//

import Foundation
import CoreData


extension Material {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Material> {
        return NSFetchRequest<Material>(entityName: "Material")
    }

    @NSManaged public var creator: String?
    @NSManaged public var category: String?
    @NSManaged public var categoryIcon: String?
    @NSManaged public var desc: String?
    @NSManaged public var subCategory: String?
    @NSManaged public var image: Data?
    @NSManaged public var isRoutine: Bool
    @NSManaged public var name: String?
    @NSManaged public var status: String?
    @NSManaged public var unit: String?
    @NSManaged public var version: String?
    @NSManaged public var updatedDate: Date?
    @NSManaged public var log: NSSet?
    
    public var wrappedName: String {
        name ?? "Unknown Name"
    }
    public var wrappedCreator: String {
        creator ?? ""
    }
    public var wrappedCategory: String {
        category ?? "Others"
    }
    public var wrappedCategoryIcon: String {
        categoryIcon ?? ""
    }
    public var wrappedDesc: String {
        desc ?? "No description"
    }
    public var wrappedSubCategory: String {
        subCategory ?? "Others"
    }
    public var wrappedVersion: String {
        version ?? ""
    }
    public var wrappedUpdatedDate: Date {
        updatedDate ?? Date()
    }
    public var wrappedStatus: String {
        status ?? "Undefined"
    }
    public var wrappedUnit: String {
        unit ?? ""
    }
    public var logArray: [Log] {
        let set = log as? Set<Log> ?? []
        
        return set.sorted {
            $0.wrappedUpdatedDate > $1.wrappedUpdatedDate
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
