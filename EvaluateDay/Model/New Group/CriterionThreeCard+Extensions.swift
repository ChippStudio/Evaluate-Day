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
import AsyncDisplayKit

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
    
    func lastEventDate() -> Date? {
        if let last = self.values.sorted(byKeyPath: "created", ascending: true).last {
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

extension CriterionThreeCard: Analytical {
    var analyticalSectionController: ListSectionController {
        return CriterionThreeAnalyticsSection(card: self.card)
    }
}

extension CriterionThreeCard: Collectible {
    func collectionCellFor(_ date: Date) -> ASCellNode? {
        if let value = self.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).first {
            let dataImage: UIImage
            let acValue: String
            if value.value == 0 {
                dataImage = Images.Media.bad.image
                acValue = Localizations.Accessibility.Evaluate.Criterion.Three.bad
            } else if value.value == 1 {
                acValue = Localizations.Accessibility.Evaluate.Criterion.Three.neutral
                dataImage = Images.Media.neutral.image
            } else {
                acValue = Localizations.Accessibility.Evaluate.Criterion.Three.good
                dataImage = Images.Media.good.image
            }
            let node = CollectibleImageNode(title: self.card.title, image: Sources.image(forType: self.card.type), data: dataImage)
            node.accessibilityValue = acValue
            return node
        }
        
        return nil
    }
}
