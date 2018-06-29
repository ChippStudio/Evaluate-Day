//
//  CheckInCard.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 11/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class CheckInCard: Object {
    // MARK: - Card
    @objc dynamic var card: Card!
    
    // MARK: - Locations
    var values: Results<LocationValue> {
        return Database.manager.data.objects(LocationValue.self).filter("owner=%@ AND isDeleted=%@", self.card.id, false)
    }
}
