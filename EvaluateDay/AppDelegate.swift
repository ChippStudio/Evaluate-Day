//
//  AppDelegate.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications
import YandexMobileMetrica
import YandexMobileMetricaPush
import Branch
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON
import Flurry_iOS_SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    var syncEngine: SyncEngine!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Danger ZONE please not release with TRUE
        UserDefaults.standard.register(defaults: ["demo": Bundle.main.object(forInfoDictionaryKey: "CSDemo") as! Bool,
                                                  "test": Bundle.main.object(forInfoDictionaryKey: "CSTest") as! Bool,
                                                  "isAddedDemoData": false,
                                                  "logPurchaseTurnOffReason": false,
                                                  "sendAnaliticsPurchaceDate": Date().timeIntervalSince1970,
                                                  Theme.darkMode.rawValue: false,
                                                  Theme.blackMode.rawValue: false])
        
        if !UserDefaults.standard.bool(forKey: "demo") && !UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") {
            // Init App Metrica
            YMMYandexMetrica.activate(with: YMMYandexMetricaConfiguration(apiKey: yandexMetricaApiKey)!)
            let delegate = YMPYandexMetricaPush.userNotificationCenterDelegate()
            delegate.nextDelegate = self
            UNUserNotificationCenter.current().delegate = delegate
            YMPYandexMetricaPush.handleApplicationDidFinishLaunching(options: launchOptions)
            
            // Init Flurry
            Flurry.startSession(flurryApiKey, with: FlurrySessionBuilder.init().withCrashReporting(true).withLogLevel(FlurryLogLevelAll))
        }
        
        // Init Database
        Database.manager.initDatabase()
        
        // Init Store
        Store.current.activate()
        
        // Activate Permissions
        Permissions.defaults.activate()
        
        // Register for remote notification
        application.registerForRemoteNotifications()
        
        // Activate Sync Engine
        self.syncEngine = SyncEngine()
        
        // Init Branch
        Branch.getInstance(branchApiKey).initSession(launchOptions: launchOptions) { (parameters, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("params: %@", parameters as? [String: AnyObject] ?? {})
            }
        }
        
        // Set Notification Categories
        let evaluateAction = UNNotificationAction(identifier: "Evaluate-Action", title: Localizations.General.Action.evaluate, options: .foreground)
        let analyticsAction = UNNotificationAction(identifier: "Analytics-Action", title: Localizations.General.Action.analytics, options: .foreground)
        let evaluateCategory = UNNotificationCategory(identifier: "EvaluateCategory-ID", actions: [evaluateAction, analyticsAction], intentIdentifiers: [], options: .allowInCarPlay)
        UNUserNotificationCenter.current().setNotificationCategories([evaluateCategory])
        
        // Set Demo Data if needed
        if UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") || UserDefaults.standard.bool(forKey: "demo") {
            if !UserDefaults.standard.bool(forKey: "isAddedDemoData") {
                Demo.make()
                try! Database.manager.app.write({
                    Database.manager.application.isShowWelcome = true
                })
                UserDefaults.standard.set(true, forKey: "isAddedDemoData")
            }
        }
        
        if Database.manager.application.isShowWelcome {
            self.window?.rootViewController = UIStoryboard(name: Storyboards.split.rawValue, bundle: nil).instantiateInitialViewController()!
            self.window?.makeKeyAndVisible()
        } else {
            self.window?.rootViewController = UIStoryboard(name: Storyboards.onboarding.rawValue, bundle: nil).instantiateInitialViewController()!
            self.window?.makeKeyAndVisible()
        }
        
        if Database.manager.application.settings.passcode {
            if self.window?.rootViewController as? PasscodeViewController == nil {
                let controller = UIStoryboard(name: Storyboards.passcode.rawValue, bundle: nil).instantiateInitialViewController() as! PasscodeViewController
                controller.firstLoad = false
                self.window?.rootViewController?.present(controller, animated: true, completion: nil)
            }
        }
        
        return true
    }
    
    // MARK: - Open URL
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let branchHandler = Branch.getInstance(branchApiKey).application(app, open: url, options: options)
        
        return branchHandler
    }

    // MARK: - Application lifecircle
    func applicationWillResignActive(_ application: UIApplication) {
        Database.manager.appStop()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Set quick actions
        let evaluateItem = UIApplicationShortcutItem(type: ShortcutItems.evaluate.rawValue, localizedTitle: Localizations.General.Shortcut.Evaluate.title, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "cardQA"), userInfo: nil)
        let activityItem = UIApplicationShortcutItem(type: ShortcutItems.activity.rawValue, localizedTitle: Localizations.General.Shortcut.Activity.title, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "userQA"), userInfo: nil)
        
        UIApplication.shared.shortcutItems = [evaluateItem, activityItem]
        
        for collection in Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@", false) {
            let cards = Database.manager.data.objects(Card.self).filter("isDeleted=%@ AND dashboard=%@", false, collection.id)
            let title = collection.title.isEmpty ? Localizations.Collection.Edit.titlePlaceholder : collection.title
            let collectionItem = UIApplicationShortcutItem(type: ShortcutItems.collection.rawValue, localizedTitle: title, localizedSubtitle: Localizations.Collection.Analytics.cards + ": " + "\(cards.count)", icon: UIApplicationShortcutIcon(templateImageName: "collectionsQA"), userInfo: ["collection": collection.id])
            UIApplication.shared.shortcutItems?.append(collectionItem)
        }
        // Present passcode controller if needed
        if Database.manager.application.settings.passcode {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                if topController as? PasscodeViewController == nil {
                    let controller = UIStoryboard(name: Storyboards.passcode.rawValue, bundle: nil).instantiateInitialViewController()!
                    topController.present(controller, animated: false, completion: nil)
                }
            }
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Database.manager.appStart()
        Store.current.recontrolPro()
        
        // Send user analitics information
        self.setUserInformation()
        
        // Control location and weather values
        self.controlLocations()
        self.controlWeathers()
        
        // Reset notifications
        self.reSetNotifications()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    // MARK: - User Notifications
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        if !UserDefaults.standard.bool(forKey: "demo") {
            YMPYandexMetricaPush.setDeviceTokenFrom(deviceToken)
        }
        try! Database.manager.app.write {
            Database.manager.application.user.deviseToken = deviceToken
        }
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)
        if notification.subscriptionID == SyncKey.zoneNotification {
            self.syncEngine.fetchDataFromCloudKit(completion: {
                completionHandler(.newData)
            })
        } else {
            if !UserDefaults.standard.bool(forKey: "demo") {
                YMPYandexMetricaPush.handleRemoteNotification(userInfo)
            }
            completionHandler(.newData)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // React for user interaction
        if let cardID = response.notification.request.content.userInfo["cardID"] as? String {
            self.actionCardID = cardID
            self.actionID = response.actionIdentifier
            self.openFromNotification()
        }
        
        if let id = response.notification.request.content.userInfo["id"] as? String {
            sendEvent(.openFromLocalNotification, withProperties: ["id": id])
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show custom UI if needed
        print("ggggggggggggggg")
    }
    
    // MARK: - Respond Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        // pass the url to the handle deep link call
        return Branch.getInstance(branchApiKey).continue(userActivity)
    }
    
    // MARK: - Quick actions
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        self.shortcutItem = ShortcutItems(rawValue: shortcutItem.type)
        if let collection = shortcutItem.userInfo?["collection"] as? String {
            self.shortcutCollectionID = collection
        }
        
        self.openFromQuickAction()
        
        sendEvent(.openFromShortcut, withProperties: ["type": shortcutItem.type, "success": true])
        completionHandler(true)
    }
    
    // MARK: - Actions
    var shortcutItem: ShortcutItems?
    var shortcutCollectionID: String?
    func openFromQuickAction() {
        if self.shortcutItem == nil {
            return
        }
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            if topController as? PasscodeViewController == nil {
                
                let split = UIStoryboard(name: Storyboards.split.rawValue, bundle: nil).instantiateInitialViewController() as! SplitController
                self.window?.rootViewController = split
                self.window?.makeKeyAndVisible()
                
                switch self.shortcutItem! {
                case .evaluate:
                    let controller = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController()!
                    split.mainController.pushViewController(controller, animated: true)
                case .activity:
                    let controller = UIStoryboard(name: Storyboards.activity.rawValue, bundle: nil).instantiateInitialViewController()!
                    split.pushSideViewController(controller)
                case .collection:
                    if self.shortcutCollectionID != nil {
                        let controller = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController() as! EvaluateViewController
                        controller.collection = self.shortcutCollectionID!
                        split.mainController.pushViewController(controller, animated: true)
                    }
                }
            } else {
                return
            }
            
            self.shortcutItem = nil
        }
    }
    
    private var actionID: String?
    private var actionCardID: String?
    func openFromNotification() {
        if self.actionID == nil || self.actionCardID == nil {
            return
        }
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            if topController as? PasscodeViewController == nil {
                
                let split = UIStoryboard(name: Storyboards.split.rawValue, bundle: nil).instantiateInitialViewController() as! SplitController
                self.window?.rootViewController = split
                self.window?.makeKeyAndVisible()
                
                if self.actionID! == "Evaluate-Action" || self.actionCardID == UNNotificationDefaultActionIdentifier {
                    // Open Evaluate day controller
                    let controller = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController() as! EvaluateViewController
                    controller.scrollToCard = self.actionCardID
                    split.mainController.pushViewController(controller, animated: true)
                } else if self.actionID! == "Analytics-Action" {
                    // Open card analytics view controller
                    if let card = Database.manager.data.objects(Card.self).filter("id=%@ AND isDeleted=%@", self.actionCardID!, false).first {
                        let analytycs = UIStoryboard(name: Storyboards.analytics.rawValue, bundle: nil).instantiateInitialViewController() as! AnalyticsViewController
                        analytycs.card = card
                        split.pushSideViewController(analytycs)
                    }
                }
            } else {
                return
            }
        }
        
        self.actionCardID = nil
        self.actionID = nil
    }
    
    // MARK: - Controll locations
    private func setUserInformation() {
//        let cards = Database.manager.data.objects(Card.self).filter("isDeleted=%@", false)
//        let dashboards = Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@", false)
//        let starts = Database.manager.app.objects(AppUsage.self)
//        let voiceOver = UIAccessibilityIsVoiceOverRunning()
        
    }
    private func controlLocations() {
        let values = Database.manager.data.objects(LocationValue.self).filter("isDeleted=%@", false)
        for v in values {
            if v.street == nil {
                v.locationInformation(completion: { (street, city, state, country) in
                    try! Database.manager.data.write {
                        v.edited = Date()
                        v.street = street
                        v.city = city
                        v.state = state
                        v.country = country
                    }
                })
            }
        }
    }
    
    private func controlWeathers() {
        let values = Database.manager.data.objects(WeatherValue.self).filter("isDeleted=%@", false)
        for v in values {
            if v.humidity == 0.0 && v.pressure == 0.0 {
                let url = "\(weatherLink)\(v.latitude),\(v.longitude),\(Int(v.created.timeIntervalSince1970))"
                let urlParams = ["units": "si", "exclude": "[hourly, daily, flags]"]
                
                Alamofire.request(url, method: .get, parameters: urlParams).responseJSON { (response) in
                    if response.error != nil {
                        print("Weather responce error - \(response.error!.localizedDescription)")
                        return
                    }
                    
                    let json = JSON(response.data!)["currently"]
                    
                    try! Database.manager.data.write {
                        v.edited = Date()
                        
                        v.temperarure = json[WeatherKey.temperature].doubleValue
                        v.apparentTemperature = json[WeatherKey.apparentTemperature].doubleValue
                        v.summary = json[WeatherKey.summary].stringValue
                        v.icon = json[WeatherKey.icon].stringValue
                        v.humidity = json[WeatherKey.humidity].doubleValue
                        v.pressure = json[WeatherKey.pressure].doubleValue
                        v.windSpeed = json[WeatherKey.windSpeed].doubleValue
                        v.cloudCover = json[WeatherKey.cloudCover].doubleValue
                    }
                }
            }
        }
    }
    
    // MARK: - Reminders notifications
    private func reSetNotifications() {
        if Permissions.defaults.notificationStatus != .authorized {
            return
        }
        
        let days3Id = "notification_3_days"
        let days10Id = "notification_10_days"
        let days30Id = "notification_30_days"
        
        let allIds = [days3Id, days10Id, days30Id]
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: allIds)
        
        for id in allIds {
            let content = UNMutableNotificationContent()
            switch id {
            case days3Id:
                content.body = Localizations.General.Notification._3days
            case days10Id:
                content.body = Localizations.General.Notification._10days
            case days30Id:
                content.body = Localizations.General.Notification._30days
            default: ()
            }
            content.sound = UNNotificationSound(named: "EvaluatePush.wav")
            content.userInfo = ["id": id]
            
            var components = DateComponents()
            switch id {
            case days3Id:
                components.day = 3
            case days10Id:
                components.day = 10
            case days30Id:
                components.day = 30
            default: ()
            }
            
            let notificationDate = Calendar.current.date(byAdding: components, to: Date())!
            let notificationComponents = Calendar.current.dateComponents([.day, .hour, .minute, .month, .year, .weekday], from: notificationDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: notificationComponents, repeats: false)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
}
