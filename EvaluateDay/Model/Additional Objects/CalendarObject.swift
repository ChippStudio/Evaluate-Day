//
//  CalendarObject.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class CalendarObject: NSObject {
    var id: String = UUID.id
}

extension CalendarObject: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if object is CalendarObject {
            return true
        }
        return false
    }

}
