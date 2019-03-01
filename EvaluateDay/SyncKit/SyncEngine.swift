//
//  SyncEngine.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 05/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift
import CloudKit
import SwiftKeychainWrapper

class SyncEngine {
    
    // MARK: - Public Variables
    var isSyncInProgress: Bool = false {
        willSet {
            if newValue != isSyncInProgress {
                // Show or Hide sync indicator in app
            }
        }
    }
    // MARK: - Private Variables
    private var tokens = [NotificationToken]()
    private var zoneId: CKRecordZone.ID!
    private let errorHandler = ErrorHandler()
    private var cloudChangeToken: CKServerChangeToken? {
        set {
            try! Database.manager.app.write {
                if newValue == nil {
                    Database.manager.application.sync.serverChangeToken = nil
                } else {
                    Database.manager.application.sync.serverChangeToken = NSKeyedArchiver.archivedData(withRootObject: newValue!)
                }
            }
            self.lastSyncDate = Date()
        }
        
        get {
            if let data = Database.manager.application.sync.serverChangeToken {
                return NSKeyedUnarchiver.unarchiveObject(with: data) as? CKServerChangeToken
            }
            
            return nil
        }
    }
    private var lastSaveDate: Date {
        set {
            try! Database.manager.app.write {
                Database.manager.application.sync.lastSaveDate = newValue
            }
            self.lastSyncDate = Date()
        }
        get {
            return Database.manager.application.sync.lastSaveDate
        }
    }
    private var lastSyncDate: Date? {
        set {
            try! Database.manager.app.write {
                Database.manager.application.sync.lastSyncDate = newValue
            }
        }
        get {
            return Database.manager.application.sync.lastSyncDate
        }
    }
    
    // MARK: - Init
    init() {
        
        // Check iCloud accaunt status
        CKContainer.default().accountStatus { [weak self](status, _) in
            guard let sync = self else { return }
            if status == CKAccountStatus.available {
                
                sync.createNewCustomZone(completion: {
                    sync.startSync()
                })
                
                sync.syncUser()
                
            } else {
                /// Handle when user account is not available
                print("Easy, my boy. You haven't logged into iCloud account on your device/simulator yet.")
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(sender:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive(sender:)), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    // MARK: - Public actions
    /// Manualy start sync proccess or init sync after user buy pro
    func startSync() {
        
        if !self.tokens.isEmpty {
            return
        }
        
        if self.zoneId == nil || !Store.current.isPro || !Database.manager.application.settings.enableSync {
            return
        }
        
        // Register Local Realm notification
        self.registerRealmNotifications()
        
        let syncStartDate = Date()
        // Fetch data from cloud
        self.fetchFromCloud(completion: {
            print("Fetch from server done")
            let syncStopDate = Date()
            
            print("Sync start date = \(syncStartDate)")
            print(("Sync stop date = \(syncStopDate)"))
        })
        
        // Long life operation
        self.resumeLongLivedOperationIfPossible()
        
        // Register custom zone notification
        self.subscribeZoneChanged(completion: {
            print("Zone changes subscribe done")
        })
    }
    
    func stopSync() {
        for tkn in self.tokens {
            tkn.invalidate()
        }
        
        self.tokens.removeAll()
        self.deleteSubscriptionPush()
    }
    
    /// Get all new objects from CloudKit and save in Realm
    func fetchDataFromCloudKit(completion: (() -> Void)?) {
        if self.zoneId == nil || !Store.current.isPro {
            return
        }
        self.fetchFromCloud(completion: completion)
    }
    
    /// Set objects to CloudKit
    /// Call automaticaly from Realm collection notification
    func syncObjectToCloudKit<T: Object & CloudKitSyncable>(objectsToStore: [T], objectsToDelete: [T], completion: (() -> Void)?) {
        if self.zoneId == nil || !Store.current.isPro {
            return
        }
        
        let recordsToStore = objectsToStore.map { $0.record(zoneID: self.zoneId)! }
        let recordsToDelete = objectsToDelete.map { $0.record(zoneID: self.zoneId)!.recordID }
        
        self.saveChangesToCloud(recordsToStore: recordsToStore, recordsIdsToDelete: recordsToDelete, completion: { () in
            self.cleanUp()
            completion?()
        })
    }
    
    /// Sync user information
    func syncUser() {
        CKContainer.default().fetchUserRecordID { (recordId, error) in
            guard let recordId = recordId, error == nil else {
                return
            }
            
            CKContainer.default().privateCloudDatabase.fetch(withRecordID: recordId, completionHandler: { (record, error) in
                guard let record = record, error == nil else {
                    return
                }
                
                let cloudProDate: Date? = record.object(forKey: "proStartDate") as? Date
                let cloudProDuration: Int? = record.object(forKey: "proDuration") as? Int
                
                if let proDate = KeychainWrapper.standard.integer(forKey: keychainProStart), let proDuration = KeychainWrapper.standard.integer(forKey: keychainProDuration) {
                    let date = Date(timeIntervalSince1970: TimeInterval(proDate))
                    if cloudProDate == nil && cloudProDuration == nil {
                        record.setObject(date as CKRecordValue, forKey: "proStartDate")
                        record.setObject(proDuration as CKRecordValue, forKey: "proDuration")
                        CKContainer.default().privateCloudDatabase.save(record, completionHandler: { (_, error) in
                            if error != nil {
                                print(error!.localizedDescription)
                            }
                        })
                    } else {
                        var components = DateComponents()
                        components.month = cloudProDuration
                        let validDate = Calendar.current.date(byAdding: components, to: cloudProDate!)!
                        if validDate < Date() {
                            _ = KeychainWrapper.standard.removeAllKeys()
                        } else {
                            KeychainWrapper.standard.set(Int(cloudProDate!.timeIntervalSince1970), forKey: keychainProStart)
                            KeychainWrapper.standard.set(cloudProDuration!, forKey: keychainProDuration)
                        }
                    }
                } else {
                    if cloudProDate != nil && cloudProDuration != nil {
                        var components = DateComponents()
                        components.month = cloudProDuration
                        let validDate = Calendar.current.date(byAdding: components, to: cloudProDate!)!
                        if validDate < Date() {
                            KeychainWrapper.standard.set(Int(cloudProDate!.timeIntervalSince1970), forKey: keychainProStart)
                            KeychainWrapper.standard.set(cloudProDuration!, forKey: keychainProDuration)
                        } else {
                            _ = KeychainWrapper.standard.removeAllKeys()
                        }
                    }
                }
                
                Store.current.recontrolPro()
                
            })
        }
    }
    
    // MARK: - Notifications
    @objc func applicationDidEnterBackground(sender: Notification) {
        for token in self.tokens {
            token.invalidate()
        }
        
        self.tokens.removeAll()
    }
    
    @objc func applicationDidBecomeActive(sender: Notification) {
        self.startSync()
    }

    // MARK: - Private actions
    /// Clear all objects witch mark as 'isDeleted' with out notification
    private func cleanUp() {
        // Get all objects
        let cards = Database.manager.data.objects(Card.self).filter("isDeleted=%@", true)
        let dashboards = Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@", true)
        let textes = Database.manager.data.objects(TextValue.self).filter("isDeleted=%@", true)
        let numbers = Database.manager.data.objects(NumberValue.self).filter("isDeleted=%@", true)
        let locations = Database.manager.data.objects(LocationValue.self).filter("isDeleted=%@", true)
        let marks = Database.manager.data.objects(MarkValue.self).filter("isDeleted=%@", true)
        let weathers = Database.manager.data.objects(WeatherValue.self).filter("isDeleted=%@", true)
        let photos = Database.manager.data.objects(PhotoValue.self).filter("isDeleted=%@", true)
        
        let realm = Database.manager.data
        
        if !realm.isInWriteTransaction {
            realm.beginWrite()
        }
        for card in cards {
            if let obj = card.data as? Object {
                realm.delete(obj)
            }
            realm.delete(card)
        }
        for dashboard in dashboards {
            if let card = Database.manager.data.objects(Card.self).filter("dashboard=%@", dashboard.id).first {
                card.dashboard = nil
            }
            realm.delete(dashboard)
        }
        realm.delete(textes)
        realm.delete(numbers)
        realm.delete(locations)
        realm.delete(marks)
        realm.delete(weathers)
        realm.delete(photos)
        
        try! realm.commitWrite(withoutNotifying: tokens)
    }
    
    private func registerRealmNotifications() {
        self.tokens.removeAll()
        
        self.registerRealmToken(object: Card())
        self.registerRealmToken(object: Dashboard())
        self.registerRealmToken(object: TextValue())
        self.registerRealmToken(object: NumberValue())
        self.registerRealmToken(object: LocationValue())
        self.registerRealmToken(object: MarkValue())
        self.registerRealmToken(object: WeatherValue())
        self.registerRealmToken(object: PhotoValue())
    }
    
    private func registerRealmToken<T: Object & CloudKitSyncable>(object: T) {
        DispatchQueue.main.async {
            let token = Database.manager.data.objects(T.self).observe({ (col) in
                switch col {
                case .initial(_):
                    if self.zoneId == nil || !Store.current.isPro {
                        break
                    }
                    print("\(T.self) - Initial collection")
                    let resultToStore = Database.manager.data.objects(T.self).filter("edited>=%@ AND isDeleted=%@", self.lastSaveDate, false)
                    let resultToDelete = Database.manager.data.objects(T.self).filter("isDeleted=%@", true)
                    
                    var objectsToStore = [T]()
                    var objectsToDelete = [T]()
                    
                    for o in resultToStore {
                        objectsToStore.append(o)
                    }
                    
                    for o in resultToDelete {
                        objectsToDelete.append(o)
                    }
                    
                    self.syncObjectToCloudKit(objectsToStore: objectsToStore, objectsToDelete: objectsToDelete, completion: {
                        print("\(T.self) - Initial sync done")
                    })
                    break
                case .update(let collection, deletions: _, insertions: let insertions, modifications: let modifications):

                    if self.zoneId == nil || !Store.current.isPro {
                        break
                    }
                    
                    let objectToStore = (insertions + modifications).filter { $0 < collection.count }.map { collection[$0] }.filter { !$0.isDeleted }
                    let objectToDelete = modifications.filter { $0 < collection.count }.map { collection[$0] }.filter { $0.isDeleted }
                    
                    print("objectToStore - \(objectToStore.count)")
                    print("objectToDelete - \(objectToDelete.count)")
                    
                    self.syncObjectToCloudKit(objectsToStore: objectToStore, objectsToDelete: objectToDelete, completion: {
                        print("\(T.self) - Sync Done")
                    })
                    
                case .error(_):
                    break
                }
            })
            
            // Add tokens in collection
            self.tokens.append(token)
        }
    }
    
    private func saveChangesToCloud(recordsToStore: [CKRecord], recordsIdsToDelete: [CKRecord.ID], completion: (() -> Void)?) {
        self.isSyncInProgress = true
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: recordsToStore, recordIDsToDelete: recordsIdsToDelete)
        if #available(iOS 11.0, *) {
            let config = CKOperation.Configuration()
            config.isLongLived = true
            modifyOperation.configuration = config
        } else {
            // Fallback on earlier versions
            modifyOperation.isLongLived = true
        }
        modifyOperation.savePolicy = .changedKeys
        modifyOperation.modifyRecordsCompletionBlock = { [weak self] (_, _, error) in
            guard let sync = self else { return }
            
            switch sync.errorHandler.resultType(with: error) {
            case .success:
                DispatchQueue.main.async {
                    sync.lastSaveDate = Date()
                    sync.isSyncInProgress = false
                    completion?()
                }
            case .retry(afterSeconds: let timeToWait, message: _):
                sync.errorHandler.retryOperationIfPossible(retryAfter: timeToWait, block: {
                    sync.saveChangesToCloud(recordsToStore: recordsToStore, recordsIdsToDelete: recordsIdsToDelete, completion: completion)
                })
            case .chunk:
                let chunkedRecords = recordsToStore.chunkItUp(by: 300)
                for chunk in chunkedRecords {
                    sync.saveChangesToCloud(recordsToStore: chunk, recordsIdsToDelete: recordsIdsToDelete, completion: completion)
                }
            default:
                sync.isSyncInProgress = false
                return
            }
        }
        
        CKContainer.default().privateCloudDatabase.add(modifyOperation)
    }
    
    private func fetchFromCloud(completion: (() -> Void)?) {
        guard let zone = self.zoneId else { return }
        
        self.isSyncInProgress = true
        
        let zoneChangesOptions = CKFetchRecordZoneChangesOperation.ZoneOptions()
        zoneChangesOptions.previousServerChangeToken = self.cloudChangeToken
        
        let changeOperation = CKFetchRecordZoneChangesOperation(recordZoneIDs: [zone], optionsByRecordZoneID: [zone: zoneChangesOptions])
        changeOperation.fetchAllChanges = true
        
        // Sort records
        var cards = [CKRecord]()
        var dashboards = [CKRecord]()
        var textValues = [CKRecord]()
        var criterioValues = [CKRecord]()
        var locationValues = [CKRecord]()
        var markValues = [CKRecord]()
        var photoValues = [CKRecord]()
        var weatherValues = [CKRecord]()
        
        // Deleted objects
        var deletedObjects = [Object]()
        
        changeOperation.recordChangedBlock = { record in
            // Handle record
            switch record.recordType {
            case "Card":
                cards.append(record)
            case "Dashboard":
                dashboards.append(record)
            case "TextValue":
                textValues.append(record)
            case "NumberValue":
                criterioValues.append(record)
            case "LocationValue":
                locationValues.append(record)
            case "MarkValue":
                markValues.append(record)
            case "PhotoValue":
                photoValues.append(record)
            case "WeatherValue":
                weatherValues.append(record)
            default: ()
            }
        }
        changeOperation.recordWithIDWasDeletedBlock = { record, _ in
            DispatchQueue.main.async {
                let realm = Database.manager.data
                var obj: Object! = nil
                if let o = realm.objects(Card.self).filter("id=%@", record.recordName).first {
                    obj = o
                } else if let o = realm.objects(Dashboard.self).filter("id=%@", record.recordName).first {
                    obj = o
                } else if let o = realm.objects(TextValue.self).filter("id=%@", record.recordName).first {
                    obj = o
                } else if let o = realm.objects(NumberValue.self).filter("id=%@", record.recordName).first {
                    obj = o
                } else if let o = realm.objects(LocationValue.self).filter("id=%@", record.recordName).first {
                    obj = o
                } else if let o = realm.objects(MarkValue.self).filter("id=%@", record.recordName).first {
                    obj = o
                } else if let o = realm.objects(PhotoValue.self).filter("id=%@", record.recordName).first {
                    obj = o
                } else if let o = realm.objects(WeatherValue.self).filter("id=%@", record.recordName).first {
                    obj = o
                }
                
                if obj != nil {
                    deletedObjects.append(obj)
                }
            }
        }
        changeOperation.recordZoneFetchCompletionBlock = { [weak self] (_, token, _, _, error) in
            guard let sync = self else { return }
            switch sync.errorHandler.resultType(with: error) {
            case .success:
                DispatchQueue.global(qos: .background).async {
                    // save new data in realm
                    /// Cards must be the last
                    print("CARDS - \(cards.count)")
                    print("DASHBORDS - \(dashboards.count)")
                    print("TEXTES - \(textValues.count)")
                    print("CRITERIA - \(criterioValues.count)")
                    print("LOCATIONS - \(locationValues.count)")
                    print("MARKS - \(markValues.count)")
                    print("PHOTOS - \(photoValues.count)")
                    print("WEATHERS - \(weatherValues.count)")
                    
                    var cardsObjects = [Card]()
                    var dashboardsObjects = [Dashboard]()
                    var textObjects = [TextValue]()
                    var criteriaObjects = [NumberValue]()
                    var locationsObjects = [LocationValue]()
                    var markObjects = [MarkValue]()
                    var photoObjects = [PhotoValue]()
                    var weatherObjects = [WeatherValue]()
                    
                    for value in textValues {
                        if let text = TextValue.object(record: value) {
                            textObjects.append(text)
                        }
                    }
                    
                    for value in criterioValues {
                        if let criterion = NumberValue.object(record: value) {
                            criteriaObjects.append(criterion)
                        }
                    }
                    for value in locationValues {
                        if let location = LocationValue.object(record: value) {
                            locationsObjects.append(location)
                        }
                    }
                    
                    for value in markValues {
                        if let mark = MarkValue.object(record: value) {
                            markObjects.append(mark)
                        }
                    }
                    for value in photoValues {
                        if let photo = PhotoValue.object(record: value) {
                            photoObjects.append(photo)
                        }
                    }
                    for value in weatherValues {
                        if let weather = WeatherValue.object(record: value) {
                            weatherObjects.append(weather)
                        }
                    }
                    for value in cards {
                        if let card = Card.object(record: value) {
                            cardsObjects.append(card)
                        }
                    }
                    for value in dashboards {
                        if let dashboard = Dashboard.object(record: value) {
                            dashboardsObjects.append(dashboard)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        let realm = Database.manager.data
                        if !realm.isInWriteTransaction {
                            realm.beginWrite()
                        }
                        
                        // Delete objects
                        realm.delete(deletedObjects)
                        
                        // Add objects
                        realm.add(textObjects, update: true)
                        realm.add(criteriaObjects, update: true)
                        realm.add(locationsObjects, update: true)
                        realm.add(markObjects, update: true)
                        realm.add(photoObjects, update: true)
                        realm.add(weatherObjects, update: true)
                        
                        realm.add(cardsObjects, update: true)
                        
                        realm.add(dashboardsObjects, update: true)
                        
                        try! realm.commitWrite(withoutNotifying: sync.tokens)
                        
                        sync.isSyncInProgress = false
                        
                        // save token
                        if token != nil {
                            sync.cloudChangeToken = token
                        }
                        
                        completion?()
                    }
                }
            case .retry(let timeToWait, _):
                sync.errorHandler.retryOperationIfPossible(retryAfter: timeToWait, block: {
                    sync.fetchFromCloud(completion: completion)
                })
            case .recoverableError(let reason, _):
                switch reason {
                case .changeTokenExpired:
                    /// The previousServerChangeToken value is too old and the client must re-sync from scratch
                    sync.cloudChangeToken = nil
                    sync.fetchFromCloud(completion: completion)
                default:
                    sync.isSyncInProgress = false
                    return
                }
            default:
                sync.isSyncInProgress = false
                return
            }
        }
        CKContainer.default().privateCloudDatabase.add(changeOperation)
    }
    
    private func subscribeZoneChanged(completion: (() -> Void)?) {
        let subscription = CKRecordZoneSubscription(zoneID: self.zoneId, subscriptionID: SyncKey.zoneNotification)
        let info = CKSubscription.NotificationInfo()
        info.shouldSendContentAvailable = true // Silent push
        subscription.notificationInfo = info
        CKContainer.default().privateCloudDatabase.save(subscription, completionHandler: { (_, subscriptionError) in
            if subscriptionError != nil {
                print(subscriptionError!.localizedDescription)
            } else {
                completion?()
            }
        })
    }
    
    private func deleteSubscriptionPush() {
        CKContainer.default().privateCloudDatabase.delete(withSubscriptionID: SyncKey.zoneNotification) { (_, subscriptionError) in
            if subscriptionError != nil {
                print(subscriptionError!.localizedDescription)
            }
        }
    }
    
    private func createNewCustomZone(completion: (() -> Void)?) {
        // Create custom zone if needed
        let zone = CKRecordZone(zoneName: SyncKey.customZone)
        CKContainer.default().privateCloudDatabase.save(zone, completionHandler: { [weak self] (savedZone, error) in
            guard let sync = self else { return }
            switch sync.errorHandler.resultType(with: error) {
            case .success:
                if savedZone != nil {
                    sync.zoneId = savedZone!.zoneID
                    completion?()
                }
            case .retry(afterSeconds: let timeToWait, message: _):
                sync.errorHandler.retryOperationIfPossible(retryAfter: timeToWait, block: {
                    sync.createNewCustomZone(completion: completion)
                })
            default:
                return
            }
        })
    }
}

/// Long-lived Manipulation
extension SyncEngine {
    /// The CloudKit Best Practice is out of date, now use this:
    /// https://developer.apple.com/documentation/cloudkit/ckoperation
    /// Which problem does this func solve? E.g.:
    /// 1.(Offline) You make a local change, involve a operation
    /// 2. App exits or ejected by user
    /// 3. Back to app again
    /// The operation resumes! All works like a magic!
    fileprivate func resumeLongLivedOperationIfPossible () {
        CKContainer.default().fetchAllLongLivedOperationIDs { ( opeIDs, error) in
            guard error == nil else { return }
            guard let ids = opeIDs else { return }
            for id in ids {
                CKContainer.default().fetchLongLivedOperation(withID: id, completionHandler: { (ope, error) in
                    guard error == nil else { return }
                    if let modifyOp = ope as? CKModifyRecordsOperation {
                        modifyOp.modifyRecordsCompletionBlock = { (_, _, _) in
                            print("Resume modify records success!")
                        }
                        CKContainer.default().add(modifyOp)
                    }
                })
            }
        }
    }
}
