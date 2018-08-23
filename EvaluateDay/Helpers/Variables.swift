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
let collectionViewOffset: CGFloat = 20.0
let collectionViewWidthDevider: CGFloat = 2/3

// MARK: - In App URLs
let mainGroup = "group.ee.chippstudio.evaluateday"
let mediaFolder = "media"

// MARK: - URLs
let appURLString = "https://itunes.apple.com/app/id1319180010"
let subscriptionManageURL = "https://buy.itunes.apple.com/WebObjects/MZFinance.woa/wa/manageSubscriptions"
let privacyURLString = "http://evaluateday.com/privacy"
let eulaURLString = "http://evaluateday.com/terms"
let appSiteURLString = "http://evaluateday.com"

// MARK: - Mails
let feedbackMail = "support@evaluateday.com"

// MARK: - Navigation item
let largeTitleFontSize: CGFloat = 28.0

// MARK: - Limits
let cardsLimit: Int = 3
let pastDaysLimit: Int = 3

// MARK: - Cards
let cardInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)

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
let demoPhrases = [Localizations.demo.phrase.dayOne, Localizations.demo.phrase.dayTwo, Localizations.demo.phrase.dayThree, Localizations.demo.phrase.dayFour]
let defaultPhrases = [Localizations._default.data.phrase.one, Localizations._default.data.phrase.two, Localizations._default.data.phrase.three, Localizations.demo.phrase.dayOne, Localizations.demo.phrase.dayTwo, Localizations.demo.phrase.dayThree, Localizations.demo.phrase.dayFour]

// MARK: - Demo journals
let demoEntry = [Localizations.demo.journal.entryOne, Localizations.demo.journal.entryTwo, Localizations.demo.journal.entryThree, Localizations.demo.journal.entryFour]
let demoPhotos = [#imageLiteral(resourceName: "sldFirst"), #imageLiteral(resourceName: "sldSecond"), #imageLiteral(resourceName: "sldThird"), #imageLiteral(resourceName: "sldFourth")]
