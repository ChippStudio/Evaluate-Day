//
//  LightMapControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 13/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct OrangeMapControllerTheme: MapViewControllerStyle {
    var blurStyle: UIBlurEffectStyle { return .dark }
    var tintColor: UIColor { return UIColor.paleGrey }
    var deleteTintColor: UIColor { return UIColor.grapePurple }
    
    var checkInDataStreetFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .bold)}
    var checkInDataOtherAddressFont: UIFont { return UIFont.avenirNext(size: 14.0, weight: .regular) }
    var checkInDataCoordinatesFont: UIFont { return UIFont.avenirNext(size: 10.0, weight: .regular) }
}
