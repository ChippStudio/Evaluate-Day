//
//  TextValue+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import RealmSwift
import CloudKit

extension TextValue: CloudKitSyncable {
    static func object(record: CKRecord) -> TextValue? {
        let textValue = TextValue()
        textValue.id = record.recordID.recordName
        textValue.owner = record.object(forKey: "owner") as! String
        textValue.created = record.object(forKey: "created") as! Date
        textValue.edited = record.object(forKey: "edited") as! Date
        textValue.text = record.object(forKey: "text") as! String
        return textValue
    }
    
    func record(zoneID: CKRecordZoneID) -> CKRecord? {
        let recordId = CKRecordID(recordName: self.id, zoneID: zoneID)
        let record = CKRecord(recordType: "TextValue", recordID: recordId)
        record.setObject(self.owner as CKRecordValue, forKey: "owner")
        record.setObject(self.created as CKRecordValue, forKey: "created")
        record.setObject(self.edited as CKRecordValue, forKey: "edited")
        record.setObject(self.text as CKRecordValue, forKey: "text")
        return record
    }
    
    typealias CloudKitSyncable = TextValue
}
