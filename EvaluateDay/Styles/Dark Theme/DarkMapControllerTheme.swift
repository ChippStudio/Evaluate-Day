//
//  LightMapControllerTheme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 13/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

struct DarkMapControllerTheme: MapViewControllerStyle {
    var background: UIColor { return UIColor.charcoal }
    var tintColor: UIColor { return UIColor.white }
    var deleteTintColor: UIColor { return UIColor.salmon }
    
    var checkInDataDeleteFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .bold) }
    var checkInDataStreetFont: UIFont { return UIFont.avenirNext(size: 20.0, weight: .bold) }
    var checkInDataOtherAddressFont: UIFont { return UIFont.avenirNext(size: 16.0, weight: .regular) }
    var checkInDataCoordinatesFont: UIFont { return UIFont.avenirNext(size: 12.0, weight: .regular) }
}
