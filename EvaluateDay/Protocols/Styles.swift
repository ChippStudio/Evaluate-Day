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
    var cardArchiveColor: UIColor { get }
    var cardShadowColor: UIColor { get }
    var barColor: UIColor { get }
    var barTint: UIColor { get }
    var barTitleFont: UIFont { get }
    var barLargeTitleFont: UIFont { get }
    var tableNodeSeparatorColor: UIColor { get }
    var actionSheetTintColor: UIColor { get }
    var imageInfoDateLabelFont: UIFont { get }
    var imageInfoCoordinatesFont: UIFont { get }
    var imageInfoPlaceFont: UIFont { get }
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

protocol DashboardSettingsStyle: DashboardTitleNodeStyle {
    var background: UIColor { get }
    var barColor: UIColor { get }
    var barTint: UIColor { get }
    var barTitleFont: UIFont { get }
    var barLargeTitleFont: UIFont { get }
    var tableSeparatorColor: UIColor { get }
}

protocol CardSettingsStyle: EditableSectionStyle {
    var background: UIColor { get }
    var barColor: UIColor { get }
    var barTint: UIColor { get }
    var barTitleFont: UIFont { get }
    var barLargeTitleFont: UIFont { get }
    var tableSectionHeaderColor: UIColor { get }
    var tableSectionHeaderFont: UIFont { get }
    var dangerZoneFont: UIFont { get }
    var dangerZoneDeleteColor: UIColor { get }
    var dangerZoneMergeColor: UIColor { get }
    var dangerZoneArchiveColor: UIColor { get }
}

protocol CardMergeStyle: MergeSectionStyle {
    var background: UIColor { get }
    var barColor: UIColor { get }
    var barTint: UIColor { get }
    var barTitleFont: UIFont { get }
    var barLargeTitleFont: UIFont { get }
}

protocol SettingsStyle: SettingsMoreNodeStyle, SettingsBooleanNodeStyle, SettingsNotificationNodeStyle, SettingsProButtonNodeStyle, SettingsProDescriptionNodeStyle, SettingsProReviewNodeStyle, PrivacyAndEulaNodeStyle, DescriptionNodeStyle, InfoNodeStyle, SettingsProDescriptionMoreNodeStyle, ProMoreViewControllerStyle, SettingsIconSelectNodeStyle {
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
    var closeButtonColor: UIColor { get }
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

protocol ShareViewStyle {
    var shareViewBackgroundColor: UIColor { get }
    var shareViewTitleColor: UIColor { get }
    var shareViewLinkColor: UIColor { get }
    var shareViewTitleFont: UIFont { get }
    var shareViewLinkFont: UIFont { get }
    var shareViewIconImage: UIImage { get }
    
    // Controller
    var shareControllerBackground: UIColor { get }
    var shareControllerCloseTintColor: UIColor { get }
    var shareControllerShareButtonColor: UIColor { get }
    var shareControllerShareButtonTextColor: UIColor { get }
    var shareControllerShareButtonTextHighlightedColor: UIColor { get }
    var shareControllerShareButtonTextFont: UIFont { get }
}

protocol SlidesViewControllerStyle: WelcomeLastSlideNodeStyle, WelcomeImageNodeStyle, DescriptionNodeStyle {
    var background: UIColor { get }
    var pageIndicatorColor: UIColor { get }
    var currentPageIndicatorColor: UIColor { get }
}
