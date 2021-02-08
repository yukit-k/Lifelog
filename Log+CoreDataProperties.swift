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
    @NSManaged public var creator: String?
    @NSManaged public var category: String?
    @NSManaged public var categoryIcon: String?
    @NSManaged public var comment: String?
    @NSManaged public var desc: String?
    @NSManaged public var subCategory: String?
    @NSManaged public var subCategoryIcon: String?
    @NSManaged public var id: UUID
    @NSManaged public var image: Data?
    @NSManaged public var isToDo: Bool
    @NSManaged public var isRoutine: Bool
    @NSManaged public var routineLogId: UUID?
    @NSManaged public var name: String?
    @NSManaged public var rating: Int16
    @NSManaged public var status: String?
    @NSManaged public var amount: Double
    @NSManaged public var unit: String?
    @NSManaged public var updatedDate: Date?
    @NSManaged public var material: Material?
    
    public var wrappedActivityDate: Date {
        activityDate ?? Date()
    }
    public var wrappedCreator: String {
        creator ?? ""
    }
    public var wrappedCategory: String {
        category ?? "-"
    }
    public var wrappedCategoryIcon: String {
        categoryIcon ?? ""
    }
    public var wrappedComment: String {
        comment ?? ""
    }
    public var wrappedDesc: String {
        desc ?? ""
    }
    public var wrappedSubCategory: String {
        subCategory ?? "-"
    }
    public var wrappedSubCategoryIcon: String {
        subCategoryIcon ?? ""
    }
    public var wrappedName: String {
        name ?? "Undefined"
    }
    public var wrappedStatus: String {
        status ?? "Unknown"
    }
    public var wrappedUnit: String {
        unit ?? ""
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
//    enum Category: String, CaseIterable, Identifiable {
//        case Book = "Book"
//        case Task = "Task"
//        case Exercise = "Exercise"
//        case Cook = "Cook"
//        case Others = "Others"
//
//        var id: String { self.rawValue }
//    }
//    enum CategoryIcon: String, CaseIterable, Identifiable {
//        case Book = "📚"
//        case Task = "🧾"
//        case Exercise = "🏃‍♀️"
//        case Cook = "🥕"
//        case Others = "🗂"
//
//        var id: String { self.rawValue }
//    }
//    static func getCategoryIcon(_ name: String) -> String {
//        var categoryIcon: String
//        switch name {
//        case Log.Category.Book.rawValue: categoryIcon = Log.CategoryIcon.Book.rawValue
//        case Log.Category.Task.rawValue: categoryIcon = Log.CategoryIcon.Task.rawValue
//        case Log.Category.Cook.rawValue: categoryIcon = Log.CategoryIcon.Cook.rawValue
//        case Log.Category.Exercise.rawValue: categoryIcon = Log.CategoryIcon.Exercise.rawValue
//        default: categoryIcon = Log.CategoryIcon.Others.rawValue
//        }
//        return categoryIcon
//    }
//    static func getCategoryIcon(_ category: Log.Category) -> String {
//        var categoryIcon: String
//        switch category {
//        case Log.Category.Book: categoryIcon = Log.CategoryIcon.Book.rawValue
//        case Log.Category.Task: categoryIcon = Log.CategoryIcon.Task.rawValue
//        case Log.Category.Cook: categoryIcon = Log.CategoryIcon.Cook.rawValue
//        case Log.Category.Exercise: categoryIcon = Log.CategoryIcon.Exercise.rawValue
//        default: categoryIcon = Log.CategoryIcon.Others.rawValue
//        }
//        return categoryIcon
//    }
}

extension Log : Identifiable {

}
