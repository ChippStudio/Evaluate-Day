//
//  Theme.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

enum ThemeType: Int {
    case light
    case dark
    case orange
    case black
    
    var string: String {
        get {
            switch self {
            case .light:
                return "Light"
            case .dark:
                return "Dark"
            case .orange:
                return "Orange"
            case .black:
                return "Black"
            }
        }
    }
}

struct Theme {
    var previewImage: UIImage
    var type: ThemeType
    var iconName: String?
}
