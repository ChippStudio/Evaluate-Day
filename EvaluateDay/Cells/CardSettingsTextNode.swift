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
    var topInset: CGFloat = 0.0
    
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
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let texts = ASStackLayoutSpec.vertical()
        texts.spacing = 5
        texts.children = [self.title, self.text]
        
        let textInsets = UIEdgeInsets(top: self.topInset, left: 15.0, bottom: 0.0, right: 15.0)
        let textInset = ASInsetLayoutSpec(insets: textInsets, child: texts)
        
        return textInset
    }
}
