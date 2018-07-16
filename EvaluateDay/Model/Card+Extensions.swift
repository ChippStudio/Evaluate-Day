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
    static func object(record: CKRecord) -> Card? {
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
        
        // Specific card type
        switch card.type {
        case .color: ()
        case .checkIn: ()
        case .phrase: ()
        case .criterionHundred:
            let criterionCard = card.data as! CriterionHundredCard
            criterionCard.positive = record.object(forKey: "positive") as! Bool
        case .criterionTen:
            let criterionCard = card.data as! CriterionTenCard
            criterionCard.positive = record.object(forKey: "positive") as! Bool
        case .criterionThree:
            let criterionCard = card.data as! CriterionThreeCard
            criterionCard.positive = record.object(forKey: "positive") as! Bool
        case .counter:
            let counterCard = card.data as! CounterCard
            counterCard.step = record.object(forKey: "step") as! Double
            counterCard.isSum = record.object(forKey: "sum") as! Bool
            counterCard.startValue = record.object(forKey: "start") as! Double
        case .habit:
            let habitCard = card.data as! HabitCard
            habitCard.multiple = record.object(forKey: "multiple") as! Bool
            // New in iCloud model. May be nil if data from older model version
            if let neg = record.object(forKey: "negative") as? Bool {
                habitCard.negative = neg
            } else {
                habitCard.negative = false
            }
        case .tracker: ()
        case .list: ()
        case .goal:
            let goalCard = card.data as! GoalCard
            goalCard.step = record.object(forKey: "step") as! Double
            goalCard.isSum = record.object(forKey: "sum") as! Bool
            goalCard.startValue = record.object(forKey: "start") as! Double
            goalCard.goalValue = record.object(forKey: "goal") as! Double
        case .journal: ()
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
        case .color:()
        case .checkIn: ()
        case .phrase: ()
        case .criterionHundred:
            let data = self.data as! CriterionHundredCard
            record.setObject(data.positive as CKRecordValue, forKey: "positive")
        case .criterionTen:
            let data = self.data as! CriterionTenCard
            record.setObject(data.positive as CKRecordValue, forKey: "positive")
        case .criterionThree:
            let data = self.data as! CriterionThreeCard
            record.setObject(data.positive as CKRecordValue, forKey: "positive")
        case .counter:
            let data = self.data as! CounterCard
            record.setObject(data.step as CKRecordValue, forKey: "step")
            record.setObject(data.isSum as CKRecordValue, forKey: "sum")
            record.setObject(data.startValue as CKRecordValue, forKey: "start")
        case .habit:
            let data = self.data as! HabitCard
            record.setObject(data.multiple as CKRecordValue, forKey: "multiple")
            record.setObject(data.negative as CKRecordValue, forKey: "negative")
        case .tracker: ()
        case .list: ()
        case .goal:
            let data = self.data as! GoalCard
            record.setObject(data.step as CKRecordValue, forKey: "step")
            record.setObject(data.isSum as CKRecordValue, forKey: "sum")
            record.setObject(data.startValue as CKRecordValue, forKey: "start")
            record.setObject(data.goalValue as CKRecordValue, forKey: "goal")
        case .journal: ()
        default: ()
        }
        
        return record
    }
    
    typealias CloudKitSyncable = Card
}
