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
    let id: String = UUID.id
    let dashboardsCount: Int
    
    override init() {
        self.dashboardsCount = Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@", false).count
    }
}

extension DashboardsObject: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? DashboardsObject {
            if self.dashboardsCount == object.dashboardsCount {
                return true
            }
        }
        return false
    }
}
