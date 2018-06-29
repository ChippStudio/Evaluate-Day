//
//  PhraseCard+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import RealmSwift
import IGListKit
import CloudKit

extension PhraseCard: Editable {
    var sectionController: ListSectionController {
        return PhraseEditableSection(card: self.card)
    }
    
    var canSave: Bool {
        if self.card.title == "" {
            return false
        }
        
        return true
    }
}

extension PhraseCard: Mergeable {
    var mergeableSectionController: ListSectionController {
        return PhraseMergeSection(card: self.card)
    }
}

extension PhraseCard: Evaluable {
    var evaluateSectionController: ListSectionController {
        return PhraseEvaluateSection(card: self.card)
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
        var txtText = "Title,Created,'Created - Since 1970',Edited,'Edited - Since 1970',Text\n"
        
        let sortedValues = self.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            newLine = "\(self.card.title), \(date), \(c.created.timeIntervalSince1970), \(edited), \(c.edited.timeIntervalSince1970), \(c.text)\n"
            
            txtText.append(newLine)
        }
        
        return txtText
    }
}

extension PhraseCard: Analytical {
    var analyticalSectionController: ListSectionController {
        return PhraseAnalyticsSection(card: self.card)
    }
}
