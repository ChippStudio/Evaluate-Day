//
//  HealthCard.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 14/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class HealthCard: Object {
    // MARK: - General
    @objc dynamic var goal: Double = 0.0
    @objc dynamic var type: String = ""
    
    // MARK: - Value
    var values: Results<HealthValue> {
        return Database.manager.data.objects(HealthValue.self).filter("owner=%@ AND isDeleted=%@", self.card.id, false)
    }
    
    // MARK: - Card
    @objc dynamic var card: Card!
    
    // MARK: - Source type
    var source: HealthSource? {
        get {
            guard let healthType = HealthType(rawValue: self.type) else {
                return nil
            }
            return HealthSource.init(type: healthType)
        }
    }
}
