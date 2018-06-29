//
//  DarkPasscodeControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 28/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct DarkPasscodeControllerTheme: PasscodeStyle {
    var background: UIColor { return UIColor.gunmetal }
    var messageFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var messageColor: UIColor { return UIColor.white }
    var dotTintColor: UIColor { return UIColor.white }
    var buttonMainFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .regular) }
    var buttonSubFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
    var buttonMainColor: UIColor { return UIColor.white }
    var buttonSubColor: UIColor { return UIColor.salmon }
}
