//
//  DarkActivityControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct OrangeActivityControllerTheme: ActivityControllerStyle {
    // MARK: - General controller
    var background: UIColor { return UIColor.squash }
    var barColor: UIColor { return UIColor.squash }
    var barTint: UIColor { return UIColor.paleGrey }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    var settingsTintColor: UIColor { return UIColor.squash }
    var settingsCoverColor: UIColor { return UIColor.paleGrey}
    
    // MARK: - UserInformationNodeStyle
    var userInformationEditColor: UIColor { return UIColor.darkBlueGreen }
    var userInformationEditHighlightedColor: UIColor { return UIColor.grapePurple}
    var userInformationEditFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var userInfomationColor: UIColor { return UIColor.paleGrey }
    var userInformationFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var userInformationPlaceholderColor: UIColor { return UIColor.lightGray }
    var userInformationFacebookButtonFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var userInformationFacebookButtonColor: UIColor { return UIColor.paleGrey }
    var userInformationFacebookButtonCoverColor: UIColor { return UIColor.facebook }
    var userInformationFacebookButtonHighlightedColor: UIColor { return UIColor.darkBlueGreen }
    var userInformationFacebookDisclaimerFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var userInformationFacebookDisclaimerColor: UIColor { return UIColor.paleGrey }
    
    // AnalyticsCalendarNodeStyle
    var calendarTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var calendarTitleColor: UIColor { return UIColor.paleGrey }
    var calendarFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var calendarWeekdaysColor: UIColor { return UIColor.grapePurple }
    var calendarCurrentMonthColor: UIColor { return UIColor.paleGrey }
    var calendarOtherMonthColor: UIColor { return UIColor.lightGray }
    var calendarShareTintColor: UIColor { return UIColor.paleGrey }
    var calendarSetColor: UIColor { return UIColor.grapePurple }
    
    // AnalyticsColorStatisticNodeStyle
    var statisticTitleColor: UIColor { return UIColor.paleGrey }
    var statisticTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var statisticSeparatorColor: UIColor { return UIColor.paleGrey }
    var statisticDataColor: UIColor { return UIColor.paleGrey }
    var statisticDataFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    // AnalyticsStatisticNodeStyle
    var statisticDataTitleColor: UIColor { return UIColor.paleGrey }
    var statisticDataTitleFont: UIFont { return UIFont.avenirNext(size: 17.0, weight: .regular) }
    
    // AnalyticsChartNodeStyle
    var chartNodeTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var chartNodeTitleColor: UIColor { return UIColor.paleGrey }
    var chartNodeShareTintColor: UIColor { return UIColor.paleGrey }
    var chartNodeDateFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var chartNodeDateColor: UIColor { return UIColor.paleGrey }
    var chartNodeValueFont: UIFont { return UIFont.avenirNext(size: 25.0, weight: .regular) }
    var chartNodeValuePositiveColor: UIColor { return UIColor.darkBlueGreen }
    var chartNodeValueNegativeColor: UIColor { return UIColor.grapePurple }
    var chartNodeYAxisColor: UIColor { return UIColor.paleGrey }
    var chartNodeYAxisFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var chartNodeXAxisColor: UIColor { return UIColor.paleGrey }
    var chartNodeXAxisFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var chartNodeGridColor: UIColor { return UIColor.gray }
    var analyticsLineChartLineColor: UIColor { return UIColor.paleGrey }
    var analyticsLineChartHightlightPositiveColor: UIColor { return UIColor.darkBlueGreen }
    var analyticsLineChartHightlightNegativeColor: UIColor { return UIColor.grapePurple }
    var analyticsBarChartHightlightPositiveColor: UIColor { return UIColor.darkBlueGreen }
    var analyticsBarChartHightlightNegativeColor: UIColor { return UIColor.grapePurple }
    var analyticsBarChartBarColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - Title Node
    var titleTitleColor: UIColor { return UIColor.paleGrey }
    var titleTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var titleSubtitleColor: UIColor { return UIColor.gray }
    var titleSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var titleShareTintColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - SettingsMoreNodeStyle
    var settingsTitleNodeColor: UIColor { return UIColor.paleGrey }
    var settingsTitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var settingsSubtitleNodeColor: UIColor { return UIColor.grapePurple }
    var settingsSubtitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var disclosureTintColor: UIColor { return UIColor.paleGrey }
    var imageTintColor: UIColor { return UIColor.paleGrey  }
    
    // MARK: - LoadViewStyle
    var loadCircleColor: UIColor { return UIColor.squash }
    var loadBaseViewColor: UIColor { return UIColor.paleGrey }
    var loadCoverViewColor: UIColor { return UIColor.paleGrey }
    var loadBaseViewAlpha: CGFloat { return 0.6 }
    var loadCoverViewAlpha: CGFloat { return 0.2 }
}
