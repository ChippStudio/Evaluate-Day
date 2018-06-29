//
//  TrackerCard.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 07/04/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class TrackerCard: Object {
    // MARK: - Values
    var values: Results<MarkValue> {
        return Database.manager.data.objects(MarkValue.self).filter("owner=%@ AND isDeleted=%@", self.card.id, false)
    }
    
    // MARK: - Card
    @objc dynamic var card: Card!
}
