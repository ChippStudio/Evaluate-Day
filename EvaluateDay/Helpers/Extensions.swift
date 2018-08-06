//
//  Extensions.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

// MARK: - UUID
extension UUID {
    static var id: String {
        get {
            let uuid = UUID().uuidString
            let chartersSet = CharacterSet(charactersIn: "-")
            return uuid.components(separatedBy: chartersSet).joined(separator: "").lowercased()
        }
    }
}

// MARK: - String
extension String {
    var color: UIColor {
        let scanner = Scanner(string: self)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        let color = UIColor(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
        
        return color
    }
}

// MARK: - UIImage
extension UIImage {
    convenience init(color: UIColor, size: CGSize) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage: image.cgImage!)
    }
    
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func increaseSize(by value: CGFloat) -> UIImage {
        // Guard newSize is different
        var newSize = self.size
        newSize.width += value
        newSize.height += value
        
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

// MARK: - Date
extension Date {
    var start: Date {
        get {
            return Calendar.current.startOfDay(for: self)
        }
    }
    var end: Date {
        get {
            var components = DateComponents()
            components.day = 1
            components.second = -1
            return Calendar.current.date(byAdding: components, to: self.start)!
        }
    }
    func days(to: Date) -> Int {
        let component = Calendar.current.dateComponents([.day], from: self, to: to)
        if let day = component.day {
            return day
        }
        
        return 0
    }
    func minutes(to: Date) -> Int {
        let component = Calendar.current.dateComponents([.minute], from: self, to: to)
        if let minute = component.minute {
            return minute
        }
        
        return 0
    }
}

// MARK: - UIView
extension UIView {
    var snapshot: UIImage? {
        get {
            UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
            let context = UIGraphicsGetCurrentContext()
            if context == nil {
                UIGraphicsEndImageContext()
                return nil
            }
            self.layer.render(in: context!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            return image
        }
    }
}

// MARK: - Int
extension Int {
    var random: Int {
        get {
            let randomNum: UInt32 = arc4random_uniform(UInt32(self))
            return Int(randomNum)
        }
    }
}

// MARK: - ASCellNode
extension ASCellNode {
    func visual(withStyle style: EvaluableStyle) {
        self.backgroundColor = style.cardColor
        self.cornerRadius = 10.0
        
        self.shadowColor = style.cardShadowColor.cgColor
        self.shadowRadius = 4.0
        self.shadowOpacity = 0.2
        self.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.clipsToBounds = false
    }
}
