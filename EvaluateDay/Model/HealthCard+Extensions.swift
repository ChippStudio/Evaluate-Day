//
//  HealthCard+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 14/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import RealmSwift
import IGListKit
import CloudKit

extension HealthCard: Editable {
    var sectionController: ListSectionController {
        return HealthEditableSection(card: self.card)
    }
    
    var canSave: Bool {
        if self.card.title == "" {
            return false
        }
        
        return true
    }
}

extension HealthCard: Evaluable {
    var evaluateSectionController: ListSectionController {
         return HealthEvaluateSection(card: self.card)
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
        var txtText = "Title,Created,'Created - Since 1970',Edited,'Edited - Since 1970',Value,Type,Device,Goal\n"
        
        let sortedValues = self.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            newLine = "\(self.card.title), \(date), \(c.created.timeIntervalSince1970), \(edited), \(c.edited.timeIntervalSince1970), \(c.value), \(self.type), \(self.goal)\n"
            
            txtText.append(newLine)
        }
        
        return txtText
    }
}

extension HealthCard: Analytical {
    var analyticalSectionController: ListSectionController {
         return ListSectionController()
    }
}
