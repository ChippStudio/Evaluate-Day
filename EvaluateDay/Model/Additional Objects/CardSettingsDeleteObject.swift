//
//  CardSettingsDeleteObject.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 08/08/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class CardSettingsDeleteObject: NSObject {
    var id: String = UUID.id
}

extension CardSettingsDeleteObject: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
