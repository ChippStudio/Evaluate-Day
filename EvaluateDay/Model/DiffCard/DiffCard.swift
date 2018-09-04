//
//  DiffCard.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 01/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit

class DiffCard: NSObject {
    // MARK: - Card Variables
    let id: String
    let title: String
    let subtitle: String
    let created: Date
    let edited: Date
    let order: Int
    let dashboard: String?
    let archivedDate: Date?
    let archived: Bool
    let type: CardType
    
    let data: Evaluable?
    
    // MARK: - Specific Cards Variables
    var date: Date?

    // MARK: - Criterion Hundred, Criterion Ten
    var positive: Bool!
    
    // MARK: - Counter
    var step: Double!
    var isSum: Bool!
    var startValue: Double!
    
    // MARK: - Goal
    var goalValue: Double!
    
    // MARK: - Habit
    var multiple: Bool!
    
    // MARK: - Values
    var textes = [(text: String, created: Date, isDeleted: Bool)]()
    var locations = [(latitude: Double, longitude: Double, created: Date, isDeleted: Bool)]()
    var numberValues = [(value: Double, created: Date, isDeleted: Bool)]()
    var markValues = [(text: String, done: Bool, order: Int, doneDate: Date, created: Date, isDeleted: Bool)]()
    var weatherValues = [(latitude: Double, longitude: Double, temperature: Double, created: Date, isDeleted: Bool)]()
    var photoValues = [(latitude: Double, longitude: Double, created: Date, isDeleted: Bool)]()

    // MARK: - Init
    init(card: Card) {
        // Set cards variables
        self.id = card.id
        self.title = card.title
        self.subtitle = card.subtitle
        self.created = card.created
        self.edited = card.edited
        self.order = card.order
        self.dashboard = card.dashboard
        self.archivedDate = card.archivedDate
        self.archived = card.archived
        self.type = card.type
        
        self.data = card.data
        
        super.init()
        
        // Set specific card type values
        switch self.type {
        case .color:
            if card.realm != nil {
                let sortedColors = (card.data as! ColorCard).values.sorted(byKeyPath: "created", ascending: false)
                for c in sortedColors {
                    self.textes.append((text: c.text, created: c.created, isDeleted: c.isDeleted))
                }
            }
        case .checkIn:
            if card.realm != nil {
                let sortedLocations = (card.data as! CheckInCard).values.sorted(byKeyPath: "created", ascending: false)
                for l in sortedLocations {
                    self.locations.append((latitude: l.latitude, longitude: l.longitude, created: l.created, isDeleted: l.isDeleted))
                }
            }
        case .phrase:
            if card.realm != nil {
                let sortedTexts = (card.data as! PhraseCard).values.sorted(byKeyPath: "created", ascending: false)
                for t in sortedTexts {
                    self.textes.append((text: t.text, created: t.created, isDeleted: t.isDeleted))
                }
            }
        case .criterionHundred:
            let criterionCard = card.data as! CriterionHundredCard
            self.positive = criterionCard.positive
            if card.realm != nil {
                let sortedValuaes = criterionCard.values.sorted(byKeyPath: "created", ascending: false)
                for c in sortedValuaes {
                    self.numberValues.append((value: c.value, created: c.created, isDeleted: c.isDeleted))
                }
            }
        case .criterionTen:
            let criterionCard = card.data as! CriterionTenCard
            self.positive = criterionCard.positive
            if card.realm != nil {
                let sortedValues = criterionCard.values.sorted(byKeyPath: "created", ascending: false)
                for c in sortedValues {
                    self.numberValues.append((value: c.value, created: c.created, isDeleted: c.isDeleted))
                }
            }
        case .criterionThree:
            let criterionCard = card.data as! CriterionThreeCard
            self.positive = criterionCard.positive
            if card.realm != nil {
                let sortedValues = criterionCard.values.sorted(byKeyPath: "created", ascending: false)
                for c in sortedValues {
                    self.numberValues.append((value: c.value, created: c.created, isDeleted: c.isDeleted))
                }
            }
        case .counter:
            let counterCard = card.data as! CounterCard
            self.step = counterCard.step
            self.isSum = counterCard.isSum
            self.startValue = counterCard.startValue
            if card.realm != nil {
                let sortedValues = counterCard.values.sorted(byKeyPath: "created", ascending: false)
                for c in sortedValues {
                    self.numberValues.append((value: c.value, created: c.created, isDeleted: c.isDeleted))
                }
            }
        case .habit:
            let habitCard = card.data as! HabitCard
            self.multiple = habitCard.multiple
            if card.realm != nil {
                let sortedValues = habitCard.values.sorted(byKeyPath: "created", ascending: false)
                for h in sortedValues {
                    self.markValues.append((text: h.text, done: h.done, order: h.order, doneDate: h.doneDate, created: h.created, isDeleted: h.isDeleted))
                }
            }
        case .tracker:
            let trackerCard = card.data as! TrackerCard
            if card.realm != nil {
                let sortedValues = trackerCard.values.sorted(byKeyPath: "created", ascending: false)
                for h in sortedValues {
                    self.markValues.append((text: h.text, done: h.done, order: h.order, doneDate: h.doneDate, created: h.created, isDeleted: h.isDeleted))
                }
            }
        case .list:
            let listCard = card.data as! ListCard
            if card.realm != nil {
                let sortedValues = listCard.values.sorted(byKeyPath: "created", ascending: false)
                for h in sortedValues {
                    self.markValues.append((text: h.text, done: h.done, order: h.order, doneDate: h.doneDate, created: h.created, isDeleted: h.isDeleted))
                }
            }
        case .goal:
            let goalCard = card.data as! GoalCard
            self.step = goalCard.step
            self.isSum = goalCard.isSum
            self.startValue = goalCard.startValue
            self.goalValue = goalCard.goalValue
            if card.realm != nil {
                let sortedValues = goalCard.values.sorted(byKeyPath: "created", ascending: false)
                for c in sortedValues {
                    self.numberValues.append((value: c.value, created: c.created, isDeleted: c.isDeleted))
                }
            }
        case .journal:
            let journalCard = card.data as! JournalCard
            if card.realm != nil {
                let sortedValues = journalCard.values.sorted(byKeyPath: "created", ascending: false)
                for c in sortedValues {
                    self.textes.append((text: c.text, created: c.created, isDeleted: c.isDeleted))
                    if let w = c.weather {
                        self.weatherValues.append((latitude: w.latitude, longitude: w.longitude, temperature: w.temperarure, created: w.created, isDeleted: w.isDeleted))
                    }
                    if let l = c.location {
                        self.locations.append((latitude: l.latitude, longitude: l.longitude, created: l.created, isDeleted: l.isDeleted))
                    }
                    for p in c.photos {
                        self.photoValues.append((latitude: p.latitude, longitude: p.longitude, created: p.created, isDeleted: p.isDeleted))
                    }
                }
            }
        default:
            print("This card from future, need update Evaluate Day")
        }
    }
}

extension DiffCard: ListDiffable {
    func diffIdentifier() -> NSObjectProtocol {
        return self.id as NSString
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        if let object = object as? DiffCard {
            // Control cards objects
            if object.date != self.date {
                return false
            }
            if object.title != self.title || object.subtitle != self.subtitle || object.created != self.created || object.order != self.order || object.dashboard != self.dashboard || object.archivedDate != self.archivedDate || object.archived != self.archived || object.type != self.type {
                return false
            }
            // Control specific card objects {
            switch object.type {
            case .color:
                if object.textes.count != self.textes.count {
                    return false
                } else {
                    for (i, c) in object.textes.enumerated() {
                        let selfColor = self.textes[i]
                        if c.text != selfColor.text || c.created != selfColor.created || c.isDeleted != selfColor.isDeleted {
                            return false
                        }
                    }
                }
            case .checkIn:
                if object.locations.count != self.locations.count {
                    return false
                } else {
                    for (i, l) in object.locations.enumerated() {
                        let selfLocation = self.locations[i]
                        if l.latitude != selfLocation.latitude || l.longitude != selfLocation.longitude || l.created != selfLocation.created || l.isDeleted != selfLocation.isDeleted {
                            return false
                        }
                    }
                }
            case .phrase:
                if object.textes.count != self.textes.count {
                    return false
                } else {
                    for (i, t) in object.textes.enumerated() {
                        let selfText = self.textes[i]
                        if t.text != selfText.text || t.created != selfText.created || t.isDeleted != selfText.isDeleted {
                            return false
                        }
                    }
                }
            case .criterionHundred, .criterionTen, .criterionThree:
                if object.positive != self.positive {
                    return false
                }
                
                if object.numberValues.count != self.numberValues.count {
                    return false
                } else {
                    for (i, c) in object.numberValues.enumerated() {
                        let selfValue = self.numberValues[i]
                        if c.value != selfValue.value || c.created != selfValue.created || c.isDeleted != selfValue.isDeleted {
                            return false
                        }
                    }
                }
            case .counter:
                if object.step != self.step || object.isSum != self.isSum || object.startValue != self.startValue {
                    return false
                }
                
                if object.numberValues.count != self.numberValues.count {
                    return false
                } else {
                    for (i, c) in object.numberValues.enumerated() {
                        let selfValue = self.numberValues[i]
                        if c.value != selfValue.value || c.created != selfValue.created || c.isDeleted != selfValue.isDeleted {
                            return false
                        }
                    }
                }
            case .habit:
                if object.multiple != self.multiple {
                    return false
                }
                if object.markValues.count != self.markValues.count {
                    return false
                } else {
                    for (i, h) in object.markValues.enumerated() {
                        let selfValue = self.markValues[i]
                        if h.text != selfValue.text || h.done != selfValue.done || h.order != selfValue.order || h.doneDate != selfValue.doneDate || h.created != selfValue.created || h.isDeleted != selfValue.isDeleted {
                            return false
                        }
                    }
                }
            case .tracker:
                if object.markValues.count != self.markValues.count {
                    return false
                } else {
                    for (i, h) in object.markValues.enumerated() {
                        let selfValue = self.markValues[i]
                        if h.text != selfValue.text || h.done != selfValue.done || h.order != selfValue.order || h.doneDate != selfValue.doneDate || h.created != selfValue.created || h.isDeleted != selfValue.isDeleted {
                            return false
                        }
                    }
                }
            case .list:
                if object.markValues.count != self.markValues.count {
                    return false
                } else {
                    for (i, h) in object.markValues.enumerated() {
                        let selfValue = self.markValues[i]
                        if h.text != selfValue.text || h.done != selfValue.done || h.order != selfValue.order || h.doneDate != selfValue.doneDate || h.created != selfValue.created || h.isDeleted != selfValue.isDeleted {
                            return false
                        }
                    }
                }
            case .goal:
                if object.step != self.step || object.isSum != self.isSum || object.startValue != self.startValue || object.goalValue != self.goalValue {
                    return false
                }
                
                if object.numberValues.count != self.numberValues.count {
                    return false
                } else {
                    for (i, c) in object.numberValues.enumerated() {
                        let selfValue = self.numberValues[i]
                        if c.value != selfValue.value || c.created != selfValue.created || c.isDeleted != selfValue.isDeleted {
                            return false
                        }
                    }
                }
            case .journal:
                if object.textes.count != self.textes.count {
                    return false
                } else if object.locations.count != self.locations.count {
                    return false
                } else if object.photoValues.count != self.photoValues.count {
                    return false
                } else if object.weatherValues.count != self.weatherValues.count {
                    return false
                } else {
                    for (i, t) in object.textes.enumerated() {
                        let selfText = self.textes[i]
                        if t.text != selfText.text || t.created != selfText.created || t.isDeleted != selfText.isDeleted {
                            return false
                        }
                    }
                    for (i, l) in object.locations.enumerated() {
                        let selfLocation = self.locations[i]
                        if l.latitude != selfLocation.latitude || l.longitude != selfLocation.longitude || l.created != selfLocation.created || l.isDeleted != selfLocation.isDeleted {
                            return false
                        }
                    }
                    for (i, l) in object.photoValues.enumerated() {
                        let selfPhoto = self.photoValues[i]
                        if l.latitude != selfPhoto.latitude || l.longitude != selfPhoto.longitude || l.created != selfPhoto.created || l.isDeleted != selfPhoto.isDeleted {
                            return false
                        }
                    }
                    for (i, l) in object.weatherValues.enumerated() {
                        let selfWeather = self.weatherValues[i]
                        if l.latitude != selfWeather.latitude || l.longitude != selfWeather.longitude || l.temperature != selfWeather.temperature || l.created != selfWeather.created || l.isDeleted != selfWeather.isDeleted {
                            return false
                        }
                    }
                }
            default: ()
            }
        }
        
        return true
    }
    
}
