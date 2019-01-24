//
//  CheckInCard+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 11/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift
import IGListKit
import CloudKit
import AsyncDisplayKit

extension CheckInCard: Editable {
    var sectionController: ListSectionController {
        return CheckInEditableSection(card: self.card)
    }
    
    var canSave: Bool {
        if self.card.title == "" {
            return false
        }
        
        return true
    }
}

extension CheckInCard: Mergeable {
    var mergeableSectionController: ListSectionController {
        return CheckInMergeSection(card: self.card)
    }
}

extension CheckInCard: Evaluable {
    var evaluateSectionController: ListSectionController {
        return CheckInEvaluateSection(card: self.card)
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
        var txtText = "Title,Created,'Created - Since 1970',Edited,'Edited - Since 1970',Latitude,Longitude,Street,City,State,Country\n"
        
        let sortedValues = self.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            newLine = "\(self.card.title), \(date), \(c.created.timeIntervalSince1970), \(edited), \(c.edited.timeIntervalSince1970),\(c.latitude),\(c.longitude),\(c.streetString), \(c.cityString), \(c.stateString), \(c.countryString)\n"
            
            txtText.append(newLine)
        }
        
        return txtText
    }
}

extension CheckInCard: Analytical {
    var analyticalSectionController: ListSectionController {
        return CheckInAnalyticsSection(card: self.card)
    }
}

extension CheckInCard: Collectible {
    func collectionCellFor(_ date: Date) -> ASCellNode? {
        let value = self.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).count
        if value == 0 {
            return nil
        }
        let node = CollectibleDataNode(title: self.card.title, image: Sources.image(forType: self.card.type), data: "\(value)")
        
        return node
    }
}
