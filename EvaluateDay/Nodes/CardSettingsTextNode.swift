//
//  CardSettingsTextNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 03/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CardSettingsTextNode: ASCellNode {
    
    // MARK: - UI
    var title: ASTextNode = ASTextNode()
    var text: ASTextNode = ASTextNode()
    
    var cover = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, text: String) {
        super.init()
        
        self.cover.backgroundColor = UIColor.background
        self.cover.cornerRadius = 10.0
        
        self.title.attributedText = NSAttributedString(string: title.uppercased(), attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        var textColor = UIColor.main
        var textString = text
        if text == "" {
            textColor = UIColor.lightGray
            textString = Localizations.CardSettings.textPlaceholder
        }
        
        self.text.attributedText = NSAttributedString(string: textString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: textColor])
        
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
        
        let content = ASStackLayoutSpec.vertical()
        content.spacing = 5
        content.children = [self.title, textInset]
        
        let contentInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.tint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.background
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.background
        }
    }
}
