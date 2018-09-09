//
//  BlackSettingsTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 10/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct BlackSettingsTheme: SettingsStyle {
    // MARK: - General controller
    var background: UIColor { return UIColor.black }
    var statusBarStyle: UIStatusBarStyle { return UIStatusBarStyle.lightContent }
    var barColor: UIColor { return UIColor.black }
    var barTint: UIColor { return UIColor.white }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    var settingsSeparatorColor: UIColor { return UIColor.lightGray }
    var settingsSelectColor: UIColor { return UIColor.lightGray }
    var settingsSectionBackground: UIColor { return UIColor.black }
    var footerTintColor: UIColor { return UIColor.white }
    var footerTitleFont: UIFont { return UIFont.avenirNext(size: 22.0, weight: .regular) }
    var footerVersionFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var tableSectionHeaderColor: UIColor { return UIColor.white }
    var tableSectionHeaderFont: UIFont { return UIFont.avenirNext(size: 13.0, weight: .regular) }
    var tableSectionFooterColor: UIColor { return UIColor.white }
    var tableSectionFooterFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var aboutTintColor: UIColor { return UIColor.white }
    var aboutAppTitleFont: UIFont { return UIFont.avenirNext(size: 48.0, weight: .regular) }
    var aboutVersionFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    var aboutShareFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var aboutSectionTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var aboutInfoFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var aboutMadeInFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    var aboutLogoTint: UIColor { return UIColor.white }
    var safariTintColor: UIColor { return UIColor.smokyBlack }
    
    // MARK: - SettingsMoreNodeStyle
    var settingsTitleNodeColor: UIColor { return UIColor.white }
    var settingsTitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var settingsSubtitleNodeColor: UIColor { return UIColor.white }
    var settingsSubtitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var disclosureTintColor: UIColor { return UIColor.white }
    var imageTintColor: UIColor { return UIColor.white  }
    
    // MARK: - SettinfsBooleanNodeStyle
    var settingsBooleanOnTintColor: UIColor { return UIColor.salmon }
    var settingsBooleanTintColor: UIColor { return UIColor.white }
    var settingsBooleanThumbTintColor: UIColor { return UIColor.clear }
    
    // MARK: - SettingsNotificationNodeStyle
    var settingsNotificationMessageColor: UIColor { return UIColor.white }
    var settingsNotificationMessageFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var settingsNotificationTimeColor: UIColor { return UIColor.lightGray }
    var settingsNotificationTimeFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var settingsNotificationCardColor: UIColor { return UIColor.salmon }
    var settingsNotificationCardFont: UIFont { return UIFont.avenirNext(size: 15.0, weight: .regular) }
    
    // MARK: - Title Node
    var titleTitleColor: UIColor { return UIColor.white }
    var titleTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var titleSubtitleColor: UIColor { return UIColor.gray }
    var titleSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var titleShareTintColor: UIColor { return UIColor.white }
    var titleDashboardFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .medium) }
    var titleDashboardColor: UIColor { return UIColor.pewterBlue }
    
    // MARK: - SettingsProDescriptionNodeStyle
    var proDescriptionTextColor: UIColor { return UIColor.white }
    var proDescriptionMainTextFont: UIFont { return UIFont.avenirNext(size: 22.0, weight: .demiBold) }
    var proDescriptionListTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var proDescriptionDotColor: UIColor { return UIColor.salmon }
    var proDescriptionMoreButtonFont: UIFont { return UIFont.avenirNext(size: 17.0, weight: .bold) }
    var proDescriptionMoreButtonColor: UIColor { return UIColor.salmon }
    var proDescriptionMoreButtonHighlightedColor: UIColor { return UIColor.white }
    
    // MARK: - SettingsProButtonNodeStyle
    var proButtonTextColor: UIColor { return UIColor.white }
    var proButtonTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .medium) }
    var proButtonCoverColor: UIColor { return UIColor.salmon }
    var proSecondaryTextColor: UIColor { return UIColor.white }
    var proButtonSelectedColor: UIColor { return UIColor.brownishRed }
    
    // MARK: - SettingsProReviewNodeStyle
    var proReviewProTitleColor: UIColor { return UIColor.lightGray }
    var proReviewProTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var proReviewProSubtitleColor: UIColor { return UIColor.white }
    var proReviewProSubtitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var proReviewProEmojiSize: CGFloat { return 34.0 }
    var proReviewProSubscriptionTitleColor: UIColor { return UIColor.lightGray }
    var proReviewProSubscriptionTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var proReviewProSubscriptionValidColor: UIColor { return UIColor.white }
    var proReviewProSubscriptionValidFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var proReviewProDescriptionLabelColor: UIColor { return UIColor.gray }
    var proReviewProDescriptionLabelFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - SettingsProNodeStyle
    var proTitleColor: UIColor { return UIColor.salmon }
    var proTitleIsProColor: UIColor { return UIColor.pewterBlue }
    var proTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .demiBold) }
    var proSubtitleColor: UIColor { return UIColor.white }
    var proSubtitleFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var proTintColor: UIColor { return UIColor.white }
    
    // MARK: - ProMoreViewControllerStyle
    var proMoreViewControllerCoverColor: UIColor { return UIColor.smokyBlack }
    var proMoreViewControllerCoverAlpha: CGFloat { return 0.7 }
    var proMoreViewControllerButtonsCover: UIColor { return UIColor.white }
    var proMoreViewControllerButtonsFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .demiBold) }
    var proMoreViewControllerButtonsColor: UIColor { return UIColor.smokyBlack }
    
    // MARK: - SettingsProDescriptionMoreNodeStyle
    var settingsProDescriptionMoreTitleColor: UIColor { return UIColor.white }
    var settingsProDescriptionMoreTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var settingsProDescriptionMoreSubtitleColor: UIColor { return UIColor.lightGray }
    var settingsProDescriptionMoreSubtitleFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .medium) }
    var settingsProDescriptionMoreImageTintColor: UIColor { return UIColor.white }
    var settingsProDescriptionMoreSeparatorColor: UIColor { return UIColor.lightGray }
    
    // MARK: - PrivacyAndEulaNodeStyle
    var privacyButtonTextColor: UIColor { return UIColor.salmon }
    var privacyButtonTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var eulaButtonTextColor: UIColor { return UIColor.salmon }
    var eulaButtonTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var descriptionTextColor: UIColor { return UIColor.white }
    var descriptionTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - DescriptionNodeStyle
    var descriptionNodeTextColor: UIColor { return UIColor.lightGray }
    var descriptionNodeTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - InfoNodeStyle
    var infoNodeTintColor: UIColor { return UIColor.white }
    var infoNodeTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .demiBold) }
    
    // MARK: - SettingsIconSelectNodeStyle
    var settingsIconSelectNodeSelectedColor: UIColor { return UIColor.salmon }
}
