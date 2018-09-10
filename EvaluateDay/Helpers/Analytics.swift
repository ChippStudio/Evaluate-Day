//
//  Analytics.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import Amplitude_iOS
import YandexMobileMetrica
import FBSDKCoreKit
import FBSDKShareKit

enum Analytics: String {
    
    // MARK: - General
    case openActivity
    case openCardList
    case openShareController
    case openTimeTravel
    case openPhoto
    case reorderCards
    case openNewCardSelector
    case openEntry
    case addNewCard
    case deleteCard
    case archiveCard
    case unarchiveCard
    case openAnalytics
    case shareFromEvaluateDay
    case shareFromAnalytics
    case openFromLocalNotification
    case showAppRate
    case newDashboard
    case deleteDashboard
    
    // MARK: - Settings
    case openSettings
    case openDataManager
    case openProReview
    case openPro
    case openProMore
    case openThemes
    case openIcons
    case selectTheme
    case selectIcon
    case openNotification
    case addNewNotification
    case addCardToNotification
    case deleteNotification
    case openPasscode
    case setPasscode
    case setPasscodeDelay
    case deletePasscode
    case setWeekStart
    case setCameraRoll
    case setCelsius
    case setSounds
    case openFAQ
    case openSupport
    case openWelcomeCards
    case touchRateInAppStore
    case openAbout
    case openEvaluateDaySocial
    case shareApp
    case touchOpenSource
    case touchLegal
    case openEvaluateSite
    case openChipp
    
    // MARK: - Welcome
    case startOnboarding
    case finishOnboarding
    case onboardingSetPermission
    
    // MARK: - Flags
    case proTurnedOff
    case recieptValidationError
    
    // MARK: - Actions
    case deleteAllCards
    case deleteAllCardsInCloud
    case openFromShortcut
    
}

func sendEvent(_ category: Analytics, withProperties properties: [String: Any]?) {
    if UserDefaults.standard.bool(forKey: "demo") {
        return
    }
    
    if properties == nil {
        Amplitude.instance().logEvent(category.rawValue)
        YMMYandexMetrica.reportEvent(category.rawValue, onFailure: nil)
        FBSDKAppEvents.logEvent(category.rawValue)
    } else {
        Amplitude.instance().logEvent(category.rawValue, withEventProperties: properties)
        YMMYandexMetrica.reportEvent(category.rawValue, parameters: properties, onFailure: nil)
        FBSDKAppEvents.logEvent(category.rawValue, parameters: properties)
    }
}

func purchase(item: String?, trial: Bool, lifetime: Bool, receipt: Data) {
    
    guard let item = item else {
        return
    }
    
    if Bundle.main.object(forInfoDictionaryKey: "CSSandbox") as! Bool || UserDefaults.standard.bool(forKey: "demo") {
        return
    }
    
    let price: NSNumber = NSNumber(value: 1.0)
    var identifire: String = "Evaluate Day Pro - "
    
    if item == Store.current.monthlyProductID {
        identifire += "Montly"
    } else if item == Store.current.annuallyProductID {
        identifire += "Annualy"
    } else if item == Store.current.lifetimeProductId {
        identifire += "Lifetime"
    } else {
        return
    }
    
    // Amplitude
    let revenue = AMPRevenue()
    revenue.setProductIdentifier(identifire)
    revenue.setPrice(price)
    revenue.setRevenueType("Subscription")
    revenue.setEventProperties(["trial": trial, "lifetime": lifetime])
    revenue.setReceipt(receipt)
    Amplitude.instance().logRevenueV2(revenue)
}
