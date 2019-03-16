//
//  Variables.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Constants
let maxCollectionWidth: CGFloat = 500.0
let collectionViewWidthDevider: CGFloat = 2/3

// MARK: - In App URLs
let mainGroup = "group.ee.chippstudio.evaluateday"
let mediaFolder = "media"

// MARK: - URLs
let appURLString = "https://itunes.apple.com/app/id1319180010"
let subscriptionManageURL = "https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/manageSubscriptions"
let privacyURLString = "https://evaluateday.com/privacy"
let eulaURLString = "https://evaluateday.com/terms"
let appSiteURLString = "https://evaluateday.com"

// MARK: - Mails
let feedbackMail = "support@evaluateday.com"

// MARK: - PRO
let proPlaceholder = "🔒"

// MARK: - Navigation item
let largeTitleFontSize: CGFloat = 28.0

// MARK: - Limits
let cardsLimit: Int = 10
let pastDaysLimit: Int = 3

// MARK: - Cards
let cardInsets = UIEdgeInsets(top: 70.0, left: 0.0, bottom: 0.0, right: 0.0)
let cardArchivedMark = "🔒 "

// MARK: - Demo Locations
let dayLocations: [(longitude: Double, latitude: Double, area: String, locality: String, country: String, name: String)] = [
    (longitude: 27.7373925, latitude: 59.4019616, area: "Ida-Virumaa", locality: "Sillamae", country: "Estonia", name: "Ehitajate 7–9"),
    (longitude: 26.6973616, latitude: 58.3747681, area: "Tartumaa", locality: "Tartu", country: "Estonia", name: "L. Puusepa 35–39"),
    (longitude: 26.5006558, latitude: 59.5048017, area: "Lääne-Virumaa", locality: "Viru-Nigula", country: "Estonia", name: "Koidu"),
    (longitude: 24.668769, latitude: 59.4245094, area: "Harju", locality: "Tallinn", country: "Estonia", name: "Tuuleveski"),
    (longitude: 24.4926731, latitude: 58.3790388, area: "Pärnumaa", locality: "Pärnu", country: "Estonia", name: "Mere puiestee 12"),
    (longitude: 22.4506152, latitude: 58.2422986, area: "Saaremaa", locality: "Kuressaare", country: "Estonia", name: "Sõrve tee"),
    (longitude: 26.3038885, latitude: 59.3356499, area: "Lääne-Virumaa", locality: "Rakvere vald", country: "Estonia", name: "44416"),
    (longitude: 24.792278, latitude: 58.9994293, area: "Raplamaa", locality: "Rapla", country: "Estonia", name: "Tallinna mnt"),
    (longitude: 25.542689, latitude: 58.8851079, area: "Järvamaa", locality: "Paide", country: "Estonia", name: "Lai 78A–84"),
    (longitude: 25.5586324, latitude: 58.3562108, area: "Viljandimaa", locality: "Viljandi", country: "Estonia", name: "49")]

// MARK: - Demo phrases
let demoPhrases = [Localizations.Demo.Phrase.dayOne, Localizations.Demo.Phrase.dayTwo, Localizations.Demo.Phrase.dayThree, Localizations.Demo.Phrase.dayFour]
let defaultPhrases = [Localizations.Default.Data.Phrase.one, Localizations.Default.Data.Phrase.two, Localizations.Default.Data.Phrase.three, Localizations.Demo.Phrase.dayOne, Localizations.Demo.Phrase.dayTwo, Localizations.Demo.Phrase.dayThree, Localizations.Demo.Phrase.dayFour]

// MARK: - Demo journals
let demoEntry = [Localizations.Demo.Journal.entryOne, Localizations.Demo.Journal.entryTwo, Localizations.Demo.Journal.entryThree, Localizations.Demo.Journal.entryFour]
let demoPhotos = [#imageLiteral(resourceName: "sldFirst"), #imageLiteral(resourceName: "sldSecond"), #imageLiteral(resourceName: "sldThird"), #imageLiteral(resourceName: "sldFourth")]

let colorsForSelection = [(color: "FFFFFF", name: "white"),
                          (color: "C2382B", name: "GOLDEN GATE BRIDGE"),
                          (color: "D5540B", name: "BURNT ORANGE"),
                          (color: "FFA822", name: "BRIGHT YELLOW"),
                          (color: "D6C297", name: "DARK VANILLA"),
                          (color: "2B3E4F", name: "JAPANESE INDIGO"),
                          (color: "262626", name: "RAISIN BLACK"),
                          (color: "8E42AA", name: "PURPUREUS"),
                          (color: "336271", name: "MYRTLE GREEN"),
                          (color: "1E80B7", name: "CYAN CORNFLOWER BLUE"),
                          (color: "21AF65", name: "GREEN"),
                          (color: "05A086", name: "PAOLO VERONESE GREEN"),
                          (color: "BDC3C7", name: "SILVER SAND"),
                          (color: "7F8C8D", name: "MUMMY'S TOMB"),
                          (color: "2C5037", name: "MUGHAL GREEN"),
                          (color: "59479F", name: "PLUMP PURPLE"),
                          (color: "513B2D", name: "DARK LIVER"),
                          (color: "4F2A4E", name: "PURPLE TAUPE"),
                          (color: "DB5359", name: "DARK TERRA COTTA"),
                          (color: "8FB133", name: "YELLOW-GREEN"),
                          (color: "D55B9C", name: "RASPBERRY PINK"),
                          (color: "672621", name: "LIVER"),
                          (color: "8F725F", name: "SHADOW"),
                          (color: "98ABD3", name: "WILD BLUE YONDER"),
                          (color: "374B7F", name: "PURPLE NAVY")]
