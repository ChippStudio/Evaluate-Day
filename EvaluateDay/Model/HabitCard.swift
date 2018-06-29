//
//  HabitCard.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class HabitCard: Object {
    // MARK: - General
    @objc dynamic var multiple: Bool = false
    @objc dynamic var negative: Bool = false
    
    // MARK: - Values
    var values: Results<MarkValue> {
        return Database.manager.data.objects(MarkValue.self).filter("owner=%@ AND isDeleted=%@", self.card.id, false)
    }
    
    // MARK: - Card
    @objc dynamic var card: Card!
}
