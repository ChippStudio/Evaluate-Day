//
//  LightAnalyticalTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 09/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct LightAnalyticalTheme: AnalyticalStyle {
    // General controller
    var background: UIColor { return UIColor.snow }
    var barColor: UIColor { return UIColor.snow }
    var barTint: UIColor { return UIColor.viridian }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    var tableNodeSeparatorColor: UIColor { return UIColor.lightGray }
    
    // Title Node
    var titleTitleColor: UIColor { return UIColor.gunmetal }
    var titleTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var titleSubtitleColor: UIColor { return UIColor.gunmetal }
    var titleSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var titleShareTintColor: UIColor { return UIColor.gunmetal }
    
    // AnalyticsCalendarNodeStyle
    var calendarTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var calendarTitleColor: UIColor { return UIColor.gunmetal }
    var calendarFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var calendarWeekdaysColor: UIColor { return UIColor.viridian }
    var calendarCurrentMonthColor: UIColor { return UIColor.gunmetal }
    var calendarOtherMonthColor: UIColor { return UIColor.lightGray }
    var calendarShareTintColor: UIColor { return UIColor.gunmetal }
    var calendarSetColor: UIColor { return UIColor.brownishRed }
    
    // MARK: - AnalyticsMapNodeStyle
    var mapNodeTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var mapNodeTitleColor: UIColor { return UIColor.gunmetal }
    var mapNodeShareTintColor: UIColor { return UIColor.gunmetal }
    var mapActionColor: UIColor { return UIColor.viridian }
    var mapActionHighlightedColor: UIColor { return UIColor.brownishRed }
    var mapActionFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    
    // AnalyticsColorStatisticNodeStyle
    var statisticTitleColor: UIColor { return UIColor.gunmetal }
    var statisticTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var statisticSeparatorColor: UIColor { return UIColor.gunmetal }
    var statisticDataColor: UIColor { return UIColor.gunmetal }
    var statisticDataFont: UIFont { return UIFont.avenirNext(size: 64.0, weight: .bold) }
    // AnalyticsStatisticNodeStyle
    var statisticDataTitleColor: UIColor { return UIColor.gunmetal }
    var statisticDataTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .ultraLight) }
    var statisticDataCellBackground: UIColor { return UIColor.white }
    
    // AnalyticsChartNodeStyle
    var chartNodeTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var chartNodeTitleColor: UIColor { return UIColor.gunmetal }
    var chartNodeShareTintColor: UIColor { return UIColor.gunmetal }
    var chartNodeDateFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var chartNodeDateColor: UIColor { return UIColor.gunmetal }
    var chartNodeValueFont: UIFont { return UIFont.avenirNext(size: 25.0, weight: .regular) }
    var chartNodeValuePositiveColor: UIColor { return UIColor.viridian }
    var chartNodeValueNegativeColor: UIColor { return UIColor.brownishRed }
    var chartNodeYAxisColor: UIColor { return UIColor.gunmetal }
    var chartNodeYAxisFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var chartNodeXAxisColor: UIColor { return UIColor.gunmetal }
    var chartNodeXAxisFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var chartNodeGridColor: UIColor { return UIColor.gray }
    var analyticsLineChartLineColor: UIColor { return UIColor.gunmetal }
    var analyticsLineChartHightlightPositiveColor: UIColor { return UIColor.viridian }
    var analyticsLineChartHightlightNegativeColor: UIColor { return UIColor.brownishRed }
    var analyticsBarChartHightlightPositiveColor: UIColor { return UIColor.viridian }
    var analyticsBarChartHightlightNegativeColor: UIColor { return UIColor.brownishRed }
    var analyticsBarChartBarColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - AnalyticsExportNodeStyle
    var analyticsExportTintColor: UIColor { return UIColor.gunmetal }
    var analyticsExportHighlightedColor: UIColor { return UIColor.brownishRed }
    var analyticsExportTitleColor: UIColor { return UIColor.gunmetal }
    var analyticsExportTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var analyticsExportActionColor: UIColor { return UIColor.gunmetal }
    var analyticsExportActionFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    
    // MARK: - PhraseListNodeStyle
    var phraseListDateFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .bold) }
    var phraseListDateColor: UIColor { return UIColor.gunmetal }
    var phraseListTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var phraseListTextColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - SettingsProButtonNodeStyle
    var proButtonTextColor: UIColor { return UIColor.gunmetal }
    var proButtonTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var proButtonCoverColor: UIColor { return UIColor.gunmetal }
    var proButtonSelectedColor: UIColor { return UIColor.brownishRed }
    var proSecondaryTextColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - SettingsMoreNodeStyle
    var settingsTitleNodeColor: UIColor { return UIColor.gunmetal }
    var settingsTitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var settingsSubtitleNodeColor: UIColor { return UIColor.gunmetal }
    var settingsSubtitleNodeFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var disclosureTintColor: UIColor { return UIColor.gunmetal }
    var imageTintColor: UIColor { return UIColor.gunmetal }
}
