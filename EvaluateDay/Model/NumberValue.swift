//
//  NumberValue.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 06/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class NumberValue: Object {
    // MARK: - General
    @objc dynamic var id = UUID.id
    @objc dynamic var owner: String = ""
    @objc dynamic var isDeleted = false
    @objc dynamic var created: Date = Date()
    @objc dynamic var edited: Date = Date()
    @objc dynamic var value: Double = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
