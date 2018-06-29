//
//  LightSettingsTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 10/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct LightSettingsTheme: SettingsStyle {
    // MARK: - General controller
    var background: UIColor { return UIColor.snow }
    var statusBarStyle: UIStatusBarStyle { return UIStatusBarStyle.default }
    var barColor: UIColor { return UIColor.snow }
    var barTint: UIColor { return UIColor.viridian }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    var settingsSeparatorColor: UIColor { return UIColor.lightGray }
    var settingsSelectColor: UIColor { return UIColor.lightGray }
    var settingsSectionBackground: UIColor { return UIColor.snow }
    var footerTintColor: UIColor { return UIColor.gunmetal }
    var footerTitleFont: UIFont { return UIFont.avenirNext(size: 22.0, weight: .regular) }
    var footerVersionFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var tableSectionHeaderColor: UIColor { return UIColor.gunmetal }
    var tableSectionHeaderFont: UIFont { return UIFont.avenirNext(size: 13.0, weight: .regular) }
    var tableSectionFooterColor: UIColor { return UIColor.gunmetal }
    var tableSectionFooterFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var aboutTintColor: UIColor { return UIColor.gunmetal }
    var aboutAppTitleFont: UIFont { return UIFont.avenirNext(size: 48.0, weight: .regular) }
    var aboutVersionFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    var aboutShareFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var aboutSectionTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var aboutInfoFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var aboutMadeInFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    var aboutLogoTint: UIColor { return UIColor.charcoal }
    var safariTintColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - SettingsMoreNodeStyle
    var settingsTitleNodeColor: UIColor { return UIColor.gunmetal }
    var settingsTitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var settingsSubtitleNodeColor: UIColor { return UIColor.viridian }
    var settingsSubtitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var disclosureTintColor: UIColor { return UIColor.gunmetal }
    var imageTintColor: UIColor { return UIColor.gunmetal  }
    
    // MARK: - SettinfsBooleanNodeStyle
    var settingsBooleanOnTintColor: UIColor { return UIColor.viridian }
    var settingsBooleanTintColor: UIColor { return UIColor.gunmetal }
    var settingsBooleanThumbTintColor: UIColor { return UIColor.clear }
    
    // MARK: - SettingsNotificationNodeStyle
    var settingsNotificationMessageColor: UIColor { return UIColor.gunmetal }
    var settingsNotificationMessageFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var settingsNotificationTimeColor: UIColor { return UIColor.lightGray }
    var settingsNotificationTimeFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var settingsNotificationCardColor: UIColor { return UIColor.viridian }
    var settingsNotificationCardFont: UIFont { return UIFont.avenirNext(size: 15.0, weight: .regular) }
    
    // MARK: - Title Node
    var titleTitleColor: UIColor { return UIColor.gunmetal }
    var titleTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var titleSubtitleColor: UIColor { return UIColor.gray }
    var titleSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var titleShareTintColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - SettingsProDescriptionNodeStyle
    var proDescriptionTextColor: UIColor { return UIColor.gunmetal }
    var proDescriptionMainTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var proDescriptionListTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var proDescriptionDotColor: UIColor { return UIColor.brownishRed }
    var proDescriptionMoreButtonFont: UIFont { return UIFont.avenirNext(size: 17.0, weight: .regular) }
    var proDescriptionMoreButtonColor: UIColor { return UIColor.brownishRed }
    var proDescriptionMoreButtonHighlightedColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - SettingsProButtonNodeStyle
    var proButtonTextColor: UIColor { return UIColor.white }
    var proButtonTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var proButtonCoverColor: UIColor { return UIColor.gunmetal }
    var proSecondaryTextColor: UIColor { return UIColor.gunmetal }
    var proButtonSelectedColor: UIColor { return UIColor.brownishRed }
    
    // MARK: - SettingsProReviewNodeStyle
    var proReviewProTitleColor: UIColor { return UIColor.lightGray }
    var proReviewProTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var proReviewProSubtitleColor: UIColor { return UIColor.gunmetal }
    var proReviewProSubtitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var proReviewProEmojiSize: CGFloat { return 34.0 }
    var proReviewProSubscriptionTitleColor: UIColor { return UIColor.lightGray }
    var proReviewProSubscriptionTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var proReviewProSubscriptionValidColor: UIColor { return UIColor.gunmetal }
    var proReviewProSubscriptionValidFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var proReviewProDescriptionLabelColor: UIColor { return UIColor.gray }
    var proReviewProDescriptionLabelFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - SettingsProNodeStyle
    var proTitleColor: UIColor { return UIColor.brownishRed }
    var proTitleIsProColor: UIColor { return UIColor.viridian }
    var proTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .demiBold) }
    var proSubtitleColor: UIColor { return UIColor.gunmetal }
    var proSubtitleFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var proTintColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - ProMoreViewControllerStyle
    var proMoreViewControllerCoverColor: UIColor { return UIColor.white }
    var proMoreViewControllerCoverAlpha: CGFloat { return 0.7 }
    var proMoreViewControllerButtonsCover: UIColor { return UIColor.gunmetal }
    var proMoreViewControllerButtonsFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var proMoreViewControllerButtonsColor: UIColor { return UIColor.white }
    
    // MARK: - SettingsProDescriptionMoreNodeStyle
    var settingsProDescriptionMoreTitleColor: UIColor { return UIColor.gunmetal }
    var settingsProDescriptionMoreTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .demiBold) }
    var settingsProDescriptionMoreSubtitleColor: UIColor { return UIColor.lightGray }
    var settingsProDescriptionMoreSubtitleFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var settingsProDescriptionMoreImageTintColor: UIColor { return UIColor.gunmetal }
    var settingsProDescriptionMoreSeparatorColor: UIColor { return UIColor.lightGray }
    
    // MARK: - PrivacyAndEulaNodeStyle
    var privacyButtonTextColor: UIColor { return UIColor.brownishRed }
    var privacyButtonTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var eulaButtonTextColor: UIColor { return UIColor.brownishRed }
    var eulaButtonTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var descriptionTextColor: UIColor { return UIColor.gunmetal }
    var descriptionTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - DescriptionNodeStyle
    var descriptionNodeTextColor: UIColor { return UIColor.lightGray }
    var descriptionNodeTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - InfoNodeStyle
    var infoNodeTintColor: UIColor { return UIColor.gunmetal }
    var infoNodeTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .demiBold) }
}
