//
//  ColorValue+Extension.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 06/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift
import CloudKit

extension ColorValue: CloudKitSyncable {
    func record(zoneID: CKRecordZoneID) -> CKRecord? {
        let recordId = CKRecordID(recordName: self.id, zoneID: zoneID)
        let record = CKRecord(recordType: "ColorValue", recordID: recordId)
        record.setObject(self.created as CKRecordValue, forKey: "created")
        record.setObject(self.edited as CKRecordValue, forKey: "edited")
        record.setObject(self.color as CKRecordValue, forKey: "color")
        return record
    }
    
    static func object(record: CKRecord) -> Object? {
        let colorValue = ColorValue()
        colorValue.id = record.recordID.recordName
        colorValue.created = record.object(forKey: "created") as! Date
        colorValue.edited = record.object(forKey: "edited") as! Date
        colorValue.color = record.object(forKey: "color") as! String
        return colorValue
    }
}
