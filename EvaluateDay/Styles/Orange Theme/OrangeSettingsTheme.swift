//
//  DarkSettingsTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 10/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct OrangeSettingsTheme: SettingsStyle {
    // MARK: - General controller
    var background: UIColor { return UIColor.squash }
    var statusBarStyle: UIStatusBarStyle { return UIStatusBarStyle.lightContent }
    var barColor: UIColor { return UIColor.squash }
    var barTint: UIColor { return UIColor.paleGrey }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    var settingsSeparatorColor: UIColor { return UIColor.white }
    var settingsSelectColor: UIColor { return UIColor.lightGray }
    var settingsSectionBackground: UIColor { return UIColor.squash }
    var footerTintColor: UIColor { return UIColor.paleGrey }
    var footerTitleFont: UIFont { return UIFont.avenirNext(size: 22.0, weight: .regular) }
    var footerVersionFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var tableSectionHeaderColor: UIColor { return UIColor.paleGrey }
    var tableSectionHeaderFont: UIFont { return UIFont.avenirNext(size: 13.0, weight: .regular) }
    var tableSectionFooterColor: UIColor { return UIColor.paleGrey }
    var tableSectionFooterFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
    var aboutTintColor: UIColor { return UIColor.paleGrey }
    var aboutAppTitleFont: UIFont { return UIFont.avenirNext(size: 48.0, weight: .regular) }
    var aboutVersionFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    var aboutShareFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var aboutSectionTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var aboutInfoFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var aboutMadeInFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    var aboutLogoTint: UIColor { return UIColor.paleGrey }
    var safariTintColor: UIColor { return UIColor.pumpkin }
    
    // MARK: - SettingsMoreNodeStyle
    var settingsTitleNodeColor: UIColor { return UIColor.paleGrey }
    var settingsTitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var settingsSubtitleNodeColor: UIColor { return UIColor.grapePurple }
    var settingsSubtitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var disclosureTintColor: UIColor { return UIColor.paleGrey }
    var imageTintColor: UIColor { return UIColor.paleGrey  }
    
    // MARK: - SettinfsBooleanNodeStyle
    var settingsBooleanOnTintColor: UIColor { return UIColor.grapePurple }
    var settingsBooleanTintColor: UIColor { return UIColor.paleGrey }
    var settingsBooleanThumbTintColor: UIColor { return UIColor.clear }
    
    // MARK: - SettingsNotificationNodeStyle
    var settingsNotificationMessageColor: UIColor { return UIColor.paleGrey }
    var settingsNotificationMessageFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var settingsNotificationTimeColor: UIColor { return UIColor.white }
    var settingsNotificationTimeFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var settingsNotificationCardColor: UIColor { return UIColor.grapePurple }
    var settingsNotificationCardFont: UIFont { return UIFont.avenirNext(size: 15.0, weight: .regular) }
    
    // MARK: - Title Node
    var titleTitleColor: UIColor { return UIColor.paleGrey }
    var titleTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var titleSubtitleColor: UIColor { return UIColor.paleGrey }
    var titleSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var titleShareTintColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - SettingsProDescriptionNodeStyle
    var proDescriptionTextColor: UIColor { return UIColor.paleGrey }
    var proDescriptionMainTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var proDescriptionListTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var proDescriptionDotColor: UIColor { return UIColor.grapePurple }
    var proDescriptionMoreButtonFont: UIFont { return UIFont.avenirNext(size: 17.0, weight: .regular) }
    var proDescriptionMoreButtonColor: UIColor { return UIColor.grapePurple }
    var proDescriptionMoreButtonHighlightedColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - SettingsProButtonNodeStyle
    var proButtonTextColor: UIColor { return UIColor.paleGrey }
    var proButtonTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var proButtonCoverColor: UIColor { return UIColor.grapePurple }
    var proSecondaryTextColor: UIColor { return UIColor.paleGrey }
    var proButtonSelectedColor: UIColor { return UIColor.brownishRed }
    
    // MARK: - SettingsProReviewNodeStyle
    var proReviewProTitleColor: UIColor { return UIColor.white }
    var proReviewProTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var proReviewProSubtitleColor: UIColor { return UIColor.paleGrey }
    var proReviewProSubtitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var proReviewProEmojiSize: CGFloat { return 34.0 }
    var proReviewProSubscriptionTitleColor: UIColor { return UIColor.white }
    var proReviewProSubscriptionTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var proReviewProSubscriptionValidColor: UIColor { return UIColor.paleGrey }
    var proReviewProSubscriptionValidFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var proReviewProDescriptionLabelColor: UIColor { return UIColor.white }
    var proReviewProDescriptionLabelFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - SettingsProNodeStyle
    var proTitleColor: UIColor { return UIColor.grapePurple }
    var proTitleIsProColor: UIColor { return UIColor.darkBlueGreen }
    var proTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .demiBold) }
    var proSubtitleColor: UIColor { return UIColor.paleGrey }
    var proSubtitleFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var proTintColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - ProMoreViewControllerStyle
    var proMoreViewControllerCoverColor: UIColor { return UIColor.pumpkin }
    var proMoreViewControllerCoverAlpha: CGFloat { return 0.7 }
    var proMoreViewControllerButtonsCover: UIColor { return UIColor.paleGrey }
    var proMoreViewControllerButtonsFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var proMoreViewControllerButtonsColor: UIColor { return UIColor.pumpkin }
    
    // MARK: - SettingsProDescriptionMoreNodeStyle
    var settingsProDescriptionMoreTitleColor: UIColor { return UIColor.paleGrey }
    var settingsProDescriptionMoreTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .demiBold) }
    var settingsProDescriptionMoreSubtitleColor: UIColor { return UIColor.white }
    var settingsProDescriptionMoreSubtitleFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var settingsProDescriptionMoreImageTintColor: UIColor { return UIColor.paleGrey }
    var settingsProDescriptionMoreSeparatorColor: UIColor { return UIColor.white }
    
    // MARK: - PrivacyAndEulaNodeStyle
    var privacyButtonTextColor: UIColor { return UIColor.grapePurple }
    var privacyButtonTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var eulaButtonTextColor: UIColor { return UIColor.grapePurple }
    var eulaButtonTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var descriptionTextColor: UIColor { return UIColor.paleGrey }
    var descriptionTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - DescriptionNodeStyle
    var descriptionNodeTextColor: UIColor { return UIColor.white }
    var descriptionNodeTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - InfoNodeStyle
    var infoNodeTintColor: UIColor { return UIColor.paleGrey }
    var infoNodeTitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .demiBold) }
}
