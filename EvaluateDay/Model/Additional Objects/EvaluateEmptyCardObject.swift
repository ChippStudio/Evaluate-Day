//
//  EvaluateEmptyCardObject.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 06/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class EvaluateEmptyCardObject: NSObject {
    var id: String = UUID.id
}

extension EvaluateEmptyCardObject: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
