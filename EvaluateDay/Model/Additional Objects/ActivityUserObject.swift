//
//  ActivityUserObject.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class ActivityUserObject: NSObject {
    let id = UUID.id
    var pro: Bool = false
}

extension ActivityUserObject: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? ActivityUserObject {
            if self.pro != object.pro {
                return false
            }
            
            return true
        }
        return false
    }
}
