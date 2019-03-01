//
//  LocationValue+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 11/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import RealmSwift
import CloudKit

extension LocationValue: CloudKitSyncable {
    func record(zoneID: CKRecordZone.ID) -> CKRecord? {
        let recordId = CKRecord.ID(recordName: self.id, zoneID: zoneID)
        let record = CKRecord(recordType: "LocationValue", recordID: recordId)
        record.setObject(self.owner as CKRecordValue, forKey: "owner")
        record.setObject(self.created as CKRecordValue, forKey: "created")
        record.setObject(self.edited as CKRecordValue, forKey: "edited")
        record.setObject(self.latitude as CKRecordValue, forKey: "latitude")
        record.setObject(self.longitude as CKRecordValue, forKey: "longitude")
        if self.city != nil {
            record.setObject(self.city! as CKRecordValue, forKey: "city")
        }
        if self.country != nil {
            record.setObject(self.country! as CKRecordValue, forKey: "country")
        }
        if self.state != nil {
            record.setObject(self.state! as CKRecordValue, forKey: "state")
        }
        if self.street != nil {
            record.setObject(self.street! as CKRecordValue, forKey: "street")
        }
        return record
    }
    
    static func object(record: CKRecord) -> LocationValue? {
        let locationValue = LocationValue()
        locationValue.id = record.recordID.recordName
        locationValue.owner = record.object(forKey: "owner") as! String
        locationValue.created = record.object(forKey: "created") as! Date
        locationValue.edited = record.object(forKey: "edited") as! Date
        
        locationValue.latitude = record.object(forKey: "latitude") as! Double
        locationValue.longitude = record.object(forKey: "longitude") as! Double
        
        locationValue.city = record.object(forKey: "city") as? String
        locationValue.country = record.object(forKey: "country") as? String
        locationValue.state = record.object(forKey: "state") as? String
        locationValue.street = record.object(forKey: "street") as? String
        
        return locationValue
    }
    
    typealias CloudKitSyncable = LocationValue
}
