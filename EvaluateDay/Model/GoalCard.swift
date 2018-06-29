//
//  GoalCard.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 26/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class GoalCard: Object {
    // MARK: - General
    @objc dynamic var step: Double = 1.0
    @objc dynamic var isSum: Bool = false
    @objc dynamic var startValue: Double = 0.0
    @objc dynamic var goalValue: Double = 0.0
    
    // MARK: - Values
    var values: Results<NumberValue> {
        return Database.manager.data.objects(NumberValue.self).filter("owner=%@ AND isDeleted=%@", self.card.id, false)
    }
    
    // MARK: - Card
    @objc dynamic var card: Card!
}
