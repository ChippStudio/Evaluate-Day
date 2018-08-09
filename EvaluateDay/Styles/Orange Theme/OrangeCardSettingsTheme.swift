//
//  DarkCardSettingTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 03/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct OrangeCardSettingsTheme: CardSettingsStyle {
    // General controller
    var background: UIColor { return UIColor.squash }
    var barColor: UIColor { return UIColor.squash }
    var barTint: UIColor { return UIColor.paleGrey }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    var dangerZoneFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var dangerZoneDeleteColor: UIColor { return UIColor.grapePurple }
    var dangerZoneMergeColor: UIColor { return UIColor.paleGrey }
    var dangerZoneArchiveColor: UIColor { return UIColor.darkBlueGreen }
    
    // MARK: - CardSettings Text
    var cardSettingsTextPlaceholder: UIColor { return UIColor.lightGray }
    var cardSettingsText: UIColor { return UIColor.paleGrey }
    var cardSettingsTextTitle: UIColor { return UIColor.paleGrey }
    var cardSettingsTextFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var cardSettingsTextTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    
    // MARK: - CardSettings Boolean
    var settingsBooleanTitle: UIColor { return UIColor.paleGrey}
    var settingsBooleanTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var settingsBooleanOnTintColor: UIColor { return UIColor.grapePurple }
    var settingsBooleanTintColor: UIColor { return UIColor.paleGrey }
    var settingsBooleanThumbTintColor: UIColor { return UIColor.clear }
    
    // MARK: - Description Node
    var descriptionNodeTextColor: UIColor { return UIColor.paleGrey}
    var descriptionNodeTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - SettingsMoreNodeStyle
    var settingsTitleNodeColor: UIColor { return UIColor.paleGrey }
    var settingsTitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var settingsSubtitleNodeColor: UIColor { return UIColor.darkBlueGreen }
    var settingsSubtitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var disclosureTintColor: UIColor { return UIColor.paleGrey }
    var imageTintColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - SeparatorNodeStyle
    var separatorNodeColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - CardSettingsSectionTitleNodeStyle
    var cardSettingsSectionTitleFont: UIFont { return UIFont.avenirNext(size: 13.0, weight: .regular) }
    var cardSettingsSectionTitleColor: UIColor { return UIColor.white }
    
    // MARK: - SettingsNotificationNodeStyle
    var settingsNotificationMessageColor: UIColor { return UIColor.paleGrey }
    var settingsNotificationMessageFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var settingsNotificationTimeColor: UIColor { return UIColor.white }
    var settingsNotificationTimeFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var settingsNotificationCardColor: UIColor { return UIColor.grapePurple }
    var settingsNotificationCardFont: UIFont { return UIFont.avenirNext(size: 15.0, weight: .regular) }
}
