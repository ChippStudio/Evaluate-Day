//
//  CardSettingsCollectionObject.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class CardSettingsCollectionObject: NSObject {
    var id: String = UUID.id
}

extension CardSettingsCollectionObject: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
