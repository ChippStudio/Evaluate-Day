//
//  DarkCardSettingTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 03/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct DarkCardSettingsTheme: CardSettingsStyle {
    // General controller
    var background: UIColor { return UIColor.charcoal }
    var barColor: UIColor { return UIColor.charcoal }
    var barTint: UIColor { return UIColor.white }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    var tableSectionHeaderColor: UIColor { return UIColor.pewterBlue }
    var tableSectionHeaderFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var dangerZoneFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var dangerZoneDeleteColor: UIColor { return UIColor.salmon }
    var dangerZoneMergeColor: UIColor { return UIColor.white }
    var dangerZoneArchiveColor: UIColor { return UIColor.pewterBlue }
    
    // MARK: - CardSettings Text
    var cardSettingsTextPlaceholder: UIColor { return UIColor.lightGray }
    var cardSettingsText: UIColor { return UIColor.white }
    var cardSettingsTextTitle: UIColor { return UIColor.white }
    var cardSettingsTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var cardSettingsTextTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    
    // MARK: - CardSettings Boolean
    var settingsBooleanTitle: UIColor { return UIColor.white}
    var settingsBooleanTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var settingsBooleanOnTintColor: UIColor { return UIColor.salmon }
    var settingsBooleanTintColor: UIColor { return UIColor.white }
    var settingsBooleanThumbTintColor: UIColor { return UIColor.clear }
    
    // MARK: - Description Node
    var descriptionNodeTextColor: UIColor { return UIColor.white}
    var descriptionNodeTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - SettingsMoreNodeStyle
    var settingsTitleNodeColor: UIColor { return UIColor.white }
    var settingsTitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var settingsSubtitleNodeColor: UIColor { return UIColor.pewterBlue }
    var settingsSubtitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var disclosureTintColor: UIColor { return UIColor.white }
    var imageTintColor: UIColor { return UIColor.white }
    
    // MARK: - SeparatorNodeStyle
    var separatorNodeColor: UIColor { return UIColor.lightGray }
    
    // MARK: - CardSettingsSectionTitleNodeStyle
    var cardSettingsSectionTitleFont: UIFont { return UIFont.avenirNext(size: 13.0, weight: .regular) }
    var cardSettingsSectionTitleColor: UIColor { return UIColor.white }
    
    // MARK: - SettingsNotificationNodeStyle
    var settingsNotificationMessageColor: UIColor { return UIColor.white }
    var settingsNotificationMessageFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var settingsNotificationTimeColor: UIColor { return UIColor.lightGray }
    var settingsNotificationTimeFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var settingsNotificationCardColor: UIColor { return UIColor.salmon }
    var settingsNotificationCardFont: UIFont { return UIFont.avenirNext(size: 15.0, weight: .regular) }
}
