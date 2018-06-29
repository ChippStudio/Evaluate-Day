//
//  CriterionTenCard.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 11/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class CriterionTenCard: Object {
    // MARK: - General
    @objc dynamic var positive: Bool = true
    
    // MARK: - Values
    var values: Results<NumberValue> {
        return Database.manager.data.objects(NumberValue.self).filter("owner=%@ AND isDeleted=%@", self.card.id, false)
    }
    
    // MARK: - Card
    @objc dynamic var card: Card!
}
