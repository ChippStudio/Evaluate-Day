//
//  CriterionValue+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 06/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import RealmSwift
import CloudKit
import UIKit

extension NumberValue: CloudKitSyncable {
    func record(zoneID: CKRecordZone.ID) -> CKRecord? {
        let recordId = CKRecord.ID(recordName: self.id, zoneID: zoneID)
        let record = CKRecord(recordType: "NumberValue", recordID: recordId)
        record.setObject(self.owner as CKRecordValue, forKey: "owner")
        record.setObject(self.created as CKRecordValue, forKey: "created")
        record.setObject(self.edited as CKRecordValue, forKey: "edited")
        record.setObject(self.value as CKRecordValue, forKey: "value")
        return record
    }
    
    static func object(record: CKRecord) -> NumberValue? {
        let criterionValue = NumberValue()
        criterionValue.id = record.recordID.recordName
        criterionValue.owner = record.object(forKey: "owner") as! String
        criterionValue.created = record.object(forKey: "created") as! Date
        criterionValue.edited = record.object(forKey: "edited") as! Date
        criterionValue.value = record.object(forKey: "value") as! Double
        return criterionValue
    }
    
    typealias CloudKitSyncable = NumberValue
}
