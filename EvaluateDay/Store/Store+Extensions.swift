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
                    trialDuration = Localizations.Many.day(intro.subscriptionPeriod.numberOfUnits)
                case .week:
                    trialDuration = Localizations.Many.week(intro.subscriptionPeriod.numberOfUnits)
                case .month:
                    trialDuration = Localizations.Many.month(intro.subscriptionPeriod.numberOfUnits)
                case .year:
                    trialDuration = Localizations.Many.year(intro.subscriptionPeriod.numberOfUnits)
                @unknown default:()
                }
                descriptionString = Localizations.Settings.Pro.Subscription.Introductory.trial(trialDuration)
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
                    introDuration = Localizations.Many.day(intro.subscriptionPeriod.numberOfUnits)
                    oneTime = Localizations.Many.day(0)
                case .week:
                    introDuration = Localizations.Many.week(intro.subscriptionPeriod.numberOfUnits)
                    oneTime = Localizations.Many.week(0)
                case .month:
                    introDuration = Localizations.Many.month(intro.subscriptionPeriod.numberOfUnits)
                    oneTime = Localizations.Many.month(0)
                case .year:
                    introDuration = Localizations.Many.year(intro.subscriptionPeriod.numberOfUnits)
                    oneTime = Localizations.Many.year(0)
                @unknown default:()
                }
                priceString = "\(price) / \(oneTime)"
                descriptionString = Localizations.Settings.Pro.Subscription.Introductory.start(introDuration, priceString)
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
                    introDuration = Localizations.Many.day(intro.subscriptionPeriod.numberOfUnits)
                case .week:
                    introDuration = Localizations.Many.week(intro.subscriptionPeriod.numberOfUnits)
                case .month:
                    introDuration = Localizations.Many.month(intro.subscriptionPeriod.numberOfUnits)
                case .year:
                    introDuration = Localizations.Many.year(intro.subscriptionPeriod.numberOfUnits)
                @unknown default:()
                }
                priceString = "\(price)"
                descriptionString = Localizations.Settings.Pro.Subscription.Introductory.start(introDuration, priceString)
            @unknown default:()
            }
        }
        
        return descriptionString
    }
}
