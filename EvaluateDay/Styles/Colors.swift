//
//  Colors.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 11/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    @nonobjc class var gunmetal: UIColor {
        return UIColor(red: 65.0 / 255.0, green: 76.0 / 255.0, blue: 88.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var charcoal: UIColor {
        return UIColor(red: 58.0 / 255.0, green: 73.0 / 255.0, blue: 89.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var darkGreyBlue: UIColor {
        return UIColor(red: 41.0 / 255.0, green: 59.0 / 255.0, blue: 79.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var viridian: UIColor {
        return UIColor(red: 32.0 / 255.0, green: 130.0 / 255.0, blue: 93.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var brownishRed: UIColor {
        return UIColor(red: 130.0 / 255.0, green: 32.0 / 255.0, blue: 32.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var salmon: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 107.0 / 255.0, blue: 107.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var booger: UIColor {
        return UIColor(red: 179.0 / 255.0, green: 175.0 / 255.0, blue: 66.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var snow: UIColor {
        return UIColor(red: 249.0 / 255.0, green: 249.0 / 255.0, blue: 249.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var platinum: UIColor {
        return UIColor(red: 232.0 / 255.0, green: 232.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var pewterBlue: UIColor {
        return UIColor(red: 130.0 / 255.0, green: 183.0 / 255.0, blue: 186.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var squash: UIColor {
        return UIColor(red: 233.0 / 255.0, green: 138.0 / 255.0, blue: 21.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var grapePurple: UIColor {
        return UIColor(red: 89.0 / 255.0, green: 17.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var darkBlueGreen: UIColor {
        return UIColor(red: 0.0 / 255.0, green: 59.0 / 255.0, blue:54.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var paleGrey: UIColor {
        return UIColor(red: 236.0 / 255.0, green: 229.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var smokyBlack: UIColor {
        return UIColor(red: 30.0 / 255.0, green: 23.0 / 255.0, blue: 23.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var eerieBlack: UIColor {
        return UIColor(red: 30.0 / 255.0, green: 25.0 / 255.0, blue: 25.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var pumpkin: UIColor {
        return UIColor(red: 214.0 / 255.0, green: 117.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var facebook: UIColor {
        return UIColor(red: 59.0 / 255.0, green: 89.0 / 255.0, blue: 152.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var google: UIColor {
        return UIColor(red: 234.0 / 255.0, green: 67.0 / 255.0, blue: 53.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var twitter: UIColor {
        return UIColor(red: 29.0 / 255.0, green: 161.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
    }
    @nonobjc class var vk: UIColor {
        return UIColor(red: 69.0 / 255.0, green: 102.0 / 255.0, blue: 142.0 / 255.0, alpha: 1.0)
    }
}

let colorsForSelection = [(color: "FFFFFF", name: "white"),
                          (color: "C2382B", name: "GOLDEN GATE BRIDGE"),
                          (color: "D5540B", name: "BURNT ORANGE"),
                          (color: "FFA822", name: "BRIGHT YELLOW"),
                          (color: "D6C297", name: "DARK VANILLA"),
                          (color: "2B3E4F", name: "JAPANESE INDIGO"),
                          (color: "262626", name: "RAISIN BLACK"),
                          (color: "8E42AA", name: "PURPUREUS"),
                          (color: "336271", name: "MYRTLE GREEN"),
                          (color: "1E80B7", name: "CYAN CORNFLOWER BLUE"),
                          (color: "21AF65", name: "GREEN"),
                          (color: "05A086", name: "PAOLO VERONESE GREEN"),
                          (color: "BDC3C7", name: "SILVER SAND"),
                          (color: "7F8C8D", name: "MUMMY'S TOMB"),
                          (color: "2C5037", name: "MUGHAL GREEN"),
                          (color: "59479F", name: "PLUMP PURPLE"),
                          (color: "513B2D", name: "DARK LIVER"),
                          (color: "4F2A4E", name: "PURPLE TAUPE"),
                          (color: "DB5359", name: "DARK TERRA COTTA"),
                          (color: "8FB133", name: "YELLOW-GREEN"),
                          (color: "D55B9C", name: "RASPBERRY PINK"),
                          (color: "672621", name: "LIVER"),
                          (color: "8F725F", name: "SHADOW"),
                          (color: "98ABD3", name: "WILD BLUE YONDER"),
                          (color: "374B7F", name: "PURPLE NAVY")]
