//
//  DashboardsObject.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 03/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class DashboardsObject: NSObject {
    let id = UUID.id
}

extension DashboardsObject: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
