//
//  ColorCard+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift
import IGListKit
import CloudKit

extension ColorCard: Editable {
    var sectionController: ListSectionController {
        return ColorEditableSection(card: self.card)
    }
    
    var canSave: Bool {
        if self.card.title == "" {
            return false
        }
        
        return true
    }
}

extension ColorCard: Mergeable {
    var mergeableSectionController: ListSectionController {
        return ColorMergeSection(card: self.card)
    }
    
}

extension ColorCard: Evaluable {
    
    var presentSectionController: ListSectionController {
        return ColorPresentSection(card: self.card)
    }
    
    var evaluateSectionController: ListSectionController {
        return ColorEvaluateSection(card: self.card)
    }
    
    var listSectionController: ListSectionController {
        return ColorListSection(card: self.card)
    }
    
    func deleteValues() {
        if self.card.realm == nil {
            return
        }
        
        for value in self.values {
            try! Database.manager.data.write {
                value.isDeleted = true
            }
        }
    }
    
    func hasEvent(forDate date: Date) -> Bool {
        return !self.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).isEmpty
    }
}

extension ColorCard: Analytical {
    var analyticalSectionController: ListSectionController {
        return ColorAnalyticsSection(card: self.card)
    }
}
