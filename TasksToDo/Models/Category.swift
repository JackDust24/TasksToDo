//
//  Category.swift
//  TasksToDo
//
//  Created by JasonMac on 24/2/2561 BE.
//  Copyright © 2561 JasonMac. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
