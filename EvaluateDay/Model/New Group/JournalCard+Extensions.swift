//
//  JournalCard+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import RealmSwift
import IGListKit
import CloudKit
import AsyncDisplayKit
import CoreSpotlight
import CoreServices
import Intents

extension JournalCard: Editable {
    var sectionController: ListSectionController {
        return JournalEditableSection(card: self.card)
    }
    
    var canSave: Bool {
        if self.card.title == "" {
            return false
        }
        
        return true
    }
}

extension JournalCard: Mergeable {
    var mergeableSectionController: ListSectionController {
        return JournalMergeSection(card: self.card)
    }
}

extension JournalCard: Evaluable {
    var evaluateSectionController: ListSectionController {
        return JournalEvaluateSection(card: self.card)
    }
    
    func deleteValues() {
        if self.card.realm == nil {
            return
        }
        
        for value in self.values {
            if let weather = value.weather {
                weather.isDeleted = true
            }
            if let location = value.location {
                location.isDeleted = true
            }
            
            for ph in value.photos {
                ph.isDeleted = true
            }
            
            value.isDeleted = true
        }
    }
    
    func hasEvent(forDate date: Date) -> Bool {
        return !self.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).isEmpty
    }
    
    func lastEventDate() -> Date? {
        if let last = self.values.sorted(byKeyPath: "created", ascending: true).last {
            return last.created
        }
        
        return nil
    }
    
    func textExport() -> String {
        var txtText = "Title, Created, 'Created - Since 1970', Edited, 'Edited - Since 1970', Text, Latitude, Longitude, Street, City, State, Country, Temperature, Apparent Temperature, Summary, Humidity, Pressure, Wind Speed, Cloud Cover\n"
        
        let sortedValues = self.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            // set location
            var latitude = ""
            var longitude = ""
            var street = ""
            var city = ""
            var state = ""
            var country = ""
            
            if c.location != nil {
                latitude = "\(c.location!.latitude)"
                longitude = "\(c.location!.longitude)"
                street = c.location!.streetString
                city = c.location!.cityString
                state = c.location!.stateString
                country = c.location!.countryString
            }
            
            // set weather
            var temperature = ""
            var apparentTemperature = ""
            var summary = ""
            var humidity = ""
            var pressure = ""
            var windSpeed = ""
            var cloudCover = ""
            if c.weather != nil {
                temperature = "\(c.weather!.temperarure)"
                apparentTemperature = "\(c.weather!.apparentTemperature)"
                if !Database.manager.application.settings.celsius {
                    temperature = "\(String(format: "%.0f", (c.weather!.temperarure * (9/5) + 32)))"
                    apparentTemperature = "\(String(format: "%.0f", (c.weather!.apparentTemperature * (9/5) + 32)))"
                }
                summary = c.weather!.summary
                humidity = "\(c.weather!.humidity)"
                pressure = "\(c.weather!.pressure)"
                windSpeed = "\(c.weather!.windSpeed)"
                if !Locale.current.usesMetricSystem {
                    windSpeed = "\(c.weather!.windSpeed * (25/11))"
                }
                cloudCover = "\(c.weather!.cloudCover)"
            }
            
            newLine = "\(self.card.title),\(date),\(c.created.timeIntervalSince1970),\(edited),\(c.edited.timeIntervalSince1970),\(c.text),\(latitude),\(longitude),\(street), \(city), \(state), \(country), \(temperature), \(apparentTemperature), \(summary), \(humidity), \(pressure), \(windSpeed), \(cloudCover)\n"
            
            txtText.append(newLine)
        }
        
        return txtText
    }
    
    func shortcut(for item: SiriShortcutItem) -> NSUserActivity? {
        let activity = NSUserActivity(activityType: item.rawValue)
        activity.isEligibleForSearch = true
        
        if #available(iOS 12.0, *) {
            activity.persistentIdentifier = NSUserActivityPersistentIdentifier(self.card.id)
            activity.isEligibleForPrediction = true
        }
        
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        switch item {
        case .openAnalytics:
            activity.title = Localizations.Siri.Shortcut.General.Analytics.title(self.card.title)
            attributes.contentDescription = Localizations.Siri.Shortcut.General.Analytics.description
            
            if #available(iOS 12.0, *) {
                activity.suggestedInvocationPhrase = Localizations.Siri.Shortcut.General.Analytics.suggest
            }
            activity.contentAttributeSet = attributes
        case .evaluate:
            activity.title = Localizations.Siri.Shortcut.General.Evaluate.title(self.card.title)
            attributes.contentDescription = Localizations.Siri.Shortcut.General.Evaluate.description
            if #available(iOS 12.0, *) {
                activity.suggestedInvocationPhrase = Localizations.Siri.Shortcut.General.Evaluate.suggest
            }
            activity.contentAttributeSet = attributes
        default:
            return nil
        }
        
        activity.userInfo = ["card": self.card.id]
        return activity
    }
}

extension JournalCard: Analytical {
    var analyticalSectionController: ListSectionController {
        return JournalAnalyticsSection(card: self.card)
    }
}

extension JournalCard: Collectible {
    func collectionCellFor(_ date: Date) -> ASCellNode? {
        let value = self.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).count
        if value == 0 {
            return nil
        }
        let node = CollectibleDataNode(title: self.card.title, image: Sources.image(forType: self.card.type), data: "\(value)")
        
        return node
    }
}
