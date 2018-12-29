//
//  CardSettingsTextNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 03/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol CardSettingsTextNodeStyle {
    var cardSettingsText: UIColor { get }
    var cardSettingsTextPlaceholder: UIColor { get }
    var cardSettingsTextTitle: UIColor { get }
    var cardSettingsTextFont: UIFont { get }
    var cardSettingsTextTitleFont: UIFont { get }
}

class CardSettingsTextNode: ASCellNode {
    
    // MARK: - UI
    var title: ASTextNode = ASTextNode()
    var text: ASTextNode = ASTextNode()
    
    // MARK: - Variable
    var topInset: CGFloat = 10.0
    
    // MARK: - Init
    init(title: String, text: String, style: CardSettingsTextNodeStyle) {
        super.init()
        
        self.title.attributedText = NSAttributedString(string: title.uppercased(), attributes: [NSAttributedStringKey.font: style.cardSettingsTextTitleFont, NSAttributedStringKey.foregroundColor: style.cardSettingsTextTitle])
        
        var textColor = style.cardSettingsText
        var textString = text
        if text == "" {
            textColor = style.cardSettingsTextPlaceholder
            textString = Localizations.cardSettings.textPlaceholder
        }
        
        self.text.attributedText = NSAttributedString(string: textString, attributes: [NSAttributedStringKey.font: style.cardSettingsTextFont, NSAttributedStringKey.foregroundColor: textColor])
        
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraitButton
        self.accessibilityLabel = title
        self.accessibilityValue = text
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let textInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        let textInset = ASInsetLayoutSpec(insets: textInsets, child: self.text)
        
        let texts = ASStackLayoutSpec.vertical()
        texts.spacing = 5
        texts.children = [self.title, textInset]
        
        let cellInsets = UIEdgeInsets(top: self.topInset, left: 20.0, bottom: 10.0, right: 15.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: texts)
        
        return cellInset
    }
}
