//
//  JournalCard.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class JournalCard: Object {
    // MARK: - General
    
    // MARK: - Values
    var values: Results<TextValue> {
        return Database.manager.data.objects(TextValue.self).filter("owner=%@ AND isDeleted=%@", self.card.id, false)
    }
    
    // MARK: - Card
    @objc dynamic var card: Card!
}
