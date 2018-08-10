//
//  DarkAnalyticalTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 09/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct DarkAnalyticalTheme: AnalyticalStyle {
    // General controller
    var background: UIColor { return UIColor.charcoal }
    var barColor: UIColor { return UIColor.charcoal }
    var barTint: UIColor { return UIColor.white }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    var tableNodeSeparatorColor: UIColor { return UIColor.lightGray }
    
    // Title Node
    var titleTitleColor: UIColor { return UIColor.white }
    var titleTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var titleSubtitleColor: UIColor { return UIColor.white }
    var titleSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var titleShareTintColor: UIColor { return UIColor.white }
    
    // AnalyticsCalendarNodeStyle
    var calendarTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var calendarTitleColor: UIColor { return UIColor.white }
    var calendarFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var calendarWeekdaysColor: UIColor { return UIColor.salmon }
    var calendarCurrentMonthColor: UIColor { return UIColor.white }
    var calendarOtherMonthColor: UIColor { return UIColor.lightGray }
    var calendarShareTintColor: UIColor { return UIColor.white }
    var calendarSetColor: UIColor { return UIColor.salmon }
    
    // MARK: - AnalyticsMapNodeStyle
    var mapNodeTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var mapNodeTitleColor: UIColor { return UIColor.white }
    var mapNodeShareTintColor: UIColor { return UIColor.white }
    var mapActionColor: UIColor { return UIColor.white }
    var mapActionHighlightedColor: UIColor { return UIColor.salmon }
    var mapActionFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    
    // AnalyticsColorStatisticNodeStyle
    var statisticTitleColor: UIColor { return UIColor.white }
    var statisticTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var statisticSeparatorColor: UIColor { return UIColor.white }
    var statisticDataColor: UIColor { return UIColor.white }
    var statisticDataFont: UIFont { return UIFont.avenirNext(size: 64.0, weight: .bold) }
    // AnalyticsStatisticNodeStyle
    var statisticDataTitleColor: UIColor { return UIColor.white }
    var statisticDataTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .ultraLight) }
    var statisticDataCellBackground: UIColor { return UIColor.gunmetal }
    
    // AnalyticsChartNodeStyle
    var chartNodeTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var chartNodeTitleColor: UIColor { return UIColor.white }
    var chartNodeShareTintColor: UIColor { return UIColor.white }
    var chartNodeDateFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var chartNodeDateColor: UIColor { return UIColor.white }
    var chartNodeValueFont: UIFont { return UIFont.avenirNext(size: 25.0, weight: .regular) }
    var chartNodeValuePositiveColor: UIColor { return UIColor.pewterBlue }
    var chartNodeValueNegativeColor: UIColor { return UIColor.salmon }
    var chartNodeYAxisColor: UIColor { return UIColor.white }
    var chartNodeYAxisFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var chartNodeXAxisColor: UIColor { return UIColor.white }
    var chartNodeXAxisFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var chartNodeGridColor: UIColor { return UIColor.gray }
    var analyticsLineChartLineColor: UIColor { return UIColor.white }
    var analyticsLineChartHightlightPositiveColor: UIColor { return UIColor.pewterBlue }
    var analyticsLineChartHightlightNegativeColor: UIColor { return UIColor.salmon }
    var analyticsBarChartHightlightPositiveColor: UIColor { return UIColor.pewterBlue }
    var analyticsBarChartHightlightNegativeColor: UIColor { return UIColor.salmon }
    var analyticsBarChartBarColor: UIColor { return UIColor.white }
    
    // MARK: - AnalyticsExportNodeStyle
    var analyticsExportTintColor: UIColor { return UIColor.white }
    var analyticsExportHighlightedColor: UIColor { return UIColor.salmon }
    var analyticsExportTitleColor: UIColor { return UIColor.white }
    var analyticsExportTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular)}
    var analyticsExportActionColor: UIColor { return UIColor.white }
    var analyticsExportActionFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    
    // MARK: - PhraseListNodeStyle
    var phraseListDateFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .bold) }
    var phraseListDateColor: UIColor { return UIColor.white }
    var phraseListTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var phraseListTextColor: UIColor { return UIColor.white }
    
    // MARK: - SettingsProButtonNodeStyle
    var proButtonTextColor: UIColor { return UIColor.white }
    var proButtonTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var proButtonCoverColor: UIColor { return UIColor.white }
    var proButtonSelectedColor: UIColor { return UIColor.salmon }
    var proSecondaryTextColor: UIColor { return UIColor.white }
    
    // MARK: - SettingsMoreNodeStyle
    var settingsTitleNodeColor: UIColor { return UIColor.white }
    var settingsTitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var settingsSubtitleNodeColor: UIColor { return UIColor.white }
    var settingsSubtitleNodeFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var disclosureTintColor: UIColor { return UIColor.white }
    var imageTintColor: UIColor { return UIColor.white }
}
