//
//  ListCard.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class ListCard: Object {
    // MARK: - General
    
    // MARK: - Values
    var values: Results<MarkValue> {
        return Database.manager.data.objects(MarkValue.self).filter("owner=%@ AND isDeleted=%@", self.card.id, false)
    }
    
    // MARK: - Card
    @objc dynamic var card: Card!
}
