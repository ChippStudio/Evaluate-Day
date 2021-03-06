//
//  CounterCard.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 19/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class CounterCard: Object {
    // MARK: - General
    @objc dynamic var step: Double = 1.0
    @objc dynamic var isSum: Bool = false
    @objc dynamic var startValue: Double = 0.0
    @objc dynamic var measurement: String = ""
    
    // MARK: - Values
    var values: Results<NumberValue> {
        return Database.manager.data.objects(NumberValue.self).filter("owner=%@ AND isDeleted=%@", self.card.id, false)
    }
    
    // MARK: - Card
    @objc dynamic var card: Card!
}
