//
//  PhotoValue.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 26/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import RealmSwift

class PhotoValue: Object {
    // MARK: - General
    @objc dynamic var id = UUID.id
    @objc dynamic var owner: String = ""
    @objc dynamic var isDeleted = false
    @objc dynamic var created: Date = Date()
    @objc dynamic var edited: Date = Date()
    
    // MARK: - Photo Specific
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
