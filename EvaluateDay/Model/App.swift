//
//  App.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class App: Object {
    
    // App configuration
    @objc dynamic var user: User!
    @objc dynamic var settings: Settings!
    @objc dynamic var sync: Sync!
    var notifications = List<LocalNotification>()
    
    // In App Analytics
    @objc dynamic var isNewVersion = false
    @objc dynamic var isShowWelcome = false
    @objc dynamic var isAlreadyRateThisVersion = false
    @objc dynamic var startCount: Int = 1
    @objc dynamic var totalStartCount: Int = 1
    @objc dynamic var version: String = ""
    @objc dynamic var firstStartDate = Date()
    @objc dynamic var lastUpdateDate = Date()
    @objc dynamic var lastStartDate = Date()
    @objc dynamic var lastStopDate = Date()
}

class Sync: Object {
    /// General sync date. Update if fetch from CloudKit or save to iCloudKit have fineshed successfully
    @objc dynamic var lastSyncDate: Date?
    /// CloudKit Change token. Update after successfull fetch
    @objc dynamic var serverChangeToken: Data?
    /// Last successfull save date. Update after successfull save data to CloudKit
    @objc dynamic var lastSaveDate: Date = Date()
}

class User: Object {
    @objc dynamic var id: String = UUID.id
    @objc dynamic var name: String?
    @objc dynamic var email: String?
    @objc dynamic var web: String?
    @objc dynamic var bio: String?
    @objc dynamic var avatar: Data? // Set default
    @objc dynamic var deviseToken: Data?
    @objc dynamic var pro: Bool = false
}

class AppUsage: Object {
    @objc var date: Date = Date()
    @objc var stopDate: Date!
    @objc var appVersion: String!
}

class Settings: Object {
    @objc dynamic var enableSync: Bool = true
    @objc dynamic var weekStart: Int = 2
    @objc dynamic var cameraRoll: Bool = true
    @objc dynamic var celsius: Bool = true
    @objc dynamic var sound: Bool = true
    @objc dynamic var changeAppIcon: Bool = false
    @objc dynamic var passcode: Bool = false
    @objc dynamic var passcodeBiometric: Bool = true
    @objc dynamic var passcodePromptBiometric: Bool = true
    @objc dynamic var passcodeDelayRaw: Int = 0
    
    // Sorted cards
    @objc dynamic var cardAscending = true
    @objc dynamic var cardIsShowArchived = false
    @objc dynamic var cardSortedManually = true
    @objc dynamic var cardSortedAlphabet = false
    @objc dynamic var cardSortedDate = false
    
    var passcodeDelay: PasscodeDelay {
        set {
            self.passcodeDelayRaw = newValue.rawValue
        }
        get {
            if let newPasscodeDelay = PasscodeDelay(rawValue: self.passcodeDelayRaw) {
                return newPasscodeDelay
            }
            return .immediately
        }
    }
}

class LocalNotification: Object {
    @objc dynamic var id = UUID.id
    @objc dynamic var message: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var cardID: String?
    @objc dynamic var repeatNotification: String = "1111111"
    var localizedString: String {
        get {
            if self.repeatNotification == "0000000" {
                return Localizations.Settings.Sync.never
            }
            if self.repeatNotification == "1111111" {
                return Localizations.Settings.Notifications.New.Repeat.daily
            } else {
                // Return Days
                if self.repeatNotification == "0111110" {
                    return Localizations.Settings.Notifications.New.Repeat.weekdays
                }
                
                var localizedString = ""
                let days = Locale.current.calendar.shortStandaloneWeekdaySymbols
                for (i, d) in self.repeatNotification.enumerated() {
                    if d == "1" {
                        if localizedString != "" {
                            localizedString += ", "
                        }
                        
                        localizedString += days[i]
                    }
                }
                
                return localizedString
            }
        }
    }
}
