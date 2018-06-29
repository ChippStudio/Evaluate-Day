//
//  CriterionHundredCard.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 30/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class CriterionHundredCard: Object {
    
    // MARK: - General
    @objc dynamic var positive: Bool = true
    
    // MARK: - Values
    var values: Results<NumberValue> {
        return Database.manager.data.objects(NumberValue.self).filter("owner=%@ AND isDeleted=%@", self.card.id, false)
    }
    
    // MARK: - Card
    @objc dynamic var card: Card!
}
