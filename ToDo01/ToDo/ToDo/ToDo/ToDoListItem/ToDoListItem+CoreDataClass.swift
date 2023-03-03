//
//  ToDoListItem+CoreDataClass.swift
//  ToDo
//
//  Created by Precious Omoroga on 2023/02/27.
//
//

import Foundation
import CoreData

@objc(ToDoListItem)
public class ToDoListItem: NSManagedObject {
// To put some custom functionality
    var isChecked :Bool = false
}
