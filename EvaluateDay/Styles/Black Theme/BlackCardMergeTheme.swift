//
//  BlackCardMergeStyle.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 01/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct BlackCardMergeTheme: CardMergeStyle {
    // General controller
    var background: UIColor { return UIColor.black }
    var barColor: UIColor { return UIColor.black }
    var barTint: UIColor { return UIColor.white }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    
    // MARK: - TitleNodeStyle
    var titleTitleColor: UIColor { return UIColor.white }
    var titleTitleFont: UIFont { return UIFont.avenirNext(size: 24.0, weight: .bold) }
    var titleSubtitleColor: UIColor { return UIColor.white }
    var titleSubtitleFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var titleShareTintColor: UIColor { return UIColor.white }
    
    // MARK: - SettingsMoreNodeStyle
    var settingsTitleNodeColor: UIColor { return UIColor.white }
    var settingsTitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .medium) }
    var settingsSubtitleNodeColor: UIColor {return UIColor.salmon }
    var settingsSubtitleNodeFont: UIFont { return UIFont.avenirNext(size: 18.0, weight: .regular) }
    var disclosureTintColor: UIColor { return UIColor.white }
    var imageTintColor: UIColor { return UIColor.white }
    
    // MARK: - DescriptionNodeStyle
    var descriptionNodeTextColor: UIColor { return UIColor.white }
    var descriptionNodeTextFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    
    // MARK: - BigDescriptionNodeStyle
    var bigDescriptionNodeTextColor: UIColor { return UIColor.white }
    var bigDescriptionNodeTextFont: UIFont { return UIFont.avenirNext(size: 26.0, weight: .regular) }
    var bigDescriptionNodeSeparatorColor: UIColor { return UIColor.lightGray }
    
    // MARK: - SettingsProButtonNodeStyle
    var proButtonTextColor: UIColor { return UIColor.smokyBlack }
    var proButtonTextFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var proButtonCoverColor: UIColor { return UIColor.white }
    var proButtonSelectedColor: UIColor { return UIColor.salmon }
    var proSecondaryTextColor: UIColor { return UIColor.white }
}
