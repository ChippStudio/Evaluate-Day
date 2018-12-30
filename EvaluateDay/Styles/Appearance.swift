//
//  Appearance.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIColor
extension UIColor {
    @nonobjc class var background: UIColor {
        return UIColor.white
    }
    
    @nonobjc class var main: UIColor {
        return UIColor(red: 106.0 / 255.0, green: 130.0 / 255.0, blue: 150.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var tint: UIColor {
        return UIColor(red: 227.0 / 255.0, green: 239.0 / 255.0, blue: 244.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var selected: UIColor {
        return UIColor(red: 37.0 / 255.0, green: 78.0 / 255.0, blue: 112.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var text: UIColor {
        return UIColor(red: 22.0 / 255.0, green: 38.0 / 255.0, blue: 46.0 / 255.0, alpha: 1.0)
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
        for v in self.childViewControllers {
            v.updateAppearance(animated: animated)
        }
    }
}
