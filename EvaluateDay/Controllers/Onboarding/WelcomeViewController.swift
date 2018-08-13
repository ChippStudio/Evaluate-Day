//
//  WelcomeViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftKeychainWrapper

class WelcomeViewController: UIViewController {
    // MARK: - UI
    @IBOutlet weak var byLabel: UILabel!
    @IBOutlet weak var chippLogo: UIImageView!
    
    var nextButton = NextButton()
    
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    // MARK: - Variables
    private let slidesViewController = "slidesViewController"

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.byLabel.alpha = 0.0
        self.chippLogo.alpha = 0.0
        
        self.view.addSubview(self.nextButton)
        self.nextButton.snp.makeConstraints { (make) in
            make.height.equalTo(60.0)
            make.width.equalTo(60.0)
            make.trailing.equalTo(self.view).offset(-30.0)
            make.bottom.equalTo(self.view).offset(-20.0)
        }
        self.nextButton.addTarget(self, action: #selector(nextButtonAction(sender: )), for: .touchUpInside)
        self.nextButton.alpha = 0.0
        self.nextButton.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        
        sendEvent(.startOnboarding, withProperties: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.centerConstraint.constant = -150.0
        
        UIView.animateKeyframes(withDuration: 2.0, delay: 0.5, options: .beginFromCurrentState, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0, animations: {
                self.view.layoutIfNeeded()
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.9, animations: {
                self.byLabel.alpha = 1.0
                self.chippLogo.alpha = 1.0
            })
        }) { (_) in
            self.setCardsFromEvaluateDayTwo(completion: { (done) in
                if !done {
                    // Set defaults cards
                    print("Neeed set defaults")
                    self.setDefaultCards()
                } else {
                    print("Set cards from previous version")
                }
                
                UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                    self.nextButton.alpha = 1.0
                    self.nextButton.transform = CGAffineTransform.identity
                }, completion: nil)
            })
        }
    }
    
    // MARK: - Actions
    private func setDefaultCards() {
        
        // Add productivity card
        let productivityCard = Card()
        productivityCard.type = .criterionHundred
        productivityCard.title = Localizations.demo.criterion.hundred.title
        productivityCard.subtitle = Localizations.demo.criterion.hundred.subtitle
        productivityCard.order = Database.manager.data.objects(Card.self).count
        
        // Add phrase card
        let phraseCard = Card()
        phraseCard.title = Localizations.new.phrase.title
        phraseCard.subtitle = Localizations.new.phrase.subtitle
        phraseCard.type = .phrase
        phraseCard.order = Database.manager.data.objects(Card.self).count
        
        // Make data
        var values = [TextValue]()
        var components = DateComponents()
        for (i, t) in defaultPhrases.enumerated() {
            components.day = -i
            if let newDate = Calendar.current.date(byAdding: components, to: Date()) {
                let value = TextValue()
                value.created = newDate
                value.text = t
                value.owner = phraseCard.id
                values.append(value)
            }
        }
        
        // Add counter card
        let counterCard = Card()
        counterCard.title = Localizations.demo.counter.title
        counterCard.subtitle = Localizations.demo.counter.subtitle
        counterCard.type = .counter
        counterCard.order = Database.manager.data.objects(Card.self).count
        
        try! Database.manager.data.write {
            Database.manager.data.add(productivityCard)
            Database.manager.data.add(phraseCard)
            Database.manager.data.add(counterCard)
            Database.manager.data.add(values)
        }
    }
    private func setCardsFromEvaluateDayTwo(completion: ((Bool) -> Void)?) {
        guard let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: oldGroupKey) else {
            completion?(false)
            return
        }
        
        let userFile = groupURL.appendingPathComponent("user.json")
        let criteriaFile = groupURL.appendingPathComponent("criteria.json")
        let goalsFile = groupURL.appendingPathComponent("goals.json")
        let journalsfile = groupURL.appendingPathComponent("journals.json")
        let daysFile = groupURL.appendingPathComponent("days.json")
        
        do {
            if KeychainWrapper.standard.integer(forKey: keychainProStart) == nil {
                let userJsonData = try Data(contentsOf: userFile)
                let userJson = try JSON(data: userJsonData)
                
                let pro = userJson["pro"]["pro"].boolValue
                let golden = userJson["pro"]["golden"].boolValue
                let past = userJson["pro"]["past"].boolValue
                let fields = userJson["pro"]["fields"].boolValue
                let log = userJson["pro"]["log"].boolValue
                
                if pro || golden || past || fields || log {
                    KeychainWrapper.standard.set(Int(Date().timeIntervalSince1970), forKey: keychainProStart)
                    var duration = 0
                    if pro || golden {
                        duration += 12
                    }
                    if past {
                        duration += 4
                    }
                    if fields {
                        duration += 4
                    }
                    if log {
                        duration += 4
                    }
                    
                    KeychainWrapper.standard.set(duration, forKey: keychainProDuration)
                    
                    Store.current.recontrolPro()
                }
            }
        } catch {
            completion?(false)
        }
        
        if !Database.manager.data.objects(Card.self).isEmpty {
            completion?(true)
            return
        }
        
        // Export Data from previous version
        
        // Days (Color, Day Phrase and locations)
        if let daysJsonData = try? Data(contentsOf: daysFile) {
            if let daysJson = try? JSON(data: daysJsonData) {
//                print(daysJson)
                
                let order = Database.manager.data.objects(Card.self).count
                // Set color card
                let colorCard = Card()
                colorCard.title = Localizations.new.color.title
                colorCard.subtitle = Localizations.new.color.subtitle
                colorCard.type = .color
                colorCard.order = order
                
                // Set checkin card
                let checkInCard = Card()
                checkInCard.title = Localizations.new.checkin.title
                checkInCard.subtitle = Localizations.new.checkin.subtitle
                checkInCard.type = .checkIn
                checkInCard.order = order + 1
                
                // Set phrase card
                let phraseCard = Card()
                phraseCard.title = Localizations.new.phrase.title
                phraseCard.subtitle = Localizations.new.phrase.subtitle
                phraseCard.type = .phrase
                phraseCard.order = order + 2
                
                var colors = [TextValue]()
                var locations = [LocationValue]()
                var textValues = [TextValue]()
                
                for (_, d) in daysJson {
                    // Set color in cards
                    let colorValue = TextValue()
                    colorValue.text = d["color"].stringValue
                    colorValue.created = Date(timeIntervalSince1970: TimeInterval(d["date"].intValue))
                    colorValue.owner = colorCard.id
                    
                    let locationValue = LocationValue()
                    let location = d["location"]
                    if !location.isEmpty {
                        locationValue.created = Date(timeIntervalSince1970: TimeInterval(d["date"].intValue))
                        locationValue.owner = checkInCard.id
                        locationValue.latitude = location["latitude"].doubleValue
                        locationValue.longitude = location["longitude"].doubleValue
                        locationValue.street = location["name"].string
                        locationValue.city = location["locality"].string
                        locationValue.state = location["area"].string
                        locationValue.country = location["country"].string
                    }
                    
                    if let text = d["text"].string {
                        let textValue = TextValue()
                        textValue.created = Date(timeIntervalSince1970: TimeInterval(d["date"].intValue))
                        textValue.owner = phraseCard.id
                        textValue.text = text
                        
                        textValues.append(textValue)
                    }
                    
                    colors.append(colorValue)
                    if !location.isEmpty {
                        locations.append(locationValue)
                    }
                    
                }
                
                try! Database.manager.data.write {
                    Database.manager.data.add(colorCard)
                    Database.manager.data.add(checkInCard)
                    Database.manager.data.add(phraseCard)
                    Database.manager.data.add(colors)
                    Database.manager.data.add(locations)
                    Database.manager.data.add(textValues)
                }
            }
        }
        
        // Criteria (All types)
        if let criteriaJsonData = try? Data(contentsOf: criteriaFile) {
            if let criteriaJson = try? JSON(data: criteriaJsonData) {
//                print(criteriaJson)
                var cards = [Card]()
                var values = [NumberValue]()
                var order = Database.manager.data.objects(Card.self).count
                
                for (_, c) in criteriaJson {
                    if c["type"].intValue == 2 {
                        if c["subcriterion"]["scale"].intValue == 100 {
                            // Set criterion hundred card
                            let card = Card()
                            card.title = c["title"].stringValue
                            card.subtitle = c["subtitle"].stringValue
                            card.created = Date(timeIntervalSince1970: TimeInterval(c["creationDate"].intValue))
                            card.type = .criterionHundred
                            if c["subcriterion"]["feature"].intValue == 0 {
                                (card.data as! CriterionHundredCard).positive = true
                            } else {
                                (card.data as! CriterionHundredCard).positive = false
                            }
                            order += 1
                            card.order = order
                            cards.append(card)
                            
                            for (_, d) in c["days"] {
                                let value = NumberValue()
                                value.created = Date(timeIntervalSince1970: TimeInterval(d["date"].intValue))
                                value.value = Double(d["uncountableValue"].intValue)
                                value.owner = card.id
                                
                                values.append(value)
                            }
                        }
                        if c["subcriterion"]["scale"].intValue == 10 {
                            // Set criterion hundred card
                            let card = Card()
                            card.title = c["title"].stringValue
                            card.subtitle = c["subtitle"].stringValue
                            card.created = Date(timeIntervalSince1970: TimeInterval(c["creationDate"].intValue))
                            card.type = .criterionTen
                            if c["subcriterion"]["feature"].intValue == 0 {
                                (card.data as! CriterionTenCard).positive = true
                            } else {
                                (card.data as! CriterionTenCard).positive = false
                            }
                            order += 1
                            card.order = order
                            cards.append(card)
                            
                            for (_, d) in c["days"] {
                                let value = NumberValue()
                                value.created = Date(timeIntervalSince1970: TimeInterval(d["date"].intValue))
                                value.value = Double(d["uncountableValue"].intValue)
                                value.owner = card.id
                                values.append(value)
                            }
                        }
                        if c["subcriterion"]["scale"].intValue == 3 {
                            // Set criterion hundred card
                            let card = Card()
                            card.title = c["title"].stringValue
                            card.subtitle = c["subtitle"].stringValue
                            card.created = Date(timeIntervalSince1970: TimeInterval(c["creationDate"].intValue))
                            card.type = .criterionThree
                            if c["subcriterion"]["feature"].intValue == 0 {
                                (card.data as! CriterionThreeCard).positive = true
                            } else {
                                (card.data as! CriterionThreeCard).positive = false
                            }
                            order += 1
                            card.order = order
                            cards.append(card)
                            
                            for (_, d) in c["days"] {
                                let value = NumberValue()
                                value.created = Date(timeIntervalSince1970: TimeInterval(d["date"].intValue))
                                value.value = Double(d["uncountableValue"].intValue)
                                value.owner = card.id
                                values.append(value)
                            }
                        }
                    } else if c["type"].intValue == 1 {
                        let card = Card()
                        card.title = c["title"].stringValue
                        card.subtitle = c["subtitle"].stringValue
                        card.created = Date(timeIntervalSince1970: TimeInterval(c["creationDate"].intValue))
                        card.type = .counter
                        order += 1
                        card.order = order
                        cards.append(card)
                        for (_, d) in c["days"] {
                            let value = NumberValue()
                            value.created = Date(timeIntervalSince1970: TimeInterval(d["date"].intValue))
                            value.value = Double(d["countable"].intValue)
                            value.owner = card.id
                            values.append(value)
                        }
                    }
                }
                
                try! Database.manager.data.write {
                    Database.manager.data.add(cards)
                    Database.manager.data.add(values)
                }
            }
        }
        
        if let goalsJsonData = try? Data(contentsOf: goalsFile) {
            if let goalsJson = try? JSON(data: goalsJsonData) {
//                print(goalsJson)
                var cards = [Card]()
                var values = [MarkValue]()
                var numValues = [NumberValue]()
                var order = Database.manager.data.objects(Card.self).count
                
                for (_, g) in goalsJson {
                    if g["type"].intValue == 1 {
                        let card = Card()
                        card.title = g["title"].stringValue
                        card.subtitle = g["subtitle"].stringValue
                        card.created = Date(timeIntervalSince1970: TimeInterval(g["creationDate"].intValue))
                        card.type = .habit
                        order += 1
                        card.order = order
                        cards.append(card)
                        
                        for (_, d) in g["days"] {
                            let value = MarkValue()
                            value.created = Date(timeIntervalSince1970: TimeInterval(d["date"].intValue))
                            value.text = d["comment"].stringValue
                            value.owner = card.id
                            values.append(value)
                        }
                    } else if g["type"].intValue == 2 {
                        let card = Card()
                        card.title = g["title"].stringValue
                        card.subtitle = g["subtitle"].stringValue
                        card.created = Date(timeIntervalSince1970: TimeInterval(g["creationDate"].intValue))
                        card.type = .list
                        order += 1
                        card.order = order
                        cards.append(card)
                        
                        for (_, d) in g["subgoal"] {
                            let value = MarkValue()
                            value.created = Date(timeIntervalSince1970: TimeInterval(d["creationDate"].intValue))
                            value.text = d["title"].stringValue
                            value.owner = card.id
                            if let doneDate = d["doneDate"].int {
                                value.done = true
                                value.doneDate = Date(timeIntervalSince1970: TimeInterval(doneDate))
                            }
                            values.append(value)
                        }
                    } else if g["type"].intValue == 3 || g["type"].intValue == 4 {
                        let card = Card()
                        card.title = g["title"].stringValue
                        card.subtitle = g["subtitle"].stringValue
                        card.created = Date(timeIntervalSince1970: TimeInterval(g["creationDate"].intValue))
                        card.type = .goal
                        order += 1
                        card.order = order
                        (card.data as! GoalCard).startValue = Double(g["subgoal"]["startValue"].intValue)
                        (card.data as! GoalCard).goalValue = Double(g["subgoal"]["goalValue"].intValue)
                        cards.append(card)
                        
                        for (_, d) in g["days"] {
                            let value = NumberValue()
                            value.created = Date(timeIntervalSince1970: TimeInterval(d["date"].intValue))
                            value.value = Double(d["numberValue"].intValue)
                            value.owner = card.id
                            numValues.append(value)
                        }
                    }
                }
                
                try! Database.manager.data.write {
                    Database.manager.data.add(cards)
                    Database.manager.data.add(values)
                    Database.manager.data.add(numValues)
                }
            }
        }
        
        if let journalsJsonData = try? Data(contentsOf: journalsfile) {
            if let journalsJson = try? JSON(data: journalsJsonData) {
//                print(journalsJson)
                
                var cards = [Card]()
                var values = [TextValue]()
                var photos = [PhotoValue]()
                var locations = [LocationValue]()
                var weathers = [WeatherValue]()
                
                var order = Database.manager.data.objects(Card.self).count
                
                for (_, j) in journalsJson {
                    let card = Card()
                    card.title = j["title"].stringValue
                    card.subtitle = j["subtitle"].stringValue
                    card.created = Date(timeIntervalSince1970: TimeInterval(j["creationDate"].intValue))
                    card.type = .journal
                    order += 1
                    card.order = order
                    cards.append(card)
                    
                    for (_, e) in j["entries"] {
                        // Set text value
                        let textValue = TextValue()
                        textValue.owner = card.id
                        textValue.created = Date(timeIntervalSince1970: TimeInterval(e["creationDate"].intValue))
                        textValue.text = e["text"].stringValue
                        values.append(textValue)
                        
                        // set location value
                        let loc = e["location"]
                        if !loc.isEmpty {
                            let locationValue = LocationValue()
                            locationValue.created = textValue.created
                            locationValue.owner = textValue.id
                            locationValue.latitude = loc["latitude"].doubleValue
                            locationValue.longitude = loc["longitude"].doubleValue
                            locationValue.street = loc["name"].string
                            locationValue.city = loc["locality"].string
                            locationValue.state = loc["area"].string
                            locationValue.country = loc["country"].string
                            locations.append(locationValue)
                        }
                        
                        // set weather value
                        let weather = e["weather"]
                        if !weather.isEmpty {
                            let weatherValue = WeatherValue()
                            weatherValue.created = textValue.created
                            weatherValue.owner = textValue.id
                            weatherValue.latitude = loc["latitude"].doubleValue
                            weatherValue.longitude = loc["longitude"].doubleValue
                            weatherValue.temperarure = weather["celsiusMax"].doubleValue
                            weatherValue.apparentTemperature = weather["celsiusMin"].doubleValue
                            weatherValue.summary = weather["description"].stringValue
                            weatherValue.icon = weather["icon"].stringValue
                            weatherValue.humidity = weather["humidity"].doubleValue
                            weatherValue.pressure = weather["pressure"].doubleValue
                            weatherValue.windSpeed = weather["windSpeedMetersPerSecond"].doubleValue
                            weatherValue.cloudCover = 0.0
                            weathers.append(weatherValue)
                        }
                        
                        // set photo value
                        for (_, photo) in e["photos"] {
                            let imagePath = groupURL.path + "/Media/\(photo["id"]).png"
                            let image = UIImage(contentsOfFile: imagePath)
                            if image != nil {
                                let photoValue = PhotoValue()
                                photoValue.created = textValue.created
                                photoValue.owner = textValue.id
                                photoValue.latitude = loc["latitude"].doubleValue
                                photoValue.longitude = loc["longitude"].doubleValue
                                photoValue.image = image!
                                photos.append(photoValue)
                            }
                        }
                    }
                }
                
                try! Database.manager.data.write {
                    Database.manager.data.add(cards)
                    Database.manager.data.add(values)
                    Database.manager.data.add(photos)
                    Database.manager.data.add(locations)
                    Database.manager.data.add(weathers)
                }
            }
        }

        if Database.manager.data.objects(Card.self).isEmpty {
            completion?(false)
        } else {
            completion?(true)
        }
    }
    
    @objc func nextButtonAction(sender: NextButton) {
        let presentingController = UIStoryboard(name: Storyboards.onboarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: slidesViewController)
        presentingController.transition = WelcomeTransition(animationDuration: 0.6)
        self.present(presentingController, animated: true, completion: nil)
    }
}
