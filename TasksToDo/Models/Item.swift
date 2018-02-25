//
//  Item.swift
//  TasksToDo
//
//  Created by JasonMac on 25/2/2561 BE.
//  Copyright © 2561 JasonMac. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date = Date()
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")


}
