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
