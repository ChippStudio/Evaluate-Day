//
//  DateObject.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class DateObject: NSObject {
    var id: String = UUID.id
    var date = Date()
    
    init(date: Date) {
        super.init()
        
        self.date = date
    }
}

extension DateObject: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? DateObject {
            if object.date == self.date {
                return true
            }
        }
        return false
    }
}
