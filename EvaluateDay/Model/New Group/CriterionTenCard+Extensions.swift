//
//  CriterionTenCard+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 11/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import RealmSwift
import IGListKit
import CloudKit
import AsyncDisplayKit

extension CriterionTenCard: Editable {
    var sectionController: ListSectionController {
        return CriterionTenEditSection(card: self.card)
    }
    
    var canSave: Bool {
        if self.card.title == "" {
            return false
        }
        
        return true
    }
}

extension CriterionTenCard: Mergeable {
    var mergeableSectionController: ListSectionController {
        return CriterionTenMergeSection(card: self.card)
    }
}

extension CriterionTenCard: Evaluable {
    var evaluateSectionController: ListSectionController {
        return CriterionTenEvaluateSection(card: self.card)
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
    
    func lastEventDate() -> Date? {
        if let last = self.values.sorted(byKeyPath: "created", ascending: false).last {
            return last.created
        }
        
        return nil
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

extension CriterionTenCard: Analytical {
    var analyticalSectionController: ListSectionController {
        return CriterionTenAnalyticsSection(card: self.card)
    }
}

extension CriterionTenCard: Collectible {
    func collectionCellFor(_ date: Date) -> ASCellNode? {
        if let value = self.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).first {
            let node = CollectibleDataNode(title: self.card.title, image: Sources.image(forType: self.card.type), data: "\(Int(value.value))")
            return node
        }
        
        return nil
    }
}
