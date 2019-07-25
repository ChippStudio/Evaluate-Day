//
//  HabitCard+Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/01/2018.
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

extension HabitCard: Editable {
    var sectionController: ListSectionController {
        return HabitEditableSection(card: self.card)
    }
    
    var canSave: Bool {
        if self.card.title == "" {
            return false
        }
        
        return true
    }
}

extension HabitCard: Mergeable {
    var mergeableSectionController: ListSectionController {
        return HabitMergeSection(card: self.card)
    }
}

extension HabitCard: Evaluable {
    var evaluateSectionController: ListSectionController {
        return HabitEvaluateSection(card: self.card)
    }
    
    func deleteValues() {
        if self.card.realm == nil {
            return
        }
        
        for value in self.values {
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
        var txtText = "Title,Subtitle,Created,'Created - Since 1970',Edited,'Edited - Since 1970',Value\n"
        
        let sortedValues = self.values.sorted(byKeyPath: "created")
        
        for c in sortedValues {
            var newLine = ""
            let date = DateFormatter.localizedString(from: c.created, dateStyle: .medium, timeStyle: .medium)
            let edited = DateFormatter.localizedString(from: c.edited, dateStyle: .medium, timeStyle: .medium)
            
            newLine = "\(self.card.title), \(self.card.subtitle), \(date), \(c.created.timeIntervalSince1970), \(edited), \(c.edited.timeIntervalSince1970), \(c.text)\n"
            
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
        case .habitMark:
            activity.title = Localizations.Siri.Shortcut.Habit.Mark.title
            attributes.contentDescription = Localizations.Siri.Shortcut.Habit.Mark.description
            
            if #available(iOS 12.0, *) {
                activity.suggestedInvocationPhrase = Localizations.Siri.Shortcut.Habit.Mark.suggest
            }
            activity.contentAttributeSet = attributes
        case .habitMarkAndComment:
            activity.title = Localizations.Siri.Shortcut.Habit.MarkAndComment.title
            attributes.contentDescription = Localizations.Siri.Shortcut.Habit.MarkAndComment.description
            
            if #available(iOS 12.0, *) {
                activity.suggestedInvocationPhrase = Localizations.Siri.Shortcut.Habit.MarkAndComment.suggest
            }
            activity.contentAttributeSet = attributes
        default:
            return nil
        }
        
        activity.userInfo = ["card": self.card.id]
        return activity
    }
    
    var suggestions: [NSUserActivity]? {
        let items: [SiriShortcutItem] = [.habitMark, .habitMarkAndComment]
        var activities = [NSUserActivity]()
        for i in items {
            if let cardActivity = self.shortcut(for: i) {
                activities.append(cardActivity)
            }
        }
        
        if activities.isEmpty {
            return nil
        }
        
        return activities
    }
}

extension HabitCard: Analytical {
    var analyticalSectionController: ListSectionController {
        return HabitAnalyticsSection(card: self.card)
    }
}

extension HabitCard: Collectible {
    func collectionCellFor(_ date: Date) -> ASCellNode? {
        let value = self.values.filter("(created >= %@) AND (created <= %@)", date.start, date.end).count
        if value == 0 {
            return nil
        }
        let node = CollectibleDataNode(title: self.card.title, image: Sources.image(forType: self.card.type), data: "\(value)")
        
        return node
    }
}
