//
//  LightCardSettingTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 03/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct LightCardSettingsTheme: CardSettingsStyle {
    // General controller
    var background: UIColor { return UIColor.snow }
    var barColor: UIColor { return UIColor.snow }
    var barTint: UIColor { return UIColor.viridian }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    
    // MARK: - CardSettings Text
    var cardSettingsTextPlaceholder: UIColor { return UIColor.lightGray }
    var cardSettingsText: UIColor { return UIColor.gunmetal }
    var cardSettingsTextTitle: UIColor { return UIColor.gunmetal }
    var cardSettingsTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .medium) }
    var cardSettingsTextTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    
    // MARK: - CardSettings Boolean
    var settingsBooleanTitle: UIColor { return UIColor.gunmetal}
    var settingsBooleanTitleFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var settingsBooleanOnTintColor: UIColor { return UIColor.viridian }
    var settingsBooleanTintColor: UIColor { return UIColor.gunmetal }
    var settingsBooleanThumbTintColor: UIColor { return UIColor.clear }
    
    // MARK: - Description Node
    var descriptionNodeTextColor: UIColor { return UIColor.gunmetal}
    var descriptionNodeTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - SettingsMoreNodeStyle
    var settingsTitleNodeColor: UIColor { return UIColor.gunmetal }
    var settingsTitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var settingsSubtitleNodeColor: UIColor { return UIColor.viridian }
    var settingsSubtitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var disclosureTintColor: UIColor { return UIColor.gunmetal }
    var imageTintColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - SeparatorNodeStyle
    var separatorNodeColor: UIColor { return UIColor.lightGray }
    
    // MARK: - CardSettingsSectionTitleNodeStyle
    var cardSettingsSectionTitleFont: UIFont { return UIFont.avenirNext(size: 13.0, weight: .regular) }
    var cardSettingsSectionTitleColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - SettingsNotificationNodeStyle
    var settingsNotificationMessageColor: UIColor { return UIColor.gunmetal }
    var settingsNotificationMessageFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var settingsNotificationTimeColor: UIColor { return UIColor.lightGray }
    var settingsNotificationTimeFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var settingsNotificationCardColor: UIColor { return UIColor.viridian }
    var settingsNotificationCardFont: UIFont { return UIFont.avenirNext(size: 15.0, weight: .regular) }
}
