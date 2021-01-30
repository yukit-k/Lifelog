//
//  EditableLogData.swift
//  Achievements
//
//  Created by Yuki Takahashi on 27/01/2021.
//

import Foundation

struct EditableLogData {
    var activityDate: Date?
    var author: String?
    var category: String?
    var comment: String?
    var desc: String?
    var genre: String?
    var id: UUID
    var image: Data?
    var isToDo: Bool
    var name: String?
    var rating: Int16
    var status: String?
    var activityVolume: Double
    var totalVolume: Double
    var volumeUnit: String?
    var updatedDate: Date?
    var material: Material?
    
    init(from log: Log) {
        activityDate = log.activityDate
        author = log.author
        category = log.category
        comment = log.comment
        desc = log.desc
        genre = log.genre
        id = log.id
        image = log.image
        isToDo = log.isToDo
        name = log.name
        rating = log.rating
        status = log.status
        activityVolume = log.activityVolume
        totalVolume = log.totalVolume
        volumeUnit = log.volumeUnit
        updatedDate = log.updatedDate
        material = log.material
    }
}

extension Log {
    func updateValues(from editableLogData: EditableLogData) {
        activityDate = editableLogData.activityDate
        author = editableLogData.author
        category = editableLogData.category
        comment = editableLogData.comment
        desc = editableLogData.desc
        genre = editableLogData.genre
        id = editableLogData.id
        image = editableLogData.image
        isToDo = editableLogData.isToDo
        name = editableLogData.name
        rating = editableLogData.rating
        status = editableLogData.status
        activityVolume = editableLogData.activityVolume
        totalVolume = editableLogData.totalVolume
        volumeUnit = editableLogData.volumeUnit
        updatedDate = editableLogData.updatedDate
        material = editableLogData.material
    }
}
