//
//  Card.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class Card: Object {
    // General
    @objc dynamic var id = UUID.id
    @objc dynamic var isDeleted = false
    @objc dynamic var title: String = ""
    @objc dynamic var subtitle: String = ""
    @objc dynamic var created: Date = Date()
    @objc dynamic var edited: Date = Date()
    @objc dynamic var order: Int = 0
    @objc dynamic var archivedDate: Date?
    @objc dynamic var typeRaw: Int = 0
    
    @objc dynamic var archived: Bool = false {
        didSet {
            if archived {
                self.archivedDate = Date()
            } else {
                self.archivedDate = nil
            }
        }
    }
    var type: CardType {
        set {
            self.typeRaw = newValue.rawValue
            switch newValue {
            case .color:
                self.colorData = ColorCard()
                self.colorData!.card = self
            case .checkIn:
                self.checkInData = CheckInCard()
                self.checkInData!.card = self
            case .phrase:
                self.phraseData = PhraseCard()
                self.phraseData!.card = self
            case .criterionHundred:
                self.criterionHundredData = CriterionHundredCard()
                self.criterionHundredData!.card = self
            case .criterionTen:
                self.criterionTenData = CriterionTenCard()
                self.criterionTenData!.card = self
            case .criterionThree:
                self.criterionThreeData = CriterionThreeCard()
                self.criterionThreeData!.card = self
            case .counter:
                self.counterData = CounterCard()
                self.counterData!.card = self
            case .habit:
                self.habitData = HabitCard()
                self.habitData!.card = self
            case .tracker:
                self.trackerData = TrackerCard()
                self.trackerData!.card = self
            case .list:
                self.listData = ListCard()
                self.listData!.card = self
            case .goal:
                self.goalData = GoalCard()
                self.goalData!.card = self
            case .journal:
                self.journalData = JournalCard()
                self.journalData!.card = self
            default:()
            }
        }
        get {
            if let newType = CardType(rawValue: self.typeRaw) {
                return newType
            }
            
            return .undefine
        }
    }
    
    // Specific class
    @objc private dynamic var colorData: ColorCard?
    @objc private dynamic var checkInData: CheckInCard?
    @objc private dynamic var phraseData: PhraseCard?
    @objc private dynamic var criterionHundredData: CriterionHundredCard?
    @objc private dynamic var criterionTenData: CriterionTenCard?
    @objc private dynamic var criterionThreeData: CriterionThreeCard?
    @objc private dynamic var counterData: CounterCard?
    @objc private dynamic var habitData: HabitCard?
    @objc private dynamic var trackerData: TrackerCard?
    @objc private dynamic var listData: ListCard?
    @objc private dynamic var goalData: GoalCard?
    @objc private dynamic var journalData: JournalCard?
    
    // Specific card object
    var data: Evaluable {
        switch type {
        case .color:
            if self.colorData != nil {
                return self.colorData!
            }
            
            try! Database.manager.data.write {
                self.type = .color
            }
            
            return self.data
            
        case .checkIn:
            if self.checkInData != nil {
                return self.checkInData!
            }
            
            try! Database.manager.data.write {
                self.type = .checkIn
            }
            
            return self.data
            
        case .phrase:
            if self.phraseData != nil {
                return self.phraseData!
            }
            
            try! Database.manager.data.write {
                self.type = .phrase
            }
            
            return self.data
            
        case .criterionHundred:
            if self.criterionHundredData != nil {
                return self.criterionHundredData!
            }
            
            try! Database.manager.data.write {
                self.type = .criterionHundred
            }
            
            return self.data
            
        case .criterionTen:
            if self.criterionTenData != nil {
                return self.criterionTenData!
            }
            
            try! Database.manager.data.write {
                self.type = .criterionTen
            }
            
            return self.data
            
        case .criterionThree:
            if self.criterionThreeData != nil {
                return self.criterionThreeData!
            }
            
            try! Database.manager.data.write {
                self.type = .criterionThree
            }
            
            return self.data
            
        case .counter:
            if self.counterData != nil {
                return self.counterData!
            }
            
            try! Database.manager.data.write {
                self.type = .counter
            }
            
            return self.data
            
        case .habit:
            if self.habitData != nil {
                return self.habitData!
            }
            
            try! Database.manager.data.write {
                self.type = .habit
            }
            
            return self.data
        case .tracker:
            if self.trackerData != nil {
                return self.trackerData!
            }
            
            try! Database.manager.data.write {
                self.type = .tracker
            }
            
            return self.data
            
        case .list:
            if self.listData != nil {
                return self.listData!
            }
            
            try! Database.manager.data.write {
                self.type = .list
            }
            
            return self.data
            
        case .goal:
            if self.goalData != nil {
                return self.goalData!
            }
            
            try! Database.manager.data.write {
                self.type = .goal
            }
            
            return self.data
            
        case .journal:
            if self.journalData != nil {
                return self.journalData!
            }
            
            try! Database.manager.data.write {
                self.type = .journal
            }
            
            return self.data
            
        default:
            let update = Update()
            update.card = self
            return update
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

// Add new only in bottom
enum CardType: Int {
    case undefine
    case color // In App
    case checkIn // In App
    case phrase // In App
    case criterionHundred // In App
    case criterionTen // In App
    case criterionThree // In App
    case counter // In App
    case habit // In App
    case list // In App
    case goal // In App
    case journal // In App
    case evaluate // General for app image
    case tracker
    
    var string: String {
        get {
            switch self {
            case .undefine:
                return "Undefine"
            case .evaluate:
                return "Evaluate"
            case .color:
                return "Color"
            case .checkIn:
                return "Check In"
            case .phrase:
                return "Phrase"
            case .criterionHundred:
                return "Hundred (Criterion)"
            case .criterionTen:
                return "Ten (Criterion)"
            case .criterionThree:
                return "Tree (Criterion)"
            case .counter:
                return "Counter"
            case .goal:
                return "Goal"
            case .list:
                return "List"
            case .habit:
                return "Habit"
            case .journal:
                return "Journal"
            case .tracker:
                return "Tracker"
            }
        }
    }
}
