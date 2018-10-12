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
    var backView = ASDisplayNode()
    
    // MARK: - Init
    init(image: UIImage, title: String, subtitle: String, style: SettingsProDescriptionMoreNodeStyle) {
        super.init()
        
        self.selectionStyle = .none
        
        self.image.image = image
        self.image.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.settingsProDescriptionMoreImageTintColor)
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: style.settingsProDescriptionMoreTitleFont, NSAttributedStringKey.foregroundColor: style.settingsProDescriptionMoreTitleColor])
        self.subtitle.attributedText = NSAttributedString(string: subtitle, attributes: [NSAttributedStringKey.font: style.settingsProDescriptionMoreSubtitleFont, NSAttributedStringKey.foregroundColor: style.settingsProDescriptionMoreSubtitleColor])
        
        self.backView.backgroundColor = UIColor.lightGray
        self.backView.cornerRadius = 30.0
        self.backView.alpha = 0.1
        
        self.isAccessibilityElement = true
        self.accessibilityLabel = title
        self.accessibilityValue = subtitle
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.image.style.preferredSize = CGSize(width: 60.0, height: 60.0)
        self.subtitle.style.flexShrink = 1.0
        
        let description = ASStackLayoutSpec.horizontal()
        description.spacing = 10.0
        description.alignItems = .start
        description.children = [self.image, self.subtitle]
        
        let content = ASStackLayoutSpec.vertical()
        content.spacing = 10.0
        content.children = [self.title, description]
        
        let contentInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.backView)
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
