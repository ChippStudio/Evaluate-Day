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
import AsyncDisplayKit

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
        return CriterionHundredMergeSection(card: self.card)
    }
}

extension CriterionHundredCard: Evaluable {
    var evaluateSectionController: ListSectionController {
        return CriterionHundredEvaluateSection(card: self.card)
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

extension CriterionHundredCard: Analytical {
    var analyticalSectionController: ListSectionController {
        return CriterionHundredAnalyticsSection(card: self.card)
    }
}

extension CriterionHundredCard: Collectible {
    func collectionCellFor(_ date: Date) -> ASCellNode? {
        if let value = self.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).first {
            let node = CollectibleDataNode(title: self.card.title, image: Sources.image(forType: self.card.type), data: "\(Int(value.value))")
            return node
        }
        
        return nil
    }
}
