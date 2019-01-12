//
//  Settings.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 10/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

enum SettingsItemType {
    case more
    case boolean
    case notification
}

protocol SettingsAction {
    
}

struct SettingsSection {
    var items: [SettingItem]
    let header: String?
    let footer: String?
    
    init(items: [SettingItem], header: String? = nil, footer: String? = nil) {
        self.items = items
        self.header = header
        self.footer = footer
    }
}
struct SettingItem {
    let type: SettingsItemType
    let title: String
    let action: SettingsAction
    var subtitle: String?
    var image: UIImage?
    var options: [String: Any]?
    
    init(title: String, type: SettingsItemType, action: SettingsAction, subtitle: String? = nil, image: UIImage? = nil, options: [String: Any]? = nil) {
        self.title = title
        self.type = type
        self.action = action
        self.subtitle = subtitle
        self.image = image
        self.options = options
    }
}
