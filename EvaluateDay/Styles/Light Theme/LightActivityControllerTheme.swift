//
//  LightActivityControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct LightActivityControllerTheme: ActivityControllerStyle {
    // MARK: - General controller
    var background: UIColor { return UIColor.snow }
    var barColor: UIColor { return UIColor.snow }
    var barTint: UIColor { return UIColor.viridian }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    var settingsTintColor: UIColor { return UIColor.white }
    var settingsCoverColor: UIColor { return UIColor.gunmetal}
    
    // MARK: - UserInformationNodeStyle
    var userInformationEditColor: UIColor { return UIColor.viridian }
    var userInformationEditHighlightedColor: UIColor { return UIColor.brownishRed }
    var userInformationEditFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var userInfomationNameColor: UIColor { return UIColor.gunmetal }
    var userInformationNameFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .regular) }
    var userInfomationEmailColor: UIColor { return UIColor.gunmetal }
    var userInformationEmailFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var userInfomationBioColor: UIColor { return UIColor.gunmetal }
    var userInformationBioFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var userInfomationLinkColor: UIColor { return UIColor.gunmetal }
    var userInformationLinkFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .regular) }
    var userInformationSeparatorColor: UIColor { return UIColor.lightGray }
    var userInformationPlaceholderColor: UIColor { return UIColor.lightGray }
    var userInformationFacebookButtonFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var userInformationFacebookButtonColor: UIColor { return UIColor.white }
    var userInformationFacebookButtonCoverColor: UIColor { return UIColor.facebook }
    var userInformationFacebookButtonHighlightedColor: UIColor { return UIColor.gunmetal }
    var userInformationFacebookDisclaimerFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var userInformationFacebookDisclaimerColor: UIColor { return UIColor.gunmetal }
    
    // AnalyticsChartNodeStyle
    var chartNodeTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var chartNodeTitleColor: UIColor { return UIColor.gunmetal }
    var chartNodeShareTintColor: UIColor { return UIColor.gunmetal }
    var chartNodeDateFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var chartNodeDateColor: UIColor { return UIColor.gunmetal }
    var chartNodeValueFont: UIFont { return UIFont.avenirNext(size: 64.0, weight: .bold) }
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
    
    // AnalyticsCalendarNodeStyle
    var calendarTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var calendarTitleColor: UIColor { return UIColor.gunmetal }
    var calendarFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var calendarWeekdaysColor: UIColor { return UIColor.viridian }
    var calendarCurrentMonthColor: UIColor { return UIColor.gunmetal }
    var calendarOtherMonthColor: UIColor { return UIColor.lightGray }
    var calendarShareTintColor: UIColor { return UIColor.gunmetal }
    var calendarSetColor: UIColor { return UIColor.brownishRed }
    
    // AnalyticsColorStatisticNodeStyle
    var statisticTitleColor: UIColor { return UIColor.gunmetal }
    var statisticTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var statisticSeparatorColor: UIColor { return UIColor.gunmetal }
    var statisticDataColor: UIColor { return UIColor.gunmetal }
    var statisticDataFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    // AnalyticsStatisticNodeStyle
    var statisticDataTitleColor: UIColor { return UIColor.gunmetal }
    var statisticDataTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var statisticDataCellBackground: UIColor { return UIColor.white }
    
    // MARK: - Title Node
    var titleTitleColor: UIColor { return UIColor.gunmetal }
    var titleTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var titleSubtitleColor: UIColor { return UIColor.gunmetal }
    var titleSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var titleShareTintColor: UIColor { return UIColor.gunmetal }
    var titleDashboardFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .medium) }
    var titleDashboardColor: UIColor { return UIColor.charcoal }
    
    // MARK: - SettingsMoreNodeStyle
    var settingsTitleNodeColor: UIColor { return UIColor.gunmetal }
    var settingsTitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var settingsSubtitleNodeColor: UIColor { return UIColor.viridian }
    var settingsSubtitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var disclosureTintColor: UIColor { return UIColor.gunmetal }
    var imageTintColor: UIColor { return UIColor.gunmetal  }
    
    // MARK: - LoadViewStyle
    var loadCircleColor: UIColor { return UIColor.white }
    var loadBaseViewColor: UIColor { return UIColor.charcoal }
    var loadCoverViewColor: UIColor { return UIColor.gunmetal }
    var loadBaseViewAlpha: CGFloat { return 0.6 }
    var loadCoverViewAlpha: CGFloat { return 0.2 }
}
