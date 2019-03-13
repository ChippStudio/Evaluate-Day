//
//  Analytics.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import YandexMobileMetrica

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
    case addNewCollection
    case deleteCollection
    
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
        YMMYandexMetrica.reportEvent(category.rawValue, onFailure: nil)
    } else {
        YMMYandexMetrica.reportEvent(category.rawValue, parameters: properties, onFailure: nil)
    }
}
