//
//  MarkValue+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import RealmSwift
import CloudKit

extension MarkValue: CloudKitSyncable {
    static func object(record: CKRecord) -> MarkValue? {
        let markValue = MarkValue()
        markValue.id = record.recordID.recordName
        markValue.owner = record.object(forKey: "owner") as! String
        markValue.created = record.object(forKey: "created") as! Date
        markValue.edited = record.object(forKey: "edited") as! Date
        markValue.text = record.object(forKey: "text") as! String
        markValue.done = record.object(forKey: "done") as! Bool
        markValue.doneDate = record.object(forKey: "doneDate") as! Date
        markValue.order = record.object(forKey: "order") as! Int
        return markValue
    }
    
    func record(zoneID: CKRecordZone.ID) -> CKRecord? {
        let recordId = CKRecord.ID(recordName: self.id, zoneID: zoneID)
        let record = CKRecord(recordType: "MarkValue", recordID: recordId)
        record.setObject(self.owner as CKRecordValue, forKey: "owner")
        record.setObject(self.created as CKRecordValue, forKey: "created")
        record.setObject(self.edited as CKRecordValue, forKey: "edited")
        record.setObject(self.text as CKRecordValue, forKey: "text")
        record.setObject(self.done as CKRecordValue, forKey: "done")
        record.setObject(self.doneDate as CKRecordValue, forKey: "doneDate")
        record.setObject(self.order as CKRecordValue, forKey: "order")
        return record
    }
    
    typealias CloudKitSyncable = MarkValue
}
