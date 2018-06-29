//
//  Fonts.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 11/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

enum FontWeight: String {
    case medium = "Medium"
    case regular = "Regular"
    case ultraLight = "UltraLight"
    case italic = "Italic"
    case mediumItalic = "MediumItalic"
    case ultraLightItalic = "UltraLightItalic"
    case bold = "Bold"
    case demiBold = "DemiBold"
    case heavy = "Heavy"
    case boldItalic = "BoldItalic"
    case demiBoldItalic = "DemiBoldItalic"
    case heavyItalic = "HeavyItalic"
}

extension UIFont {
    // MARK: - AvenirNext
    static func avenirNext(size: CGFloat, weight: FontWeight) -> UIFont {
        return UIFont(name: "AvenirNext-\(weight.rawValue)", size: size)!
    }
}
