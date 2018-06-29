//
//  TextValue.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class TextValue: Object {
    @objc dynamic var id = UUID.id
    @objc dynamic var owner: String = ""
    @objc dynamic var isDeleted = false
    @objc dynamic var created: Date = Date()
    @objc dynamic var edited: Date = Date()
    @objc dynamic var text: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension TextValue {
    var characters: Int {
        return self.text.count
    }
}

// Extension for journals
extension TextValue {
    var weather: WeatherValue? {
        return Database.manager.data.objects(WeatherValue.self).filter("owner=%@ AND isDeleted=%@", self.id, false).first
    }
    
    var photos: Results<PhotoValue> {
        return Database.manager.data.objects(PhotoValue.self).filter("owner=%@ AND isDeleted=%@", self.id, false)
    }
    
    var location: LocationValue? {
        return Database.manager.data.objects(LocationValue.self).filter("owner=%@ AND isDeleted=%@", self.id, false).first
    }
}
