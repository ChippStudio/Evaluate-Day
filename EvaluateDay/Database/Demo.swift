//
//  Demo.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

final class Demo {
    
    // MARK: - Variables
    private let startDay = 0
    private var dashboards: (work: String, workout: String)!
    // MARK: - Init
    private init() {
        
    }
    
    // MARK: - Action
    static func make() {
        let demo = Demo()
        demo.makeDashboards()
        demo.makeHundredCriterion()
        demo.makePhrases()
        demo.makeColors()
        demo.makeThreeCriterion()
        demo.makeJournal()
        demo.makeCounter()
        demo.makeCheckIn()
        demo.makeHabit()
        demo.makeTracker()
        demo.makeList()
        demo.makeTenCriterion()
        demo.makeGoal()
        demo.makeUsageDemo()
    }
    
    // MARK: - Private actions
    private func makeDashboards() {
        let work = Dashboard()
        work.title = Localizations.demo.dashboard.work
        work.image = "dashboard-31"
        
        let workout = Dashboard()
        workout.title = Localizations.demo.dashboard.workout
        workout.image = "dashboard-19"
        workout.order = 1
        
        try! Database.manager.data.write {
            Database.manager.data.add(work)
            Database.manager.data.add(workout)
        }
        
        self.dashboards = (work.id, workout.id)
    }
    private func makeColors() {
        // Make cards
        let card = Card()
        card.title = Localizations.new.color.title
        card.subtitle = Localizations.new.color.subtitle
        card.type = .color
        card.order = Database.manager.data.objects(Card.self).count
        
        // Make data
        var values = [TextValue]()
        var components = DateComponents()
        for i in self.startDay...30 {
            components.day = -i
            if let newDate = Calendar.current.date(byAdding: components, to: Date()) {
                let value = TextValue()
                value.created = newDate
                value.text = colorsForSelection[(colorsForSelection.count - 1).random].color
                value.owner = card.id
                values.append(value)
            }
        }
        
        try! Database.manager.data.write {
            Database.manager.data.add(card)
            Database.manager.data.add(values)
        }
    }
    
    private func makeCheckIn() {
        // Make cards
        let card = Card()
        card.title = Localizations.new.checkin.title
        card.subtitle = Localizations.new.checkin.subtitle
        card.type = .checkIn
        card.order = Database.manager.data.objects(Card.self).count
        
        var values = [LocationValue]()
        var components = DateComponents()
        for (i, l) in dayLocations.enumerated() {
            components.day = -i
            if let newDate = Calendar.current.date(byAdding: components, to: Date()) {
                let value = LocationValue()
                value.created = newDate
                value.owner = card.id
                value.latitude = l.latitude
                value.longitude = l.longitude
                value.street = l.name
                value.city = l.locality
                value.state = l.area
                value.country = l.country
                values.append(value)
            }
        }
        
        try! Database.manager.data.write {
            Database.manager.data.add(card)
            Database.manager.data.add(values)
        }
    }
    
    private func makeHundredCriterion() {
        // Make cards
        let card = Card()
        card.title = Localizations.demo.criterion.hundred.title
        card.subtitle = Localizations.demo.criterion.hundred.subtitle
        card.type = .criterionHundred
        card.order = Database.manager.data.objects(Card.self).count
        card.dashboard = self.dashboards.work
        
        // Make data
        var values = [NumberValue]()
        var components = DateComponents()
        for i in self.startDay...30 {
            components.day = -i
            if let newDate = Calendar.current.date(byAdding: components, to: Date()) {
                let value = NumberValue()
                value.created = newDate
                value.value = Double(100.random)
                value.owner = card.id
                values.append(value)
            }
        }
        
        try! Database.manager.data.write {
            Database.manager.data.add(card)
            Database.manager.data.add(values)
        }
    }
    private func makeTenCriterion() {
        // Make cards
        let card = Card()
        card.title = Localizations.demo.criterion.ten.title
        card.subtitle = Localizations.demo.criterion.ten.subtitle
        card.type = .criterionTen
        card.order = Database.manager.data.objects(Card.self).count
        (card.data as! CriterionTenCard).positive = false
        card.dashboard = self.dashboards.work
        
        // Make data
        var values = [NumberValue]()
        var components = DateComponents()
        for i in self.startDay...30 {
            components.day = -i
            if let newDate = Calendar.current.date(byAdding: components, to: Date()) {
                let value = NumberValue()
                value.created = newDate
                value.value = Double(10.random)
                value.owner = card.id
                values.append(value)
            }
        }
        
        try! Database.manager.data.write {
            Database.manager.data.add(card)
            Database.manager.data.add(values)
        }
    }
    private func makeThreeCriterion() {
        // Make cards
        let card = Card()
        card.title = Localizations.demo.criterion.three.title
        card.subtitle = Localizations.demo.criterion.three.subtitle
        card.type = .criterionThree
        card.order = Database.manager.data.objects(Card.self).count
        card.dashboard = self.dashboards.work
        
        // Make data
        var values = [NumberValue]()
        var components = DateComponents()
        for i in self.startDay...30 {
            components.day = -i
            if let newDate = Calendar.current.date(byAdding: components, to: Date()) {
                let value = NumberValue()
                value.created = newDate
                value.value = Double(3.random)
                value.owner = card.id
                values.append(value)
            }
        }
        
        try! Database.manager.data.write {
            Database.manager.data.add(card)
            Database.manager.data.add(values)
        }
    }
    
    private func makePhrases() {
        let card = Card()
        card.title = Localizations.new.phrase.title
        card.subtitle = Localizations.new.phrase.subtitle
        card.type = .phrase
        card.order = Database.manager.data.objects(Card.self).count
        
        // Make data
        var values = [TextValue]()
        var components = DateComponents()
        for (i, t) in demoPhrases.enumerated() {
            components.day = -i
            if let newDate = Calendar.current.date(byAdding: components, to: Date()) {
                let value = TextValue()
                value.created = newDate
                value.text = t
                value.owner = card.id
                values.append(value)
            }
        }
        
        try! Database.manager.data.write {
            Database.manager.data.add(card)
            Database.manager.data.add(values)
        }
    }
    
    private func makeCounter() {
        let card = Card()
        card.title = Localizations.demo.counter.title
        card.subtitle = Localizations.demo.counter.subtitle
        card.type = .counter
        card.order = Database.manager.data.objects(Card.self).count
        card.dashboard = self.dashboards.work
        
        // Make data
        var values = [NumberValue]()
        var components = DateComponents()
        for i in self.startDay...30 {
            components.day = -i
            if let newDate = Calendar.current.date(byAdding: components, to: Date()) {
                let value = NumberValue()
                value.created = newDate
                value.value = Double(5.random)
                value.owner = card.id
                values.append(value)
            }
        }
        
        try! Database.manager.data.write {
            Database.manager.data.add(card)
            Database.manager.data.add(values)
        }
    }
    
    private func makeHabit() {
        let card = Card()
        card.title = Localizations.demo.habit.title
        card.subtitle = Localizations.demo.habit.subtitle
        card.type = .habit
        card.order = Database.manager.data.objects(Card.self).count
        (card.data as! HabitCard).multiple = true
        
        // Make data
        var values = [MarkValue]()
        var components = DateComponents()
        for i in self.startDay...30 {
            components.day = -i
            if let newDate = Calendar.current.date(byAdding: components, to: Date()) {
                for _ in 0...10.random {
                    let value = MarkValue()
                    value.created = newDate
                    value.text = ""
                    value.owner = card.id
                    values.append(value)
                }
            }
        }
        
        try! Database.manager.data.write {
            Database.manager.data.add(card)
            Database.manager.data.add(values)
        }
    }
    
    private func makeTracker() {
        let card = Card()
        card.title = Localizations.demo.tracker.title
        card.subtitle = Localizations.demo.tracker.subtitle
        card.type = .tracker
        card.order = Database.manager.data.objects(Card.self).count
        card.dashboard = self.dashboards.workout
        
        // Make data
        var values = [MarkValue]()
        var components = DateComponents()
        for i in self.startDay...30 {
            components.day = -i
            if let newDate = Calendar.current.date(byAdding: components, to: Date()) {
                for _ in 0...3.random {
                    let value = MarkValue()
                    value.created = newDate
                    value.text = ""
                    value.owner = card.id
                    values.append(value)
                }
            }
        }
        
        try! Database.manager.data.write {
            Database.manager.data.add(card)
            Database.manager.data.add(values)
        }
    }
    
    private func  makeList() {
        let card = Card()
        card.title = Localizations.demo.list.title
        card.subtitle = Localizations.demo.list.subtitle
        card.type = .list
        card.order = Database.manager.data.objects(Card.self).count
        
        let items = [Localizations.demo.list.steps.first, Localizations.demo.list.steps.second, Localizations.demo.list.steps.third, Localizations.demo.list.steps.fourth, Localizations.demo.list.steps.fifth]
        
        var values = [MarkValue]()
        for (i, s) in items.enumerated() {
            let value = MarkValue()
            value.text = s
            value.owner = card.id
            value.order = i
            if i == 0 || i == 1 {
                value.done = true
                value.doneDate = Date()
            }
            
            values.append(value)
        }
        
        try! Database.manager.data.write {
            Database.manager.data.add(card)
            Database.manager.data.add(values)
        }
    }
    
    private func makeGoal() {
        let card = Card()
        card.title = Localizations.demo.goal.title
        card.subtitle = Localizations.demo.goal.subtitle
        card.type = .goal
        card.order = Database.manager.data.objects(Card.self).count
        card.dashboard = self.dashboards.workout
        let goalCard = card.data as! GoalCard
        goalCard.goalValue = 80
        
        var values = [NumberValue]()
        var components = DateComponents()
        for i in self.startDay...30 {
            components.day = -i
            if let newDate = Calendar.current.date(byAdding: components, to: Date()) {
                let value = NumberValue()
                value.created = newDate
                value.value = Double(80.random)
                value.owner = card.id
                values.append(value)
            }
        }
        
        try! Database.manager.data.write {
            Database.manager.data.add(card)
            Database.manager.data.add(values)
        }
    }
    
    private func makeJournal() {
        let card = Card()
        card.title = Localizations.demo.journal.title
        card.subtitle = Localizations.demo.journal.subtitle
        card.type = .journal
        card.order = Database.manager.data.objects(Card.self).count
        
        // Make data
        var values = [TextValue]()
        var photos = [PhotoValue]()
        var locations = [LocationValue]()
        var weather = [WeatherValue]()
        var components = DateComponents()
        for (i, t) in demoEntry.enumerated() {
            components.day = -3.random
            if let newDate = Calendar.current.date(byAdding: components, to: Date()) {
                let value = TextValue()
                value.created = newDate
                value.text = t
                value.owner = card.id
                values.append(value)
                
                // set location
                let locationValue = LocationValue()
                locationValue.owner = value.id
                locationValue.created = newDate
                let loc = dayLocations[(dayLocations.count - 1).random]
                locationValue.latitude = loc.latitude
                locationValue.longitude = loc.longitude
                locationValue.street = loc.name
                locationValue.city = loc.locality
                locationValue.state = loc.area
                locationValue.country = loc.country
                locations.append(locationValue)
                
                // Set photo
                let photoValue = PhotoValue()
                photoValue.owner = value.id
                photoValue.created = newDate
                photoValue.latitude = loc.latitude
                photoValue.longitude = loc.longitude
                photoValue.image = demoPhotos[i]
                photos.append(photoValue)
                
                // Set weather
                let weatherValue = WeatherValue()
                weatherValue.created = newDate
                weatherValue.owner = value.id
                weatherValue.latitude = loc.latitude
                weatherValue.longitude = loc.longitude
                weatherValue.temperarure = 22.0
                weatherValue.apparentTemperature = 24
                weatherValue.summary = "Mostly Cloudy"
                weatherValue.icon = "partly-cloudy-day"
                weatherValue.humidity = 0.1
                weatherValue.pressure = 1010.31
                weatherValue.windSpeed = 2.1
                weatherValue.cloudCover = 0.0
                
                weather.append(weatherValue)
            }
        }
        
        try! Database.manager.data.write {
            Database.manager.data.add(card)
            Database.manager.data.add(values)
            Database.manager.data.add(photos)
            Database.manager.data.add(locations)
            Database.manager.data.add(weather)
        }
    }
    
    private func makeUsageDemo() {
        // Set user demo
        if let user = Database.manager.app.objects(User.self).first {
            try! Database.manager.app.write {
                user.name = "Konstantin Tsistjakov"
                user.email = "hello@chippstudio.ee"
                user.web = "https://chippstudio.ee"
                user.avatar = UIImagePNGRepresentation(#imageLiteral(resourceName: "me"))
            }
        }
        var usages = [AppUsage]()
        var components = DateComponents()
        let days = 50
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        
        // set usage statistics
        for i in 0...days {
            components.day = -i
            let newDate = Calendar.current.date(byAdding: components, to: Date())!
            for _ in 0...80.random {
                let newUsage = AppUsage()
                newUsage.date = newDate
                newUsage.appVersion = appVersion
                usages.append(newUsage)
            }
        }
        
        // set first start date
        let startDate = Calendar.current.date(byAdding: components, to: Date())!
        
        try! Database.manager.app.write {
            Database.manager.app.add(usages)
            Database.manager.application.firstStartDate = startDate
        }
    }
}
