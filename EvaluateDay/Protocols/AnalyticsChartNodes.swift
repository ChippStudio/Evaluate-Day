//
//  AnalyticsChartNodes.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

protocol AnalyticsChartNodeStyle {
    var chartNodeTitleFont: UIFont { get }
    var chartNodeTitleColor: UIColor { get }
    var chartNodeShareTintColor: UIColor { get }
    var chartNodeDateFont: UIFont { get }
    var chartNodeDateColor: UIColor { get }
    var chartNodeValueFont: UIFont { get }
    var chartNodeValuePositiveColor: UIColor { get }
    var chartNodeValueNegativeColor: UIColor { get }
    var chartNodeYAxisColor: UIColor { get }
    var chartNodeYAxisFont: UIFont { get }
    var chartNodeXAxisColor: UIColor { get }
    var chartNodeXAxisFont: UIFont { get }
    var chartNodeGridColor: UIColor { get }
}

enum AnalyticsChartNodeOptionsKey: String {
    case dateFormat
    case valueSubString
    case uppercaseTitle
    case yLineNumber
    case positive
}
