//
//  LightTabControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 28/06/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct DarkTabControllerTheme: TabControllerStyle {
    // MARK: - General
    var background: UIColor { return UIColor.charcoal }
    var tabTintColor: UIColor { return UIColor.white }
    var tabSelectedColor: UIColor { return UIColor.pewterBlue }
}
