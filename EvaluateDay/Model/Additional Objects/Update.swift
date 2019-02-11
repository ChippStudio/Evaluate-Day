//
//  Update.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 26/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class Update: NSObject {
    var card: Card!
}

extension Update: Evaluable {
    
    var evaluateSectionController: ListSectionController {
        return UpdateEvaluateSection(card: self.card)
    }
    
    func deleteValues() {
        
    }
    
    func hasEvent(forDate date: Date) -> Bool {
        return false
    }
    
    func lastEventDate() -> Date? {
        return nil
    }
    
    func textExport() -> String {
        return Localizations.Update.subtitle
    }
}

extension Update: Analytical {
    var analyticalSectionController: ListSectionController {
        return ListSectionController()
    }
    
}

extension Update: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return card.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? Update {
            if object.card.title == card.title && object.card.subtitle == card.subtitle && object.card.archived == self.card.archived {
                return true
            }
        }
        
        return false
    }
}
