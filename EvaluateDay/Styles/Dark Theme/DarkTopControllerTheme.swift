//
//  DarkTopControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 06/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct DarkTopControllerTheme: TopViewControllerStyle {
    var maskColor: UIColor { return UIColor.black }
    var maskAlpha: CGFloat { return 0.7 }
    var topViewColor: UIColor { return UIColor.gunmetal }
    
    // MARK: - TextTopViewControllerStyle
    var titleColor: UIColor { return UIColor.white }
    var titleFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var textColor: UIColor { return UIColor.white }
    var textFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var buttonsFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var buttonsColor: UIColor { return UIColor.white }
}
