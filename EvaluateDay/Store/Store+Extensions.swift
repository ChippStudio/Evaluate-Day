//
//  Store+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/07/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import StoreKit

@available(iOS 11.2, *)
extension SKProduct {
    var introductory: String {
        var descriptionString = ""
        if let intro = self.introductoryPrice {
            print("Subscription period units \(intro.subscriptionPeriod.numberOfUnits)")
            switch intro.paymentMode {
            case .freeTrial:
                var trialDuration = ""
                switch intro.subscriptionPeriod.unit {
                case .day:
                    trialDuration = Localizations.many.day(value1: intro.subscriptionPeriod.numberOfUnits)
                case .week:
                    trialDuration = Localizations.many.week(value1: intro.subscriptionPeriod.numberOfUnits)
                case .month:
                    trialDuration = Localizations.many.month(value1: intro.subscriptionPeriod.numberOfUnits)
                case .year:
                    trialDuration = Localizations.many.year(value1: intro.subscriptionPeriod.numberOfUnits)
                }
                descriptionString = Localizations.settings.pro.subscription.introductory.trial(value1: trialDuration)
            case.payAsYouGo:
                var introDuration = ""
                var oneTime = ""
                var priceString = ""
                
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
                numberFormatter.numberStyle = NumberFormatter.Style.currency
                numberFormatter.locale = self.priceLocale
                let price = numberFormatter.string(from: intro.price)!
                
                switch intro.subscriptionPeriod.unit {
                case .day:
                    introDuration = Localizations.many.day(value1: intro.subscriptionPeriod.numberOfUnits)
                    oneTime = Localizations.many.day(value1: 0)
                case .week:
                    introDuration = Localizations.many.week(value1: intro.subscriptionPeriod.numberOfUnits)
                    oneTime = Localizations.many.week(value1: 0)
                case .month:
                    introDuration = Localizations.many.month(value1: intro.subscriptionPeriod.numberOfUnits)
                    oneTime = Localizations.many.month(value1: 0)
                case .year:
                    introDuration = Localizations.many.year(value1: intro.subscriptionPeriod.numberOfUnits)
                    oneTime = Localizations.many.year(value1: 0)
                }
                priceString = "\(price) / \(oneTime)"
                descriptionString = Localizations.settings.pro.subscription.introductory.start(value1: introDuration, priceString)
            case .payUpFront:
                var introDuration = ""
                var priceString = ""
                
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = NumberFormatter.Behavior.behavior10_4
                numberFormatter.numberStyle = NumberFormatter.Style.currency
                numberFormatter.locale = self.priceLocale
                let price = numberFormatter.string(from: intro.price)!
                
                switch intro.subscriptionPeriod.unit {
                case .day:
                    introDuration = Localizations.many.day(value1: intro.subscriptionPeriod.numberOfUnits)
                case .week:
                    introDuration = Localizations.many.week(value1: intro.subscriptionPeriod.numberOfUnits)
                case .month:
                    introDuration = Localizations.many.month(value1: intro.subscriptionPeriod.numberOfUnits)
                case .year:
                    introDuration = Localizations.many.year(value1: intro.subscriptionPeriod.numberOfUnits)
                }
                priceString = "\(price)"
                descriptionString = Localizations.settings.pro.subscription.introductory.start(value1: introDuration, priceString)
            }
        }
        
        return descriptionString
    }
}
