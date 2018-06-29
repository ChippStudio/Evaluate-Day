//
//  ColorCard.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class ColorCard: Object {
    // MARK: - Card
    @objc dynamic var card: Card!
    
    // MARK: - Colors
    var values: Results<TextValue> {
        return Database.manager.data.objects(TextValue.self).filter("owner=%@ AND isDeleted=%@", self.card.id, false)
    }
}
