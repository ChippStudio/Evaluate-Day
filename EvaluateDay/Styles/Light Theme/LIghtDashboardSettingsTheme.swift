//
//  LIghtDashboardSettingsTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 04/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

struct LightDashboardSettingsTheme: DashboardSettingsStyle {
    // General controller
    var background: UIColor { return UIColor.snow }
    var barColor: UIColor { return UIColor.snow }
    var barTint: UIColor { return UIColor.viridian }
    var barTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .demiBold) }
    var barLargeTitleFont: UIFont { return UIFont.avenirNext(size: largeTitleFontSize, weight: .demiBold) }
    var tableSeparatorColor: UIColor { return UIColor.lightGray }
    
    // MARK: - DashboardTitleNodeStyle
    var dashbordTitleNodeTitleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var dashbordTitleNodeTitleColor: UIColor { return UIColor.gunmetal }
    var dashbordTitleNodeButtonColor: UIColor { return UIColor.viridian }
    var dashbordTitleNodeButtonTint: UIColor { return UIColor.white }
}
