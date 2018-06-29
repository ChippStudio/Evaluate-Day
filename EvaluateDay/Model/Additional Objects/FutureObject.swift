//
//  FutureObject.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 15/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class FutureObject: NSObject {
    var id: String = UUID.id
}

extension FutureObject: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if object is FutureObject {
            return true
        }
        return false
    }
}
