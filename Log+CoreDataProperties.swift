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

    @NSManaged public var comment: String?
    @NSManaged public var fromPosition: Int16
    @NSManaged public var percentageDay: Double
    @NSManaged public var taskAmount: Double
    @NSManaged public var taskUnit: String?
    @NSManaged public var rating: Int16
    @NSManaged public var status: String?
    @NSManaged public var recordDate: Date?
    @NSManaged public var toPosition: Int16
    @NSManaged public var isToDo: Bool
    @NSManaged public var material: Material?
    
    public var wrappedComment: String {
        comment ?? ""
    }

    public var wrappedStatus: String {
        status ?? "Unknown Status"
    }
    
    public var wrappedRecordDate: Date {
        recordDate ?? Date()
    }
    
    public var wrappedTaskUnit: String {
        taskUnit ?? ""
    }
    
    public var wrappedMaterial: Material {
        material ?? defaultMaterial()
    }
    
    func defaultMaterial() -> Material {
        let defMat = Material()
        defMat.name = "Default"
        defMat.version = "1.0"
        defMat.desc = "Material not found"
        defMat.category = "Others"
        defMat.updateDate = Date()
        return defMat

    }

}

extension Log : Identifiable {

}
