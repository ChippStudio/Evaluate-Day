//
//  ActivityPhotoObject.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 20/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class ActivityPhotoObject: NSObject {
    var id: String = UUID.id
    var pro: Bool = false
}

extension ActivityPhotoObject: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? ActivityPhotoObject {
            if self.pro != object.pro {
                return false
            }
            
            return true
        }
        return false
    }
}
