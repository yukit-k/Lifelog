//
//  EditableLogData.swift
//  Achievements
//
//  Created by Yuki Takahashi on 27/01/2021.
//

import Foundation

struct EditableLogData {
    var id: UUID
    var activityDate: Date?
    var creator: String?
    var category: String?
    var categoryIcon: String?
    var subCategory: String?
    var comment: String?
    var desc: String?
    var image: Data?
    var isToDo: Bool
    var name: String?
    var rating: Int16
    var status: String?
    var amount: Double
    var unit: String?
    var updatedDate: Date?
    var material: Material?
    
    init(from log: Log) {
        id = log.id
        activityDate = log.activityDate
        creator = log.creator
        category = log.category
        categoryIcon = log.categoryIcon
        subCategory = log.subCategory
        comment = log.comment
        desc = log.desc
        image = log.image
        isToDo = log.isToDo
        name = log.name
        rating = log.rating
        status = log.status
        amount = log.amount
        unit = log.unit
        updatedDate = log.updatedDate
        material = log.material
    }
}

extension Log {
    func updateValues(from editableLogData: EditableLogData) {
        id = editableLogData.id
        activityDate = editableLogData.activityDate
        creator = editableLogData.creator
        category = editableLogData.category
        categoryIcon = editableLogData.categoryIcon
        subCategory = editableLogData.subCategory
        comment = editableLogData.comment
        desc = editableLogData.desc
        image = editableLogData.image
        isToDo = editableLogData.isToDo
        name = editableLogData.name
        rating = editableLogData.rating
        status = editableLogData.status
        amount = editableLogData.amount
        unit = editableLogData.unit
        updatedDate = editableLogData.updatedDate
        material = editableLogData.material
    }
}
