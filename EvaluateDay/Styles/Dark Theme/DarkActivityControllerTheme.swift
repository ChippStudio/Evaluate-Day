//
//  DarkActivityControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct DarkActivityControllerTheme: ActivityControllerStyle {
    // MARK: - General controller
    var background: UIColor { return UIColor.charcoal }
    var barColor: UIColor { return UIColor.charcoal }
    var barTint: UIColor { return UIColor.white }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    var settingsTintColor: UIColor { return UIColor.gunmetal }
    var settingsCoverColor: UIColor { return UIColor.white}
    
    // MARK: - UserInformationNodeStyle
    var userInformationEditColor: UIColor { return UIColor.pewterBlue }
    var userInformationEditHighlightedColor: UIColor { return UIColor.salmon }
    var userInformationEditFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var userInfomationNameColor: UIColor { return UIColor.white }
    var userInformationNameFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .regular) }
    var userInfomationEmailColor: UIColor { return UIColor.white }
    var userInformationEmailFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var userInfomationBioColor: UIColor { return UIColor.white }
    var userInformationBioFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var userInfomationLinkColor: UIColor { return UIColor.white }
    var userInformationLinkFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .regular) }
    var userInformationSeparatorColor: UIColor { return UIColor.lightGray }
    var userInformationPlaceholderColor: UIColor { return UIColor.lightGray }
    var userInformationFacebookButtonFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var userInformationFacebookButtonColor: UIColor { return UIColor.white }
    var userInformationFacebookButtonCoverColor: UIColor { return UIColor.facebook }
    var userInformationFacebookButtonHighlightedColor: UIColor { return UIColor.gunmetal }
    var userInformationFacebookDisclaimerFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var userInformationFacebookDisclaimerColor: UIColor { return UIColor.white }
    
    // AnalyticsCalendarNodeStyle
    var calendarTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var calendarTitleColor: UIColor { return UIColor.white }
    var calendarFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var calendarWeekdaysColor: UIColor { return UIColor.salmon }
    var calendarCurrentMonthColor: UIColor { return UIColor.white }
    var calendarOtherMonthColor: UIColor { return UIColor.lightGray }
    var calendarShareTintColor: UIColor { return UIColor.white }
    var calendarSetColor: UIColor { return UIColor.salmon }
    
    // AnalyticsColorStatisticNodeStyle
    var statisticTitleColor: UIColor { return UIColor.white }
    var statisticTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var statisticSeparatorColor: UIColor { return UIColor.white }
    var statisticDataColor: UIColor { return UIColor.white }
    var statisticDataFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    // AnalyticsStatisticNodeStyle
    var statisticDataTitleColor: UIColor { return UIColor.white }
    var statisticDataTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var statisticDataCellBackground: UIColor { return UIColor.gunmetal }
    
    // AnalyticsChartNodeStyle
    var chartNodeTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var chartNodeTitleColor: UIColor { return UIColor.white }
    var chartNodeShareTintColor: UIColor { return UIColor.white }
    var chartNodeDateFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var chartNodeDateColor: UIColor { return UIColor.white }
    var chartNodeValueFont: UIFont { return UIFont.avenirNext(size: 64.0, weight: .bold) }
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
    
    // MARK: - Title Node
    var titleTitleColor: UIColor { return UIColor.white }
    var titleTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var titleSubtitleColor: UIColor { return UIColor.white }
    var titleSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var titleShareTintColor: UIColor { return UIColor.white }
    var titleDashboardFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .medium) }
    var titleDashboardColor: UIColor { return UIColor.pewterBlue }
    
    // MARK: - SettingsMoreNodeStyle
    var settingsTitleNodeColor: UIColor { return UIColor.white }
    var settingsTitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var settingsSubtitleNodeColor: UIColor { return UIColor.salmon }
    var settingsSubtitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var disclosureTintColor: UIColor { return UIColor.white }
    var imageTintColor: UIColor { return UIColor.white  }
    
    // MARK: - LoadViewStyle
    var loadCircleColor: UIColor { return UIColor.gunmetal }
    var loadBaseViewColor: UIColor { return UIColor.white }
    var loadCoverViewColor: UIColor { return UIColor.snow }
    var loadBaseViewAlpha: CGFloat { return 0.6 }
    var loadCoverViewAlpha: CGFloat { return 0.2 }
}
