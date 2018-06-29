//
//  CriterionHundredCard+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift
import IGListKit
import CloudKit

extension CriterionHundredCard: Editable {
    var sectionController: ListSectionController {
        return CriterionHundredEditableSection(card: self.card)
    }
    
    var canSave: Bool {
        if self.card.title == "" {
            return false
        }
        
        return true
    }
}

extension CriterionHundredCard: Mergeable {
    var mergeableSectionController: ListSectionController {
        return CriterionMergeSection(card: self.card)
    }
}

extension CriterionHundredCard: Evaluable {
    var presentSectionController: ListSectionController {
        return CriterionHundredPresentSection(card: self.card)
    }
    
    var evaluateSectionController: ListSectionController {
        return CriterionHundredEvaluateSection(card: self.card)
    }
    
    var listSectionController: ListSectionController {
        return CriterionHundredListSection(card: self.card)
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

extension CriterionHundredCard: Analytical {
    var analyticalSectionController: ListSectionController {
        return CriterionHundredAnalyticsSection(card: self.card)
    }
}
