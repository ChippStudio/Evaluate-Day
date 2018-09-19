//
//  HealthValue+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 14/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import CloudKit
import RealmSwift

extension HealthValue: CloudKitSyncable {
    func record(zoneID: CKRecordZoneID) -> CKRecord? {
        let recordId = CKRecordID(recordName: self.id, zoneID: zoneID)
        let record = CKRecord(recordType: "HealthValue", recordID: recordId)
        record.setObject(self.owner as CKRecordValue, forKey: "owner")
        record.setObject(self.created as CKRecordValue, forKey: "created")
        record.setObject(self.edited as CKRecordValue, forKey: "edited")
        
        // Health
        record.setObject(self.value as CKRecordValue, forKey: "value")
        if self.hkValue != nil {
            record.setObject(self.hkValue! as CKRecordValue, forKey: "hkValue")
        }
        
        return record
    }
    
    static func object(record: CKRecord) -> HealthValue? {
        let healthValue = HealthValue()
        healthValue.id = record.recordID.recordName
        healthValue.owner = record.object(forKey: "owner") as! String
        healthValue.created = record.object(forKey: "created") as! Date
        healthValue.edited = record.object(forKey: "edited") as! Date
        
        // Health
        healthValue.value = record.object(forKey: "value") as! Double
        healthValue.hkValue = record.object(forKey: "hkValue") as? String
        
        return healthValue
    }
    
    typealias CloudKitSyncable = HealthValue
}
