//
//  CardSettingsSiriObject.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/07/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class CardSettingsSiriObject: NSObject {
    var id: String = UUID.id
}

extension CardSettingsSiriObject: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
