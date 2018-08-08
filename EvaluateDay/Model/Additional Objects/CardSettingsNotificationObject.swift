//
//  CardSettingsNotificationObject.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 08/08/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class CardSettingsNotificationObject: NSObject {
    var id: String = UUID.id
    var card: Card!
    
    init(card: Card) {
        self.card = card
    }
}

extension CardSettingsNotificationObject: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        
        if let object = object as? CardSettingsNotificationObject {
            if self.card == nil || object.card == nil {
                return false
            }
            
            if self.card.realm == nil || object.card.realm == nil {
                return false
            }
            
            return true
        }
        
        return false
    }
}
