//
//  Styles.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

protocol TabControllerStyle {
    var background: UIColor { get }
    var tabTintColor: UIColor { get }
    var tabSelectedColor: UIColor { get }
}

protocol ActivityControllerStyle: ActivitySection, LoadViewStyle {
    var background: UIColor { get }
    var barColor: UIColor { get }
    var barTint: UIColor { get }
    var barTitleFont: UIFont { get }
    var barLargeTitleFont: UIFont { get }
    var settingsTintColor: UIColor { get }
    var settingsCoverColor: UIColor { get }
}

protocol EvaluableStyle: EvaluableSectionStyle, CardListEmptyViewStyle {
    var background: UIColor { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var cardColor: UIColor { get }
    var cardShadowColor: UIColor { get }
    var barColor: UIColor { get }
    var barTint: UIColor { get }
    var barTitleFont: UIFont { get }
    var barLargeTitleFont: UIFont { get }
    var tableNodeSeparatorColor: UIColor { get }
    var actionSheetTintColor: UIColor { get }
}

protocol AnalyticalStyle: AnalyticalSectionStyle {
    var background: UIColor { get }
    var barColor: UIColor { get }
    var barTint: UIColor { get }
    var barTitleFont: UIFont { get }
    var barLargeTitleFont: UIFont { get }
    var tableNodeSeparatorColor: UIColor { get }
}

protocol NewCardStyle: SourceNodeStyle {
    var background: UIColor { get }
    var barColor: UIColor { get }
    var barTint: UIColor { get }
    var barTitleFont: UIFont { get }
    var barLargeTitleFont: UIFont { get }
}

protocol CardSettingsStyle: EditableSectionStyle {
    var background: UIColor { get }
    var barColor: UIColor { get }
    var barTint: UIColor { get }
    var barTitleFont: UIFont { get }
    var barLargeTitleFont: UIFont { get }
}

protocol CardMergeStyle: MergeSectionStyle {
    var background: UIColor { get }
    var barColor: UIColor { get }
    var barTint: UIColor { get }
    var barTitleFont: UIFont { get }
    var barLargeTitleFont: UIFont { get }
}

protocol SettingsStyle: SettingsMoreNodeStyle, SettingsBooleanNodeStyle, SettingsProNodeStyle, SettingsNotificationNodeStyle, TitleNodeStyle, SettingsProButtonNodeStyle, SettingsProDescriptionNodeStyle, SettingsProReviewNodeStyle, PrivacyAndEulaNodeStyle, DescriptionNodeStyle, InfoNodeStyle, SettingsProDescriptionMoreNodeStyle, ProMoreViewControllerStyle {
    var background: UIColor { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var barColor: UIColor { get }
    var barTint: UIColor { get }
    var barTitleFont: UIFont { get }
    var barLargeTitleFont: UIFont { get }
    var settingsSeparatorColor: UIColor { get }
    var settingsSectionBackground: UIColor { get }
    var settingsSelectColor: UIColor { get }
    var footerTintColor: UIColor { get }
    var footerTitleFont: UIFont { get }
    var footerVersionFont: UIFont { get }
    var tableSectionHeaderColor: UIColor { get }
    var tableSectionHeaderFont: UIFont { get }
    var tableSectionFooterColor: UIColor { get }
    var tableSectionFooterFont: UIFont { get }
    var aboutTintColor: UIColor { get }
    var aboutAppTitleFont: UIFont { get }
    var aboutVersionFont: UIFont { get }
    var aboutShareFont: UIFont { get }
    var aboutSectionTitleFont: UIFont { get }
    var aboutInfoFont: UIFont { get }
    var aboutMadeInFont: UIFont { get }
    var aboutLogoTint: UIColor { get }
    var safariTintColor: UIColor { get }
}

protocol TopViewControllerStyle: TextTopViewControllerStyle {
    var maskColor: UIColor { get }
    var maskAlpha: CGFloat { get }
    var topViewColor: UIColor { get }
}

protocol BottomViewControllerStyle: ReorderBottomViewControllerStyle, TimeBottomViewControllerStyle {
    var maskColor: UIColor { get }
    var maskAlpha: CGFloat { get }
    var bottomViewColor: UIColor { get }
}

protocol PasscodeStyle {
    var background: UIColor { get }
    var messageFont: UIFont { get }
    var messageColor: UIColor { get }
    var dotTintColor: UIColor { get }
    var buttonMainFont: UIFont { get }
    var buttonSubFont: UIFont { get }
    var buttonMainColor: UIColor { get }
    var buttonSubColor: UIColor { get }
}

protocol EntryViewControllerStyle: TextNodeStyle, ActionNodeStyle, DateNodeStyle, CheckInActionNodeStyle, CheckInPermissionNodeStyle, CheckInDataEvaluateNodeStyle, WeatherNodeStyle {
    var background: UIColor { get }
    var barColor: UIColor { get }
    var barTint: UIColor { get }
    var barTitleFont: UIFont { get }
    var barLargeTitleFont: UIFont { get }
    var tableNodeSeparatorColor: UIColor { get }
}

protocol ShareViewStyle: EvaluateColorShareViewStyle, EvaluateHundredTenCriterionShareViewStyle, ListShareViewStyle, AnalyticsStackShareViewStyle, EvaluateCheckInShareViewStyle, EvaluateCriterionThreeShareViewStyle, EvaluatePhraseShareViewStyle, EvaluateCounterShareViewStyle, EvaluateHabitShareViewStyle, EvaluateListShareViewStyle, EvaluateGoalShareViewStyle, EvaluateJournalShareViewStyle, CalendarShareViewStyle {
    var background: UIColor { get }
    var borderColor: UIColor { get }
    var titleTint: UIColor { get }
    var titleFont: UIFont { get }
    var descriptionColor: UIColor { get }
    var descriptionFont: UIFont { get }
    
    var cardShareBackground: UIColor { get }
    var cardShareTitleColor: UIColor { get }
    var cardShareTitleFont: UIFont { get }
    var cardShareSubtitleColor: UIColor { get }
    var cardShareSubtitleFont: UIFont { get }
    var cardShareDateColor: UIColor { get }
    var cardShareDateFont: UIFont { get }
    
    var cardSelectedDateColor: UIColor { get }
    var cardSelectedDateFont: UIFont { get }
    var cardSelectedValuePositiveColor: UIColor { get }
    var cardSelectedValueNegativeColor: UIColor { get }
    var cardSelectedValueFont: UIFont { get }
}

protocol SlidesViewControllerStyle: WelcomeLastSlideNodeStyle, WelcomeImageNodeStyle, DescriptionNodeStyle {
    var background: UIColor { get }
    var pageIndicatorColor: UIColor { get }
    var currentPageIndicatorColor: UIColor { get }
}

protocol MapViewControllerStyle {
    var blurStyle: UIBlurEffectStyle { get }
    var tintColor: UIColor { get }
    var deleteTintColor: UIColor { get }
    
    var checkInDataStreetFont: UIFont { get }
    var checkInDataOtherAddressFont: UIFont { get }
    var checkInDataCoordinatesFont: UIFont { get }
}
