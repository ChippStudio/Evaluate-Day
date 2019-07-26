//
//  Enums.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation

enum PasscodeDelay: Int {
    case immediately = 0
    case one = 1
    case three = 3
    case five = 5
    case ten = 10
    case thirty = 30
    case hour = 60
}

enum UserLoginType: Int {
    case facebook
    case google
    case twitter
    case vk
}

@available(iOS 10.0, *)
enum ExportType {
    case csv
    case json
    case txt
}

enum ShortcutItems: String {
    case evaluate = "shortcut-evaluate"
    case activity = "shortcut-Activity"
    case collection = "shortcut-collection"
}

enum SiriShortcutItem: String {
    // MARK: - General
    case openAnalytics = "ee.chippstudio.evaluateday.siri.general.openAnalytics"
    case evaluate = "ee.chippstudio.evaluateday.siri.general.evaluate"
    case collection = "ee.chippstudio.evaluateday.siri.general.collection"
    
    // MARK: - Check In
    case checkInQuick = "ee.chippstudio.evaluateday.siri.checkin.quick"
    case checkInMap = "ee.chippstudio.evaluateday.siri.checkin.map"
    
    // MARK: - Phrase
    case phraseEdit = "ee.chippstudio.evaluateday.siri.phrase.edit"
    
    // MARK: - Criterion 100
    case criterion100Evaluate = "ee.chippstudio.evaluateday.siri.criterion.100.evaluate"
    
    // MARK: - Criterion 10
    case criterion10Evaluate = "ee.chippstudio.evaluateday.siri.criterion.10.evaluate"
    
    // MARK: - Criterion 3
    case criterionBad = "ee.chippstudio.evaluateday.siri.criterion.bad"
    case criterionNeutral = "ee.chippstudio.evaluateday.siri.criterion.neutral"
    case criterionGood = "ee.chippstudio.evaluateday.siri.criterion.good"
    
    // MARK: - Counter
    case counterIncrease = "ee.chippstudio.evaluateday.siri.counter.increase"
    case counterDecrease = "ee.chippstudio.evaluateday.siri.counter.decrease"
    case counterEnterValue = "ee.chippstudio.evaluateday.siri.counter.enterValue"
    
    // MARK: - Habit
    case habitMark = "ee.chippstudio.evaluateday.siri.habit.mark"
    case habitMarkAndComment = "ee.chippstudio.evaluateday.siri.habit.markAndComment"
    
    // MARK: - Tracker
    case trackerMark = "ee.chippstudio.evaluateday.siri.tracker.mark"
    case trackerMarkAndComment = "ee.chippstudio.evaluateday.siri.tracker.markAndComment"
    
    // MARK: - List
    case listOpen = "ee.chippstudio.evaluateday.siri.list.open"
    
    // MARK: - Goal
    case goalIncrease = "ee.chippstudio.evaluateday.siri.goal.increase"
    case goalDecrease = "ee.chippstudio.evaluateday.siri.goal.decrease"
    case goalEnterValue = "ee.chippstudio.evaluateday.siri.goal.enterValue"
    
    // MARK: - Journal
    case journalNewEntry = "ee.chippstudio.evaluateday.siri.journal.newEntry"
}

enum AnalyticsChartNodeOptionsKey: String {
    case dateFormat
    case valueSubString
    case uppercaseTitle
    case yLineNumber
    case positive
}

enum AnalyticsChartRange {
    case week
    case month
    case year
}
