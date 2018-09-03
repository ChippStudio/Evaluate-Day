//
//  Dashboard.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 02/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class Dashboard: Object {
    // General
    @objc dynamic var id = UUID.id
    @objc dynamic var isDeleted = false
    @objc dynamic var title: String = ""
    @objc dynamic var image: String = "dashboard-0"
    @objc dynamic var created: Date = Date()
    @objc dynamic var edited: Date = Date()
    @objc dynamic var order: Int = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
