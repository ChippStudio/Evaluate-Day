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

extension CriterionValue: CloudKitSyncable {
    func record(zoneID: CKRecordZoneID) -> CKRecord? {
        let recordId = CKRecordID(recordName: self.id, zoneID: zoneID)
        let record = CKRecord(recordType: "CriterionValue", recordID: recordId)
        record.setObject(self.created as CKRecordValue, forKey: "created")
        record.setObject(self.edited as CKRecordValue, forKey: "edited")
        record.setObject(self.value as CKRecordValue, forKey: "value")
        return record
    }
    
    static func object(record: CKRecord) -> Object? {
        let criterionValue = CriterionValue()
        criterionValue.id = record.recordID.recordName
        criterionValue.created = record.object(forKey: "created") as! Date
        criterionValue.edited = record.object(forKey: "edited") as! Date
        criterionValue.value = record.object(forKey: "value") as! Int
        return criterionValue
    }
}
