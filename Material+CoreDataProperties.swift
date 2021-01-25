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

    @NSManaged public var createdBy: String?
    @NSManaged public var category: String?
    @NSManaged public var desc: String?
    @NSManaged public var genre: String?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var totalVolume: Double
    @NSManaged public var version: String?
    @NSManaged public var updateDate: Date?
    @NSManaged public var percentageToDate: Double
    @NSManaged public var status: String?
    @NSManaged public var taskUnit: String?
    @NSManaged public var log: NSSet?
    
    public var wrappedName: String {
        name ?? "Unknown Name"
    }
    public var wrappedCreatedBy: String {
        createdBy ?? ""
    }
    public var wrappedCategory: String {
        category ?? "Others"
    }
    public var wrappedDesc: String {
        desc ?? "No description"
    }
    public var wrappedGenre: String {
        genre ?? "Others"
    }
    public var wrappedVersion: String {
        version ?? ""
    }
    public var wrappedUpdateDate: Date {
        updateDate ?? Date()
    }
    public var wrappedStatus: String {
        status ?? "Undefined"
    }
    public var wrappedTaskUnit: String {
        taskUnit ?? ""
    }
    public var logArray: [Log] {
        let set = log as? Set<Log> ?? []
        
        return set.sorted {
            $0.wrappedRecordDate > $1.wrappedRecordDate
        }
    }
    
    enum Category: String, CaseIterable, Identifiable {
        case Book = "Book"
        case Task = "Task"
        case Exercise = "Exercise"
        case Cook = "Cook"
        case Others = "Others"

        var id: String { self.rawValue }
    }
    enum CategoryIcon: String, CaseIterable, Identifiable {
        case Book = "📚"
        case Task = "🧾"
        case Exercise = "🏃‍♀️"
        case Cook = "🥕"
        case Others = "🗂"

        var id: String { self.rawValue }
    }
    func getCategoryIcon(_ name: String) -> String {
        var categoryIcon: String
        switch name {
        case Material.Category.Book.rawValue: categoryIcon = Material.CategoryIcon.Book.rawValue
        case Material.Category.Task.rawValue: categoryIcon = Material.CategoryIcon.Task.rawValue
        case Material.Category.Cook.rawValue: categoryIcon = Material.CategoryIcon.Cook.rawValue
        case Material.Category.Exercise.rawValue: categoryIcon = Material.CategoryIcon.Exercise.rawValue
        default: categoryIcon = Material.CategoryIcon.Others.rawValue
        }
        return categoryIcon
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
