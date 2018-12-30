//
//  CollectionActionsObject.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 30/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class CollectionActionsObject: NSObject {
    var id: String = UUID.id
}

extension CollectionActionsObject: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
