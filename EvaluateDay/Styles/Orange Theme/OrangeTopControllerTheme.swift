//
//  DarkTopControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 06/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct OrangeTopControllerTheme: TopViewControllerStyle {
    var maskColor: UIColor { return UIColor.black }
    var maskAlpha: CGFloat { return 0.7 }
    var topViewColor: UIColor { return UIColor.pumpkin }
    
    // MARK: - TextTopViewControllerStyle
    var titleColor: UIColor { return UIColor.paleGrey }
    var titleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var textColor: UIColor { return UIColor.paleGrey }
    var textFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var buttonsFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .medium) }
    var buttonsColor: UIColor { return UIColor.paleGrey }
}
