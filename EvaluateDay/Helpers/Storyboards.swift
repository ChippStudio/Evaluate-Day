//
//  Storyboards.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

enum Storyboards: String {
    case split = "SplitController"
    case collection = "Collection"
    case collectionsList = "CollectionsList"
    case editCollection = "EditCollection"
    case activity = "Activity"
    case evaluate = "Evaluate"
    case analytics = "Analytics"
    case newCard = "NewCard"
    case cardSettings = "CardSettings"
    case cardMerge = "CardMerge"
    case settings = "Settings"
    case passcode = "Passcode"
    case repeatList = "Repeat"
    case selectCardList = "SelectCardList"
    case pro = "Pro"
    case onboarding = "Onboarding"
    case web = "Web"
    case selectMap = "SelectMap"
    case map = "Map"
    case phrases = "Phrases"
    case list = "List"
    case entry = "Entry"
    case entriesList = "EntriesList"
    case share = "Share"
    case photo = "Photo"
    case analyticsPreview = "AnalyticsPreview"
    case reorderCollections = "ReorderCollections"
    case reorderCards = "ReorderCards"
    case numbersList = "NumbersList"
    case colorsList = "ColorsList"
    case marksList = "MarksList"
    case locationsList = "LocationsList"
    case journalGallery = "JournalGallery"
    case text = "Text"
    case number = "Number"
}

extension UIStoryboard {
    static func controller(in storyboard: Storyboards, for identifier: String? = nil) -> UIViewController {
        if identifier == nil {
            return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateInitialViewController()!
        } else {
            return UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: identifier!)
        }
    }
}
