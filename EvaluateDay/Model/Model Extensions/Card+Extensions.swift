//
//  Card+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 06/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit
import CloudKit
import RealmSwift

extension Card: CloudKitSyncable {
    static func object(record: CKRecord) -> Object? {
        let card = Card()
        card.id = record.recordID.recordName
        card.title = record.object(forKey: "title") as! String
        card.subtitle = record.object(forKey: "subtitle") as! String
        card.created = record.object(forKey: "created") as! Date
        card.edited = record.object(forKey: "edited") as! Date
        card.order = record.object(forKey: "order") as! Int
        card.archived = record.object(forKey: "archived") as! Bool
        card.archivedDate = record.object(forKey: "archivedDate") as? Date
        if let cardType = CardType(rawValue: record.object(forKey: "type") as! Int) {
            card.type = cardType
        } else {
            card.typeRaw = record.object(forKey: "type") as! Int
        }
        let values = record.object(forKey: "values") as! [String]
        
        // Specific card type
        switch card.type {
        case .color:
            for v in values {
                // Get object from realm
                if let value = Database.manager.data.objects(ColorValue.self).filter("id=%@", v).first {
                    (card.data as! ColorCard).values.append(value)
                }
            }
        case .criterionHundred:
            let criterionCard = card.data as! CriterionHundredCard
            criterionCard.positive = record.object(forKey: "positive") as! Bool
            for v in values {
                // Get object from realm
                if let value = Database.manager.data.objects(CriterionValue.self).filter("id=%@", v).first {
                    (card.data as! CriterionHundredCard).values.append(value)
                }
            }
        default:()
        }
        
        return card
    }
    
    func record(zoneID: CKRecordZoneID) -> CKRecord? {
        let recordId = CKRecordID(recordName: self.id, zoneID: zoneID)
        let record = CKRecord(recordType: "Card", recordID: recordId)
        record.setObject(self.title as CKRecordValue, forKey: "title")
        record.setObject(self.subtitle as CKRecordValue, forKey: "subtitle")
        record.setObject(self.created as CKRecordValue, forKey: "created")
        record.setObject(self.edited as CKRecordValue, forKey: "edited")
        record.setObject(self.order as CKRecordValue, forKey: "order")
        record.setObject(self.archived as CKRecordValue, forKey: "archived")
        if self.archivedDate != nil {
            record.setObject(self.archivedDate! as CKRecordValue, forKey: "archivedDate")
        }
        record.setObject(self.typeRaw as CKRecordValue, forKey: "type")
        
        // Set records for specific card type
        switch self.type {
        case .color:
            // Set array of colors value
            let data = self.data as! ColorCard
            var values = [String]()
            for v in data.values {
                values.append(v.id)
            }
            record.setObject(values as CKRecordValue, forKey: "values")
            
        case .criterionHundred:
            let data = self.data as! CriterionHundredCard
            record.setObject(data.positive as CKRecordValue, forKey: "positive")
            // Set array of criterion values
            var values = [String]()
            for v in data.values {
                values.append(v.id)
            }
            record.setObject(values as CKRecordValue, forKey: "values")
        default: ()
        }
        
        return record
    }
}
