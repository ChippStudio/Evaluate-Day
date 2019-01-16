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
import AsyncDisplayKit

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
    var evaluateSectionController: ListSectionController {
        return ColorEvaluateSection(card: self.card)
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
            
            newLine = "\(self.card.title), \(date), \(c.created.timeIntervalSince1970), \(edited), \(c.edited.timeIntervalSince1970), #\(c.text)\n"
            
            txtText.append(newLine)
        }
        
        return txtText
    }
}

extension ColorCard: Analytical {
    var analyticalSectionController: ListSectionController {
        return ColorAnalyticsSection(card: self.card)
    }
}

extension ColorCard: Collectible {
    func collectionCellFor(_ date: Date) -> ASCellNode? {
        if let value = self.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).first {
            let node = CollectibleColorNode(title: self.card.title, image: Sources.image(forType: self.card.type), color: value.text)
            return node
        }
        
        return nil
    }
}
