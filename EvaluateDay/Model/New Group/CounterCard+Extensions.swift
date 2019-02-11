//
//  CounterCard+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 19/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import RealmSwift
import IGListKit
import CloudKit
import AsyncDisplayKit

extension CounterCard: Editable {
    var sectionController: ListSectionController {
        return CounterEditableSection(card: self.card)
    }
    
    var canSave: Bool {
        if self.card.title == "" {
            return false
        }
        
        return true
    }
}

extension CounterCard: Mergeable {
    var mergeableSectionController: ListSectionController {
        return CounterMergeSection(card: self.card)
    }
}

extension CounterCard: Evaluable {
    var evaluateSectionController: ListSectionController {
        return CounterEvaluateSection(card: self.card)
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
        var txtText = "Title,Subtitle,Created,'Created - Since 1970',Edited,'Edited - Since 1970',Value, 'Start Value', Step\n"
        
        let sortedValues = self.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            newLine = "\(self.card.title), \(self.card.subtitle), \(date), \(c.created.timeIntervalSince1970), \(edited), \(c.edited.timeIntervalSince1970), \(c.value), \(self.startValue), \(self.step)\n"
            
            txtText.append(newLine)
        }
        
        return txtText
    }
}

extension CounterCard: Analytical {
    var analyticalSectionController: ListSectionController {
        return CounterAnalyticsSection(card: self.card)
    }
}

extension CounterCard: Collectible {
    func collectionCellFor(_ date: Date) -> ASCellNode? {
        if let value = self.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).first {
            let node = CollectibleDataNode(title: self.card.title, image: Sources.image(forType: self.card.type), data: String(format: "%.2f", value.value))
            return node
        }
        
        return nil
    }
}
