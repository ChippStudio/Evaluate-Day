//
//  Appearance.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Themes
enum Theme: String {
    case darkMode = "DarkMode"
    case blackMode = "BlackMode"
}

// MARK: - UIColor
extension UIColor {
    @nonobjc class var background: UIColor {
        if UserDefaults.standard.bool(forKey: Theme.darkMode.rawValue) {
            
            if UserDefaults.standard.bool(forKey: Theme.blackMode.rawValue) {
                return black
            }
            
            return UIColor(red: 29 / 255.0, green: 30 / 255.0, blue: 31 / 255.0, alpha: 1.0)
        }
        
        return UIColor.white
    }
    
    @nonobjc class var inverseBackground: UIColor {
        if UserDefaults.standard.bool(forKey: Theme.darkMode.rawValue) {
            
            if UserDefaults.standard.bool(forKey: Theme.blackMode.rawValue) {
                return UIColor.white
            }
        }
        
        return UIColor.black
    }
    
    @nonobjc class var main: UIColor {
        return UIColor(red: 106.0 / 255.0, green: 130.0 / 255.0, blue: 150.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var tint: UIColor {
        if UserDefaults.standard.bool(forKey: Theme.darkMode.rawValue) {
            return UIColor(red: 30.0 / 255.0, green: 23.0 / 255.0, blue: 23.0 / 255.0, alpha: 1.0)
        }
        return UIColor(red: 227.0 / 255.0, green: 239.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var textTint: UIColor {
        return UIColor(red: 227.0 / 255.0, green: 239.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var selected: UIColor {
        return UIColor(red: 37.0 / 255.0, green: 78.0 / 255.0, blue: 112.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var text: UIColor {
        if UserDefaults.standard.bool(forKey: Theme.darkMode.rawValue) {
            return UIColor(red: 222 / 255.0, green: 223 / 255.0, blue: 223 / 255.0, alpha: 1.0)
        }
        
        return UIColor(red: 22.0 / 255.0, green: 38.0 / 255.0, blue: 46.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var inverseText: UIColor {
        if UserDefaults.standard.bool(forKey: Theme.darkMode.rawValue) {
            return UIColor(red: 22.0 / 255.0, green: 38.0 / 255.0, blue: 46.0 / 255.0, alpha: 1.0)
        }
        
        return UIColor(red: 222 / 255.0, green: 223 / 255.0, blue: 223 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var positive: UIColor {
        return UIColor(red: 106.0 / 255.0, green: 150.0 / 255.0, blue: 130.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var negative: UIColor {
        return UIColor(red: 150.0 / 255.0, green: 106.0 / 255.0, blue: 106.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var delete: UIColor {
        return UIColor(red: 130.0 / 255.0, green: 32.0 / 255.0, blue: 32.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var pumpkin: UIColor {
        return UIColor(red: 214.0 / 255.0, green: 117.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
    }
    
    // ----
    
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

// MARK: - UIView
extension UIView {
    func didUpdatedAppearance(animated: Bool) {
        for v in self.subviews {
            if let controller = v.parentViewController {
                controller.updateAppearance(animated: animated)
            }
            v.didUpdatedAppearance(animated: animated)
        }
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

// MARK: - UIViewController
extension UIViewController {
    @objc public func updateAppearance(animated: Bool) {
        for v in self.children {
            v.updateAppearance(animated: animated)
        }
    }
}
