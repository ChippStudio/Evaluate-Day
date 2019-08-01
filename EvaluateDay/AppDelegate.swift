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
import Firebase
import Intents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    var syncEngine: SyncEngine!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
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
        }
        
        // Configure Firebase
        FirebaseApp.configure()
        
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
            self.window?.rootViewController = UIStoryboard(name: Storyboards.collection.rawValue, bundle: nil).instantiateInitialViewController()!
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
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let branchHandler = Branch.getInstance(branchApiKey).application(app, open: url, options: options)
        
        return branchHandler
    }

    // MARK: - Application lifecircle
    func applicationWillResignActive(_ application: UIApplication) {
        Database.manager.appStop()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        self.setAllIndexesAndActions()
        
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
        let notification = CKNotification(fromRemoteNotificationDictionary: userInfo)!
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
    
    // MARK: - Response User Activity
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        
        if SiriShortcutItem(rawValue: userActivity.activityType) != nil {
            self.shortcut = userActivity
            self.openFromUserActivity()
            return true
        }
        
        if userActivity.activityType == CSSearchableItemActionType {
            self.searchActivity = userActivity
            self.openFromSearch()
            return true
        }
        
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
                
                let nav = UIStoryboard(name: Storyboards.collection.rawValue, bundle: nil).instantiateInitialViewController() as! UINavigationController
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
                
                switch self.shortcutItem! {
                case .evaluate:
                    let controller = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController()!
                    nav.pushViewController(controller, animated: true)
                case .activity:
                    let controller = UIStoryboard(name: Storyboards.activity.rawValue, bundle: nil).instantiateInitialViewController()!
                    nav.pushViewController(controller, animated: true)
                case .collection:
                    if self.shortcutCollectionID != nil {
                        let controller = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController() as! EvaluateViewController
                        controller.collection = self.shortcutCollectionID!
                        nav.pushViewController(controller, animated: true)
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
                
                let nav = UIStoryboard(name: Storyboards.collection.rawValue, bundle: nil).instantiateInitialViewController() as! UINavigationController
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
                
                if self.actionID! == "Evaluate-Action" || self.actionCardID == UNNotificationDefaultActionIdentifier {
                    // Open Evaluate day controller
                    let controller = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController() as! EvaluateViewController
                    controller.scrollToCard = self.actionCardID
                    nav.pushViewController(controller, animated: true)
                } else if self.actionID! == "Analytics-Action" {
                    // Open card analytics view controller
                    if let card = Database.manager.data.objects(Card.self).filter("id=%@ AND isDeleted=%@", self.actionCardID!, false).first {
                        let analytycs = UIStoryboard(name: Storyboards.analytics.rawValue, bundle: nil).instantiateInitialViewController() as! AnalyticsViewController
                        analytycs.card = card
                        nav.pushViewController(analytycs, animated: true)
                    }
                }
            } else {
                return
            }
        }
        
        self.actionCardID = nil
        self.actionID = nil
    }
    
    private var shortcut: NSUserActivity?
    func openFromUserActivity() {
        if self.shortcut == nil {
            return
        }
        
        guard let item = SiriShortcutItem(rawValue: self.shortcut!.activityType) else {
            return
        }
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            if topController as? PasscodeViewController == nil {
                
                let nav = UIStoryboard(name: Storyboards.collection.rawValue, bundle: nil).instantiateInitialViewController() as! UINavigationController
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
                
                switch item {
                case .openAnalytics:
                    if let cardId = self.shortcut?.userInfo?["card"] as? String {
                        // Open card analytics view controller
                        if let card = Database.manager.data.objects(Card.self).filter("id=%@ AND isDeleted=%@", cardId, false).first {
                            let controller = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController() as! EvaluateViewController
                            controller.scrollToCard = card.id
                            nav.pushViewController(controller, animated: true)
                            let analytycs = UIStoryboard(name: Storyboards.analytics.rawValue, bundle: nil).instantiateInitialViewController() as! AnalyticsViewController
                            analytycs.card = card
                            nav.pushViewController(analytycs, animated: true)
                        } else {
                            if !Store.current.isPro {
                                let pro = UIStoryboard.controller(in: .pro)
                                nav.pushViewController(pro, animated: true)
                            } else {
                                self.showSyncAlert()
                            }
                        }
                    }
                case .evaluate:
                    let controller = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController() as! EvaluateViewController
                    if let cardType = CardType(rawValue: Int((self.shortcut?.userInfo?["card_type"] as? String) ?? "100") ?? 100) {
                        controller.cardType = cardType
                    }
                    
                    nav.pushViewController(controller, animated: true)
                case .collection:
                    if let collection = self.shortcut!.userInfo?["collection"] as? String {
                        let controller = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController() as! EvaluateViewController
                        controller.collection = collection
                        nav.pushViewController(controller, animated: true)
                    } else {
                        if !Store.current.isPro {
                            let pro = UIStoryboard.controller(in: .pro)
                            nav.pushViewController(pro, animated: true)
                        } else {
                            self.showSyncAlert()
                        }
                    }
                default:
                    if let card = self.shortcut?.userInfo?["card"] as? String {
                        let controller = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController() as! EvaluateViewController
                        controller.scrollToCard = card
                        if let action = SiriShortcutItem(rawValue: self.shortcut!.activityType) {
                            controller.cardAction = action
                        }
                        nav.pushViewController(controller, animated: true)
                    } else {
                        if !Store.current.isPro {
                            let pro = UIStoryboard.controller(in: .pro)
                            nav.pushViewController(pro, animated: true)
                        } else {
                            self.showSyncAlert()
                        }
                    }
                }
                
            } else {
                return
            }
        }
        
        self.shortcut = nil
    }
    
    private var searchActivity: NSUserActivity?
    func openFromSearch() {
        if self.searchActivity == nil {
            return
        }
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            if topController as? PasscodeViewController == nil {
                
                let nav = UIStoryboard(name: Storyboards.collection.rawValue, bundle: nil).instantiateInitialViewController() as! UINavigationController
                self.window?.rootViewController = nav
                self.window?.makeKeyAndVisible()
                
                // Open from search
                if let cardId = self.searchActivity?.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                    // Open card analytics view controller
                    let controller = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController() as! EvaluateViewController
                    controller.scrollToCard = cardId
                    nav.pushViewController(controller, animated: true)
                }
            } else {
                return
            }
            
            self.searchActivity = nil
        }
    }
    
    func setAllIndexesAndActions() {
        // Set quick actions
        let evaluateItem = UIApplicationShortcutItem(type: ShortcutItems.evaluate.rawValue, localizedTitle: Localizations.General.Shortcut.Evaluate.title, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "cardQA"), userInfo: nil)
        let activityItem = UIApplicationShortcutItem(type: ShortcutItems.activity.rawValue, localizedTitle: Localizations.General.Shortcut.Activity.title, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "userQA"), userInfo: nil)
        
        UIApplication.shared.shortcutItems = [evaluateItem, activityItem]
        
        for collection in Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@", false) {
            let cards = Database.manager.data.objects(Card.self).filter("isDeleted=%@ AND dashboard=%@", false, collection.id)
            let title = collection.title.isEmpty ? Localizations.Collection.Edit.titlePlaceholder : collection.title
            let collectionItem = UIApplicationShortcutItem(type: ShortcutItems.collection.rawValue, localizedTitle: title, localizedSubtitle: Localizations.Collection.Analytics.cards + ": " + "\(cards.count)", icon: UIApplicationShortcutIcon(templateImageName: "collectionsQA"), userInfo: ["collection": collection.id as NSSecureCoding])
            UIApplication.shared.shortcutItems?.append(collectionItem)
        }
        
        // Set new Siri Suggestens Shortcuts
        if #available(iOS 12.0, *) {
            let cards = Database.manager.data.objects(Card.self).filter("isDeleted=%@", false)
            var suggestions = [INShortcut]()
            for card in cards {
                if let cardsSuggestions = card.data.suggestions {
                    for activity in cardsSuggestions {
                        suggestions.append(INShortcut(userActivity: activity))
                    }
                }
            }
            
            INVoiceShortcutCenter.shared.setShortcutSuggestions(suggestions)
        }
        
        // Set spotlight indexes
        var items = [CSSearchableItem]()
        for card in Database.manager.data.objects(Card.self).filter("isDeleted=%@", false) {
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            attributeSet.title = card.title
            attributeSet.contentDescription = card.subtitle
            attributeSet.contentCreationDate = card.created
            attributeSet.contentModificationDate = card.edited
            
            let item = CSSearchableItem(uniqueIdentifier: card.id, domainIdentifier: "ee.chippstudio.EvaluateDay.card", attributeSet: attributeSet)
            items.append(item)
        }
        
        CSSearchableIndex.default().indexSearchableItems(items) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    // MARK: - Show sync alert
    private func showSyncAlert() {
        let alert = UIAlertController(title: Localizations.Settings.Sync.UserActivity.Alert.title, message: Localizations.Settings.Sync.UserActivity.Alert.message, preferredStyle: .alert)
        let ok = UIAlertAction(title: Localizations.General.ok, style: .cancel, handler: nil)
        let openSettings = UIAlertAction(title: Localizations.Settings.Sync.UserActivity.Alert.openSettings, style: .default) { (_) in
            if let nav = self.window?.rootViewController as? UINavigationController {
                let settings = UIStoryboard.controller(in: .settings)
                nav.pushViewController(settings, animated: true)
                let data = UIStoryboard(name: Storyboards.settings.rawValue, bundle: nil).instantiateViewController(withIdentifier: "dataManagerSegue")
                nav.pushViewController(data, animated: true)
            }
        }
        
        alert.addAction(ok)
        alert.addAction(openSettings)
        
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Controll locations
    private func setUserInformation() {
        let cards = Database.manager.data.objects(Card.self).filter("isDeleted=%@", false)
        let collections = Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@", false)
        let starts = Database.manager.app.objects(AppUsage.self)
        let voiceOver = UIAccessibility.isVoiceOverRunning
        
        // App Metrica
        let profile = YMMMutableUserProfile()
        var profileUpdates = [YMMUserProfileUpdate]()
        
        let user = Database.manager.application.user!
        profileUpdates.append(YMMProfileAttribute.name().withValue(user.name))
        // Send only public email from profile, for feedback request
        profileUpdates.append(YMMProfileAttribute.customString("Email").withValue(user.email))
        profileUpdates.append(YMMProfileAttribute.customString("Site").withValue(user.web))
        profileUpdates.append(YMMProfileAttribute.customNumber("Cards").withValue(Double(cards.count)))
        profileUpdates.append(YMMProfileAttribute.customNumber("Collections").withValue(Double(collections.count)))
        profileUpdates.append(YMMProfileAttribute.customNumber("Starts").withValue(Double(starts.count)))
        profileUpdates.append(YMMProfileAttribute.customBool("VoiceOver").withValue(voiceOver))
        profileUpdates.append(YMMProfileAttribute.customBool("Pro").withValue(Store.current.isPro))
        
        profile.apply(from: profileUpdates)
        YMMYandexMetrica.report(profile) { (error) in
            print(error.localizedDescription)
        }
        
        // Firebase
        Firebase.Analytics.setUserProperty("\(user.name ?? "Undefine")", forName: "Name")
        Firebase.Analytics.setUserProperty("\(user.email ?? "Undefine")", forName: "Email")
        Firebase.Analytics.setUserProperty("\(user.web ?? "Undefine")", forName: "Site")
        Firebase.Analytics.setUserProperty("\(cards.count)", forName: "Cards")
        Firebase.Analytics.setUserProperty("\(collections.count)", forName: "Collection")
        Firebase.Analytics.setUserProperty("\(starts.count)", forName: "Starts")
        Firebase.Analytics.setUserProperty(voiceOver ? "true" : "false", forName: "VoiceOver")
        Firebase.Analytics.setUserProperty(Store.current.isPro ? "true" : "false", forName: "Pro")
        
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
    
    // MARK: - Controll weather
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
            content.sound = UNNotificationSound(named: convertToUNNotificationSoundName("EvaluatePush.wav"))
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

// Helper function inserted by Swift 4.2 migrator
private func convertToUNNotificationSoundName(_ input: String) -> UNNotificationSoundName {
	return UNNotificationSoundName(rawValue: input)
}
