//
//  DarkAnalyticalTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 09/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct OrangeAnalyticalTheme: AnalyticalStyle {
    // General controller
    var background: UIColor { return UIColor.squash }
    var barColor: UIColor { return UIColor.squash }
    var barTint: UIColor { return UIColor.paleGrey }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    var tableNodeSeparatorColor: UIColor { return UIColor.lightGray }
    
    // Title Node
    var titleTitleColor: UIColor { return UIColor.paleGrey }
    var titleTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var titleSubtitleColor: UIColor { return UIColor.paleGrey }
    var titleSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var titleShareTintColor: UIColor { return UIColor.paleGrey }
    
    // AnalyticsCalendarNodeStyle
    var calendarTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var calendarTitleColor: UIColor { return UIColor.paleGrey }
    var calendarFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var calendarWeekdaysColor: UIColor { return UIColor.grapePurple }
    var calendarCurrentMonthColor: UIColor { return UIColor.white }
    var calendarOtherMonthColor: UIColor { return UIColor.paleGrey }
    var calendarShareTintColor: UIColor { return UIColor.paleGrey }
    var calendarSetColor: UIColor { return UIColor.grapePurple }
    
    // MARK: - AnalyticsMapNodeStyle
    var mapNodeTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var mapNodeTitleColor: UIColor { return UIColor.paleGrey }
    var mapNodeShareTintColor: UIColor { return UIColor.paleGrey }
    var mapActionColor: UIColor { return UIColor.paleGrey }
    var mapActionHighlightedColor: UIColor { return UIColor.grapePurple }
    var mapActionFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold) }
    
    // AnalyticsColorStatisticNodeStyle
    var statisticTitleColor: UIColor { return UIColor.paleGrey }
    var statisticTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var statisticSeparatorColor: UIColor { return UIColor.paleGrey }
    var statisticDataColor: UIColor { return UIColor.paleGrey }
    var statisticDataFont: UIFont { return UIFont.avenirNext(size: 64.0, weight: .bold) }
    // AnalyticsStatisticNodeStyle
    var statisticDataTitleColor: UIColor { return UIColor.paleGrey }
    var statisticDataTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .ultraLight) }
    var statisticDataCellBackground: UIColor { return UIColor.pumpkin }
    
    // AnalyticsChartNodeStyle
    var chartNodeTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var chartNodeTitleColor: UIColor { return UIColor.paleGrey }
    var chartNodeShareTintColor: UIColor { return UIColor.paleGrey }
    var chartNodeDateFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var chartNodeDateColor: UIColor { return UIColor.paleGrey }
    var chartNodeValueFont: UIFont { return UIFont.avenirNext(size: 64.0, weight: .bold) }
    var chartNodeValuePositiveColor: UIColor { return UIColor.darkBlueGreen }
    var chartNodeValueNegativeColor: UIColor { return UIColor.grapePurple }
    var chartNodeYAxisColor: UIColor { return UIColor.paleGrey }
    var chartNodeYAxisFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var chartNodeXAxisColor: UIColor { return UIColor.paleGrey }
    var chartNodeXAxisFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var chartNodeGridColor: UIColor { return UIColor.lightGray }
    var analyticsLineChartLineColor: UIColor { return UIColor.paleGrey }
    var analyticsLineChartHightlightPositiveColor: UIColor { return UIColor.darkBlueGreen }
    var analyticsLineChartHightlightNegativeColor: UIColor { return UIColor.grapePurple }
    var analyticsBarChartHightlightPositiveColor: UIColor { return UIColor.darkBlueGreen }
    var analyticsBarChartHightlightNegativeColor: UIColor { return UIColor.grapePurple }
    var analyticsBarChartBarColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - AnalyticsExportNodeStyle
    var analyticsExportTintColor: UIColor { return UIColor.paleGrey }
    var analyticsExportHighlightedColor: UIColor { return UIColor.grapePurple }
    var analyticsExportTitleColor: UIColor { return UIColor.paleGrey }
    var analyticsExportTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular)}
    var analyticsExportActionColor: UIColor { return UIColor.paleGrey }
    var analyticsExportActionFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    
    // MARK: - PhraseListNodeStyle
    var phraseListDateFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .bold) }
    var phraseListDateColor: UIColor { return UIColor.paleGrey }
    var phraseListTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var phraseListTextColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - SettingsProButtonNodeStyle
    var proButtonTextColor: UIColor { return UIColor.paleGrey }
    var proButtonTextFont: UIFont { return UIFont.avenirNext(size: 22.0, weight: .demiBold) }
    var proButtonCoverColor: UIColor { return UIColor.paleGrey }
    var proButtonSelectedColor: UIColor { return UIColor.grapePurple }
    var proSecondaryTextColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - SettingsMoreNodeStyle
    var settingsTitleNodeColor: UIColor { return UIColor.paleGrey }
    var settingsTitleNodeFont: UIFont { return UIFont.avenirNext(size: 22.0, weight: .demiBold) }
    var settingsSubtitleNodeColor: UIColor { return UIColor.paleGrey }
    var settingsSubtitleNodeFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var disclosureTintColor: UIColor { return UIColor.paleGrey }
    var imageTintColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - AnalyticsTimeTravelNodeStyle
    var analyticsTimeTravelNodeTitleColor: UIColor { return UIColor.grapePurple}
    var analyticsTimeTravelNodeTitleFont: UIFont { return UIFont.avenirNext(size: 30.0, weight: .bold) }
}
