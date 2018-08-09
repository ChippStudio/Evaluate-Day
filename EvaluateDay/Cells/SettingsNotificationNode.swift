//
//  SettingsNotificationNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 30/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol SettingsNotificationNodeStyle {
    var settingsNotificationMessageColor: UIColor { get }
    var settingsNotificationMessageFont: UIFont { get }
    var settingsNotificationTimeColor: UIColor { get }
    var settingsNotificationTimeFont: UIFont { get }
    var settingsNotificationCardColor: UIColor { get }
    var settingsNotificationCardFont: UIFont { get }
}

class SettingsNotificationNode: ASCellNode {

    // MARK: - UI
    var message = ASTextNode()
    var information = ASTextNode()
    
    // MARK: - Variables
    var leftInset: CGFloat = 15.0
    
    // MARK: - Init
    init(message: String, time: String, localizedRepeat: String, card: String, style: SettingsNotificationNodeStyle) {
        super.init()
        
        self.message.attributedText = NSAttributedString(string: message, attributes: [NSAttributedStringKey.font: style.settingsNotificationMessageFont, NSAttributedStringKey.foregroundColor: style.settingsNotificationMessageColor])
        
        let timeString = NSMutableAttributedString(string: time + " - " + localizedRepeat + " " + card, attributes: [NSAttributedStringKey.font: style.settingsNotificationTimeFont, NSAttributedStringKey.foregroundColor: style.settingsNotificationTimeColor])
        timeString.addAttributes([NSAttributedStringKey.font: style.settingsNotificationCardFont, NSAttributedStringKey.foregroundColor: style.settingsNotificationCardColor], range: (timeString.string as NSString).range(of: card))
        
        self.information.attributedText = timeString
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let cell = ASStackLayoutSpec.vertical()
        cell.children = [self.message, self.information]
        
        let cellInsets = UIEdgeInsets(top: 5.0, left: leftInset, bottom: 5.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
