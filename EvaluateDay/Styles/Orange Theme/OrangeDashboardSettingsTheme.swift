//
//  OrangeDashboardSettingsTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 04/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

struct OrangeDashboardSettingsTheme: DashboardSettingsStyle {
    // General controller
    var background: UIColor { return UIColor.squash }
    var barColor: UIColor { return UIColor.squash }
    var barTint: UIColor { return UIColor.paleGrey }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    var tableSeparatorColor: UIColor { return UIColor.white }
    
    // MARK: - DashboardTitleNodeStyle
    var dashbordTitleNodeTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var dashbordTitleNodeTitleColor: UIColor { return UIColor.paleGrey }
    var dashbordTitleNodeButtonColor: UIColor { return UIColor.darkBlueGreen }
    var dashbordTitleNodeButtonTint: UIColor { return UIColor.paleGrey }
}
