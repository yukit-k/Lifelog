//
//  Log+CoreDataProperties.swift
//  Achievements
//
//  Created by Yuki Takahashi on 21/01/2021.
//
//

import Foundation
import CoreData

extension Log {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Log> {
        return NSFetchRequest<Log>(entityName: "Log")
    }
    
    @NSManaged public var activityDate: Date?
    @NSManaged public var author: String?
    @NSManaged public var category: String?
    @NSManaged public var comment: String?
    @NSManaged public var desc: String?
    @NSManaged public var genre: String?
    @NSManaged public var id: UUID
    @NSManaged public var image: Data?
    @NSManaged public var isToDo: Bool
    @NSManaged public var name: String?
    @NSManaged public var rating: Int16
    @NSManaged public var status: String?
    @NSManaged public var activityVolume: Double
    @NSManaged public var totalVolume: Double
    @NSManaged public var volumeUnit: String?
    @NSManaged public var updatedDate: Date?
    @NSManaged public var material: Material?
    
    public var wrappedActivityDate: Date {
        activityDate ?? Date()
    }
    public var wrappedAuthor: String {
        author ?? ""
    }
    public var wrappedCategory: String {
        category ?? "Others"
    }
    public var wrappedComment: String {
        comment ?? ""
    }
    public var wrappedDesc: String {
        desc ?? ""
    }
    public var wrappedGenre: String {
        genre ?? ""
    }
    public var wrappedName: String {
        name ?? "Undefined"
    }
    public var wrappedStatus: String {
        status ?? "Unknown"
    }
    public var wrappedVolumeUnit: String {
        volumeUnit ?? ""
    }
    public var wrappedUpdatedDate: Date {
        updatedDate ?? Date()
    }
//    public var wrappedMaterial: Material {
//        material ?? defaultMaterial()
//    }
//    func defaultMaterial() -> Material {
//        let defMat = Material()
//        defMat.name = "Default"
//        defMat.version = "1.0"
//        defMat.desc = "Material not found"
//        defMat.category = "Others"
//        defMat.updatedDate = Date()
//        return defMat
//    }
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
    static func getCategoryIcon(_ name: String) -> String {
        var categoryIcon: String
        switch name {
        case Log.Category.Book.rawValue: categoryIcon = Log.CategoryIcon.Book.rawValue
        case Log.Category.Task.rawValue: categoryIcon = Log.CategoryIcon.Task.rawValue
        case Log.Category.Cook.rawValue: categoryIcon = Log.CategoryIcon.Cook.rawValue
        case Log.Category.Exercise.rawValue: categoryIcon = Log.CategoryIcon.Exercise.rawValue
        default: categoryIcon = Log.CategoryIcon.Others.rawValue
        }
        return categoryIcon
    }
    static func getCategoryIcon(_ category: Log.Category) -> String {
        var categoryIcon: String
        switch category {
        case Log.Category.Book: categoryIcon = Log.CategoryIcon.Book.rawValue
        case Log.Category.Task: categoryIcon = Log.CategoryIcon.Task.rawValue
        case Log.Category.Cook: categoryIcon = Log.CategoryIcon.Cook.rawValue
        case Log.Category.Exercise: categoryIcon = Log.CategoryIcon.Exercise.rawValue
        default: categoryIcon = Log.CategoryIcon.Others.rawValue
        }
        return categoryIcon
    }
}

extension Log : Identifiable {

}
