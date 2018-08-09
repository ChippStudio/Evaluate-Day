//
//  DarkCardMergeStyle.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 01/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct OrangeCardMergeTheme: CardMergeStyle {
    // General controller
    var background: UIColor { return UIColor.squash }
    var barColor: UIColor { return UIColor.squash }
    var barTint: UIColor { return UIColor.paleGrey }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    
    // MARK: - TitleNodeStyle
    var titleTitleColor: UIColor { return UIColor.paleGrey }
    var titleTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var titleSubtitleColor: UIColor { return UIColor.paleGrey }
    var titleSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var titleShareTintColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - SettingsMoreNodeStyle
    var settingsTitleNodeColor: UIColor { return UIColor.paleGrey }
    var settingsTitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .medium) }
    var settingsSubtitleNodeColor: UIColor {return UIColor.grapePurple }
    var settingsSubtitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var disclosureTintColor: UIColor { return UIColor.paleGrey }
    var imageTintColor: UIColor { return UIColor.paleGrey }
    
    // MARK: - DescriptionNodeStyle
    var descriptionNodeTextColor: UIColor { return UIColor.paleGrey }
    var descriptionNodeTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - BigDescriptionNodeStyle
    var bigDescriptionNodeTextColor: UIColor { return UIColor.paleGrey }
    var bigDescriptionNodeTextFont: UIFont { return UIFont.avenirNext(size: 26.0, weight: .regular) }
    var bigDescriptionNodeSeparatorColor: UIColor { return UIColor.white }
    
    // MARK: - SettingsProButtonNodeStyle
    var proButtonTextColor: UIColor { return UIColor.pumpkin }
    var proButtonTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var proButtonCoverColor: UIColor { return UIColor.paleGrey }
    var proButtonSelectedColor: UIColor { return UIColor.grapePurple }
    var proSecondaryTextColor: UIColor { return UIColor.paleGrey }
}
