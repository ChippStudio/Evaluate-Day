//
//  OnChatEnums.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 22/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Protocols
@objc public protocol OnChatManagerDelegate {
    @objc optional func onChatManager(manager: OnChatManager, registerCellFor type: OnCellType) -> AnyClass?
}

@objc public protocol OnChatBubbleCell {
    var titleLabel: UILabel { get set }
}

@objc public protocol ActionView {
    var complition: ((_ message: String) -> Void)? { get set }
}

// MARK: - Enums
@objc public enum OnCellType: Int {
    case message
    case animation
    case answer
}
