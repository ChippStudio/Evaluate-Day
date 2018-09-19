//
//  HealthValue.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 13/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class HealthValue: Object {
    // MARK: - General
    @objc dynamic var id = UUID.id
    @objc dynamic var owner: String = ""
    @objc dynamic var isDeleted = false
    @objc dynamic var created: Date = Date()
    @objc dynamic var edited: Date = Date()
    
    // MARK: - Health Value
    @objc dynamic var value: Double = 0.0
    @objc dynamic var hkValue: String?
}
