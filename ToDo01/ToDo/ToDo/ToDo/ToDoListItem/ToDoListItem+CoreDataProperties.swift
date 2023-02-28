//
//  ToDoListItem+CoreDataProperties.swift
//  ToDo
//
//  Created by Precious Omoroga on 2023/02/27.
//
//

import Foundation
import CoreData


extension ToDoListItem {
//fetch request as well as managed qualities
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var name: String?
    @NSManaged public var createAt: Date?
    @NSManaged public var completed: Bool  

}

extension ToDoListItem : Identifiable {

}
