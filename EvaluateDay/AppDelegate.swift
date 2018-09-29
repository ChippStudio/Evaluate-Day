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
import FBSDKCoreKit
import Branch
import Amplitude_iOS
import SwiftKeychainWrapper
import Alamofire
import SwiftyJSON

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
                                                  "sendAnaliticsPurchaceDate": Date().timeIntervalSince1970])
        
        if !UserDefaults.standard.bool(forKey: "demo") && !UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") {
            // Init App Metrica
            YMMYandexMetrica.activate(with: YMMYandexMetricaConfiguration(apiKey: yandexMetricaApiKey)!)
            let delegate = YMPYandexMetricaPush.userNotificationCenterDelegate()
            delegate.nextDelegate = self
            UNUserNotificationCenter.current().delegate = delegate
            YMPYandexMetricaPush.handleApplicationDidFinishLaunching(options: launchOptions)
            
            // Init Amplitude
            Amplitude.instance().trackingSessionEvents = true
            Amplitude.instance().initializeApiKey(amplitudaApiKey)
            
            // Init Facebook
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
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
        
        // Set quick actions
        let evaluateItem = UIApplicationShortcutItem(type: ShortcutItems.evaluate.rawValue, localizedTitle: Localizations.general.shortcut.evaluate.title, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "appQA"), userInfo: nil)
        let newCardItem = UIApplicationShortcutItem(type: ShortcutItems.new.rawValue, localizedTitle: Localizations.general.shortcut.new.title, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "newQA"), userInfo: nil)
        let activityItem = UIApplicationShortcutItem(type: ShortcutItems.activity.rawValue, localizedTitle: Localizations.general.shortcut.activity.title, localizedSubtitle: nil, icon: UIApplicationShortcutIcon(templateImageName: "userQA"), userInfo: nil)
        
        UIApplication.shared.shortcutItems = [evaluateItem, newCardItem, activityItem]
        
        // Set Notification Categories
        let evaluateAction = UNNotificationAction(identifier: "Evaluate-Action", title: Localizations.general.action.evaluate, options: .foreground)
        let analyticsAction = UNNotificationAction(identifier: "Analytics-Action", title: Localizations.general.action.analytics, options: .foreground)
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
        
        // Set view controller
        if Database.manager.application.isShowWelcome {
            self.window?.rootViewController = UIStoryboard(name: Storyboards.tab.rawValue, bundle: nil).instantiateInitialViewController()!
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
        let facebookHandler = FBSDKApplicationDelegate.sharedInstance()!.application(app, open: url, options: options)
        
        return facebookHandler || branchHandler
    }

    // MARK: - Application lifecircle
    func applicationWillResignActive(_ application: UIApplication) {
        Database.manager.appStop()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
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
        print("Did register for remote notification")
        if !UserDefaults.standard.bool(forKey: "demo") {
            YMPYandexMetricaPush.setDeviceTokenFrom(deviceToken)
        }
        try! Database.manager.app.write {
            Database.manager.application.user.deviseToken = deviceToken
        }
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("did fail register")
        print(error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("did receive remote")
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
        print("did receive in foreground app")
    }
    
    // MARK: - Respond Universal Links
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        // pass the url to the handle deep link call
        return Branch.getInstance(branchApiKey).continue(userActivity)
    }
    
    // MARK: - Quick actions
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        self.shortcutItem = ShortcutItems(rawValue: shortcutItem.type)
        self.openFromQuickAction()
        
        sendEvent(.openFromShortcut, withProperties: ["type": shortcutItem.type, "success": true])
        completionHandler(true)
    }
    
    // MARK: - Actions
    var shortcutItem: ShortcutItems?
    func openFromQuickAction() {
        if self.shortcutItem == nil {
            return
        }
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            if topController as? PasscodeViewController == nil {
                
                switch self.shortcutItem! {
                case .evaluate:
                    if let bar = topController as? UITabBarController {
                        bar.selectedIndex = 0
                        if let nav = bar.selectedViewController as? UINavigationController {
                            nav.popToRootViewController(animated: false)
                        }
                    } else {
                        let controller = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController()!
                        topController.present(controller, animated: false, completion: nil)
                    }
                case .new:
                    let controller = UIStoryboard(name: Storyboards.newCard.rawValue, bundle: nil).instantiateInitialViewController()!
                    let nav = UINavigationController(rootViewController: controller)
                    topController.present(nav, animated: false, completion: nil)
                case .activity:
                    if let bar = topController as? UITabBarController {
                        bar.selectedIndex = 1
                        if let nav = bar.selectedViewController as? UINavigationController {
                            nav.popToRootViewController(animated: false)
                        }
                    } else {
                        let controller = UIStoryboard(name: Storyboards.activity.rawValue, bundle: nil).instantiateInitialViewController()!
                        topController.present(controller, animated: false, completion: nil)
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
        
        if self.actionID! == "Evaluate-Action" || self.actionCardID == UNNotificationDefaultActionIdentifier {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                if topController as? PasscodeViewController == nil {
                    // Open Evaluate day controller
                    if let card = Database.manager.data.objects(Card.self).filter("id=%@", self.actionCardID!).first {
                        let controller = UIStoryboard(name: Storyboards.time.rawValue, bundle: nil).instantiateInitialViewController() as! TimeViewController
                        controller.card = card
                        topController.present(controller, animated: true, completion: nil)
                    }
                } else {
                    return
                }
            }
        } else if self.actionID! == "Analytics-Action" {
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                if topController as? PasscodeViewController == nil {
                    // Open card analytics view controller
                    if let card = Database.manager.data.objects(Card.self).filter("id=%@", self.actionCardID!).first {
                        // Open Evaluate day controller
                        let controller = UIStoryboard(name: Storyboards.analytics.rawValue, bundle: nil).instantiateInitialViewController() as! AnalyticsViewController
                        controller.card = card
                        let navController = UINavigationController(rootViewController: controller)
                        topController.present(navController, animated: true, completion: nil)
                    }
                } else {
                    return
                }
            }
        }
        
        self.actionCardID = nil
        self.actionID = nil
    }
    
    // MARK: - Controll locations
    private func setUserInformation() {
        let cards = Database.manager.data.objects(Card.self).filter("isDeleted=%@", false)
        let dashboards = Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@", false)
        let starts = Database.manager.app.objects(AppUsage.self)
        let voiceOver = UIAccessibilityIsVoiceOverRunning()
        let identify = AMPIdentify()
        identify.set("Pro", value: NSNumber(value: Store.current.isPro))
        identify.set("VoiceOver", value: NSNumber(value: voiceOver))
        identify.set("Cards", value: NSNumber(value: cards.count))
        identify.set("Dashboards", value: NSNumber(value: dashboards.count))
        identify.set("App Starts", value: NSNumber(value: starts.count))
        Amplitude.instance().identify(identify)
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
                content.body = Localizations.general.notification._3days
            case days10Id:
                content.body = Localizations.general.notification._10days
            case days30Id:
                content.body = Localizations.general.notification._30days
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
