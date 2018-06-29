//
//  ProLock.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 21/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class ProLock: NSObject {
    var id: String = UUID.id
    var pro: Bool = false
}

extension ProLock: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? ProLock {
            if self.pro != object.pro {
                return false
            }
            
            return true
        }
        return false
    }
}
