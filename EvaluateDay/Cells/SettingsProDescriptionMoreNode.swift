//
//  SettingsProDescriptionMoreNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol SettingsProDescriptionMoreNodeStyle {
    var settingsProDescriptionMoreTitleColor: UIColor { get }
    var settingsProDescriptionMoreTitleFont: UIFont { get }
    var settingsProDescriptionMoreSubtitleColor: UIColor { get }
    var settingsProDescriptionMoreSubtitleFont: UIFont { get }
    var settingsProDescriptionMoreImageTintColor: UIColor { get }
    var settingsProDescriptionMoreSeparatorColor: UIColor { get }
}

class SettingsProDescriptionMoreNode: ASCellNode {
    // MARK: - UI
    var image = ASImageNode()
    var title = ASTextNode()
    var subtitle = ASTextNode()
    var separator = ASDisplayNode()
    
    // MARK: - Init
    init(image: UIImage, title: String, subtitle: String, style: SettingsProDescriptionMoreNodeStyle) {
        super.init()
        
        self.selectionStyle = .none
        
        self.image.image = image
        self.image.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.settingsProDescriptionMoreImageTintColor)
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: style.settingsProDescriptionMoreTitleFont, NSAttributedStringKey.foregroundColor: style.settingsProDescriptionMoreTitleColor])
        self.subtitle.attributedText = NSAttributedString(string: subtitle, attributes: [NSAttributedStringKey.font: style.settingsProDescriptionMoreSubtitleFont, NSAttributedStringKey.foregroundColor: style.settingsProDescriptionMoreSubtitleColor])
        
        self.separator.backgroundColor = style.settingsProDescriptionMoreSeparatorColor
        
        self.isAccessibilityElement = true
        self.accessibilityLabel = title
        self.accessibilityValue = subtitle
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let text = ASStackLayoutSpec.vertical()
        text.style.flexShrink = 1.0
        text.children = [self.title, self.subtitle]
        
        let textInsets = UIEdgeInsets(top: -5.0, left: 0.0, bottom: 0.0, right: 0.0)
        let textInset = ASInsetLayoutSpec(insets: textInsets, child: text)
        textInset.style.flexShrink = 1.0
        
        self.image.style.preferredSize = CGSize(width: 25.0, height: 25.0)
        
        let content = ASStackLayoutSpec.horizontal()
        content.spacing = 20.0
        content.alignItems = .start
        content.children = [self.image, textInset]
        
        let contentInsets = UIEdgeInsets(top: 30.0, left: 20.0, bottom: 10.0, right: 10.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        self.separator.style.preferredSize.height = 0.3
        
        let separatorInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        let separatorInset = ASInsetLayoutSpec(insets: separatorInsets, child: self.separator)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.children = [contentInset, separatorInset]
        
        return cell
    }
}
