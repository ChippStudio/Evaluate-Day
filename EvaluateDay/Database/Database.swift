//
//  Database.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift

final class Database: NSObject {

    // MARK: - Singleton
    static let manager = Database()
    
    // MARK: - Realms
    var app: Realm { return try! Realm(configuration: appConfig) }
    var data: Realm { return try! Realm(configuration: dataConfig) }
    
    // MARK: - Object
    var application: App { return self.app.objects(App.self).first! }
    
    // MARK: - Configs
    private var appConfig: Realm.Configuration!
    private var dataConfig: Realm.Configuration!
    
    // MARK: - Keys
    private let realmKey = "realm"
    private let appRealmKey = "App"
    private let dataRealmKey = "Data"
    
    // MARK: - Migrations
    private let schemaVersion: UInt64 = 3
    private var appMigration: MigrationBlock!
    private var dataMigration: MigrationBlock!
    
    // MARK: - Init
    private override init() {
        
        super.init()
        
        let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: { _, _ in })
        Realm.Configuration.defaultConfiguration = config
        
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupKey)
        
        let appURL = container!.appendingPathComponent(appRealmKey, isDirectory: false).appendingPathExtension(realmKey)
        self.appConfig = Realm.Configuration(fileURL: appURL, schemaVersion: self.schemaVersion, migrationBlock: { (migration, oldSchemaVersion) in
            // Application Migration block
            if oldSchemaVersion < 3 {
                migration.enumerateObjects(ofType: Settings.className(), { (_, newObject) in
                    newObject!["enableSync"] = true
                })
            }
        })
        
        let dataURL = container!.appendingPathComponent(dataRealmKey, isDirectory: false).appendingPathExtension(realmKey)
        self.dataConfig = Realm.Configuration(fileURL: dataURL, schemaVersion: schemaVersion, migrationBlock: { (migration, oldSchemaVersion) in
            // Data Migration Block
            if oldSchemaVersion < 3 {
                migration.enumerateObjects(ofType: HabitCard.className(), { (_, newObject) in
                    newObject!["negative"] = false
                })
            }
        })
        
        self.configureRealms()
    }
    
    // MARK: - Private
    private func configureRealms() {
        guard let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupKey) else {
            return
        }
        
        let defaultRealmPath = try! Realm().configuration.fileURL?.path
        
        let appRealmPath = container.appendingPathComponent(appRealmKey, isDirectory: false).appendingPathExtension(realmKey).path
        let dataRealmPath = container.appendingPathComponent(dataRealmKey, isDirectory: false).appendingPathExtension(realmKey).path
        
        if !FileManager.default.fileExists(atPath: appRealmPath) {
            try! FileManager.default.copyItem(atPath: defaultRealmPath!, toPath: appRealmPath)
        }
        
        if !FileManager.default.fileExists(atPath: dataRealmPath) {
            try! FileManager.default.copyItem(atPath: defaultRealmPath!, toPath: dataRealmPath)
        }
    }
    
    // MARK: - Actions
    func initDatabase() {
        if self.app.objects(App.self).isEmpty {
            let newApp = App()
            
            if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                newApp.version = version
            }
            
            let settings = Settings()
            newApp.settings = settings
            newApp.user = User()
            
            let sync = Sync()
            var component = DateComponents()
            component.day = -5
            sync.lastSaveDate = Calendar.current.date(byAdding: component, to: Date())!
            newApp.sync = sync
            
            try! self.app.write({
                self.app.add(newApp)
            })
        }
        
        // Create new media folder if neaded
        if let documentPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupKey)?.path {
            // Custom folder path
            let mediaPath = documentPath.appending("/media")
            if !FileManager.default.fileExists(atPath: mediaPath) {
                do {
                    try FileManager.default.createDirectory(atPath: mediaPath, withIntermediateDirectories: false, attributes: nil)
                } catch {
                    print("Cant create new folder")
                }
            }
        }
    }
    
    func appStart() {
        if let app = self.app.objects(App.self).first {
            let appUsage = AppUsage()
            appUsage.appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
            
            try! self.app.write ({
                if let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                    if app.version != currentVersion {
                        app.isNewVersion = true
                        app.version = currentVersion
                        app.isAlreadyRateThisVersion = false
                        app.lastUpdateDate = Date()
                        app.startCount = 0
                    } else {
                        app.isNewVersion = false
                    }
                }
                
                app.startCount += 1
                app.totalStartCount += 1
                app.lastStartDate = Date()
                
                self.app.add(appUsage)
            })
        }
    }
    
    func appStop() {
        if let us = self.app.objects(AppUsage.self).last {
            try! self.app.write {
                us.stopDate = Date()
            }
        }
        if let app = self.app.objects(App.self).first {
            try! self.app.write({
                app.lastStopDate = Date()
            })
        }
    }
}
