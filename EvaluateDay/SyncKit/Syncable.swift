//
//  Syncable.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 31/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import RealmSwift
import CloudKit

protocol Syncable {
    // Realm
    var id: String { get set }
    var edited: Date { get set }
    var isDeleted: Bool { get set }
}

protocol CloudKitSyncable: Syncable {
    
    associatedtype CloudKitSyncable
    
    // CloudKit
    func record(zoneID: CKRecordZone.ID) -> CKRecord?
    static func object(record: CKRecord) -> CloudKitSyncable?
}
