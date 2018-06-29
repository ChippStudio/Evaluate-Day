//
//  markValue.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class MarkValue: Object {
    @objc dynamic var id = UUID.id
    @objc dynamic var owner: String = ""
    @objc dynamic var isDeleted = false
    @objc dynamic var created: Date = Date()
    @objc dynamic var edited: Date = Date()
    @objc dynamic var text: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var doneDate: Date = Date()
    @objc dynamic var order: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
