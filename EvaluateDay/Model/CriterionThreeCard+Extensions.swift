//
//  CriterionThreeCard+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 17/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import RealmSwift
import IGListKit
import CloudKit

extension CriterionThreeCard: Editable {
    var sectionController: ListSectionController {
        return CriterionThreeEditSection(card: self.card)
    }
    
    var canSave: Bool {
        if self.card.title == "" {
            return false
        }
        
        return true
    }
}

extension CriterionThreeCard: Mergeable {
    var mergeableSectionController: ListSectionController {
        return CriterionThreeMergeSection(card: self.card)
    }
}

extension CriterionThreeCard: Evaluable {
    var evaluateSectionController: ListSectionController {
        return CriterionThreeEvaluateSection(card: self.card)
    }
    
    func deleteValues() {
        if self.card.realm == nil {
            return
        }
        
        for value in self.values {
            value.isDeleted = true
        }
    }
    
    func hasEvent(forDate date: Date) -> Bool {
        return !self.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).isEmpty
    }
    
    func textExport() -> String {
        var txtText = "Title,Created,'Created - Since 1970',Edited,'Edited - Since 1970',Value\n"
        
        let sortedValues = self.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            newLine = "\(self.card.title), \(date), \(c.created.timeIntervalSince1970), \(edited), \(c.edited.timeIntervalSince1970), \(c.value)\n"
            
            txtText.append(newLine)
        }
        
        return txtText
    }
}

extension CriterionThreeCard: Analytical {
    var analyticalSectionController: ListSectionController {
        return CriterionThreeAnalyticsSection(card: self.card)
    }
}
