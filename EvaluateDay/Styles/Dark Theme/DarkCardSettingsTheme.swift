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
    
    // MARK: - CardSettings Text
    var cardSettingsTextPlaceholder: UIColor { return UIColor.lightGray }
    var cardSettingsText: UIColor { return UIColor.white }
    var cardSettingsTextTitle: UIColor { return UIColor.white }
    var cardSettingsTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .medium) }
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
}
