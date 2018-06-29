//
//  PhraseCard.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class PhraseCard: Object {
    // MARK: - Card
    @objc dynamic var card: Card!
    
    // MARK: - Colors
    var values: Results<TextValue> {
        return Database.manager.data.objects(TextValue.self).filter("owner=%@ AND isDeleted=%@", self.card.id, false)
    }
}
