//
//  Analytics.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import YandexMobileMetrica
import Firebase

enum Analytics: String {
    
    // MARK: - General
    case openActivity
    case openEvaluate
    case openCollections
    case openShareController
    case openPhoto
    case openGalery
    case reorderCards
    case reorderCollection
    case openNewCardSelector
    case selectNewCard
    case addNewCard
    case deleteCard
    case archiveCard
    case unarchiveCard
    case openEntry
    case openAnalytics
    case shareFromEvaluateDay
    case shareFromAnalytics
    case openFromLocalNotification
    case showAppRate
    case addNewCollection
    case deleteCollection
    case show3DTouchPreview
    
    case locationsValueList
    case marksValueList
    case colorsValueList
    case numbersValueList
    case entriesValueList
    
    // MARK: - Settings
    case openSettings
    case openDataManager
    case openProReview
    case openPro
    case openProMore
    case openIcons
    case startPay
    case donePay
    case selectIcon
    case selectDarkMode
    case selectBlackMode
    case selectLightMode
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
    case addDefaultsCards
    case subscribeNewsletter
    
    // MARK: - Flags
    case proTurnedOff
    case recieptValidationError
    
    // MARK: - Actions
    case deleteAllCards
    case deleteAllCardsInCloud
    case openFromShortcut
    case changeMainDate
    
}

func sendEvent(_ category: Analytics, withProperties properties: [String: Any]?) {
    if UserDefaults.standard.bool(forKey: "demo") {
        return
    }
    
    if properties == nil {
        YMMYandexMetrica.reportEvent(category.rawValue, onFailure: nil)
        Firebase.Analytics.logEvent(category.rawValue, parameters: nil)
    } else {
        YMMYandexMetrica.reportEvent(category.rawValue, parameters: properties, onFailure: nil)
        Firebase.Analytics.logEvent(category.rawValue, parameters: properties)
    }
}
