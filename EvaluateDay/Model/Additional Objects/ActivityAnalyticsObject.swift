//
//  ActivityAnalyticsObject.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 19/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class ActivityAnalyticsObject: NSObject {
    var id: String = UUID.id
    var pro: Bool = false
}

extension ActivityAnalyticsObject: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? ActivityAnalyticsObject {
            if self.pro != object.pro {
                return false
            }
            
            return true
        }
        return false
    }
}
