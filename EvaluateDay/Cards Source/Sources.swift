//
//  CardsSource.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import HealthKit

final class Sources: NSObject {

    // MARK: - Variables
    var cards = [Source]()
    
    // MARK: - Init
    override init() {
        super.init()
        self.setSources()
    }
    
    // MARK: - Static functions
    static func image(forType type: CardType) -> UIImage {
        switch type {
        case .evaluate:
            return #imageLiteral(resourceName: "appIcon_white")
        case .color:
            return #imageLiteral(resourceName: "color")
        case .checkIn:
            return #imageLiteral(resourceName: "checkin")
        case .phrase:
            return #imageLiteral(resourceName: "phrase")
        case .criterionHundred:
            return #imageLiteral(resourceName: "criterionHundred")
        case .criterionTen:
            return #imageLiteral(resourceName: "criterionTen")
        case .criterionThree:
            return #imageLiteral(resourceName: "criterionThree")
        case .counter:
            return #imageLiteral(resourceName: "counter")
        case .habit:
            return #imageLiteral(resourceName: "habit")
        case .list:
            return #imageLiteral(resourceName: "listSource")
        case .goal:
            return #imageLiteral(resourceName: "goal")
        case .journal:
            return #imageLiteral(resourceName: "journal")
        case .tracker:
            return #imageLiteral(resourceName: "tracker")
        case .health:
            return #imageLiteral(resourceName: "health")
        default:
            return #imageLiteral(resourceName: "update")
        }
    }
    
    static func title(forType type: CardType) -> String {
        switch type {
        case .color:
            return Localizations.new.color.title
        case .checkIn:
            return Localizations.new.checkin.title
        case .phrase:
            return Localizations.new.phrase.title
        case .criterionHundred:
            return Localizations.new.criterionHundred.title
        case .criterionTen:
            return Localizations.new.criterionTen.title
        case .criterionThree:
            return Localizations.new.criterionThree.title
        case .counter:
            return Localizations.new.counter.title
        case .habit:
            return Localizations.new.habit.title
        case .list:
            return Localizations.new.list.title
        case .goal:
            return Localizations.new.goal.title
        case .journal:
            return Localizations.new.journal.title
        case .tracker:
            return Localizations.new.tracker.title
        case .health:
            return Localizations.new.health.title
        default:
            return "none"
        }
    }
    
    // MARK: - Private variables
    private func setSources() {
        self.cards.removeAll()
        
        self.cards.append(Source(type: .color, title: Localizations.new.color.title, subtitle: Localizations.new.color.subtitle, image: Sources.image(forType: .color)))
        self.cards.append(Source(type: .checkIn, title: Localizations.new.checkin.title, subtitle: Localizations.new.checkin.subtitle, image: Sources.image(forType: .checkIn)))
        self.cards.append(Source(type: .phrase, title: Localizations.new.phrase.title, subtitle: Localizations.new.phrase.subtitle, image: Sources.image(forType: .phrase)))
        self.cards.append(Source(type: .criterionHundred, title: Localizations.new.criterionHundred.title, subtitle: Localizations.new.criterionHundred.subtitle, image: Sources.image(forType: .criterionHundred)))
        self.cards.append(Source(type: .criterionTen, title: Localizations.new.criterionTen.title, subtitle: Localizations.new.criterionTen.subtitle, image: Sources.image(forType: .criterionTen)))
        self.cards.append(Source(type: .criterionThree, title: Localizations.new.criterionThree.title, subtitle: Localizations.new.criterionThree.subtitle, image: Sources.image(forType: .criterionThree)))
        self.cards.append(Source(type: .counter, title: Localizations.new.counter.title, subtitle: Localizations.new.counter.subtitle, image: Sources.image(forType: .counter)))
        self.cards.append(Source(type: .habit, title: Localizations.new.habit.title, subtitle: Localizations.new.habit.subtitle, image: Sources.image(forType: .habit)))
        self.cards.append(Source(type: .tracker, title: Localizations.new.tracker.title, subtitle: Localizations.new.tracker.subtitle, image: Sources.image(forType: .tracker)))
        self.cards.append(Source(type: .list, title: Localizations.new.list.title, subtitle: Localizations.new.list.subtitle, image: Sources.image(forType: .list)))
        self.cards.append(Source(type: .goal, title: Localizations.new.goal.title, subtitle: Localizations.new.goal.subtitle, image: Sources.image(forType: .goal)))
        self.cards.append(Source(type: .journal, title: Localizations.new.journal.title, subtitle: Localizations.new.journal.subtitle, image: Sources.image(forType: .journal)))
//        if HKHealthStore.isHealthDataAvailable() {
//            self.cards.append(Source(type: .health, title: Localizations.new.health.title, subtitle: Localizations.new.health.subtitle, image: Sources.image(forType: .health)))
//        }
    }
}
