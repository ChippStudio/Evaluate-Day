//
//  AllCardsNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class AllCardsNode: ASCellNode {
    
    // MARK: - UI
    var cover = ASDisplayNode()
    var imageNode = ASImageNode()
    var textNode = ASTextNode()
    var disclosure = ASImageNode()
    
    // MARK: - Init
    override init() {
        super.init()
        
        self.cover.backgroundColor = UIColor.main
        self.cover.cornerRadius = 10.0
        
        self.imageNode.image = Images.Media.cards.image
        self.imageNode.contentMode = .scaleAspectFit
        self.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.textTint)
        
        self.disclosure.image = Images.Media.disclosure.image
        self.disclosure.contentMode = .scaleAspectFit
        self.disclosure.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.textTint)
        
        self.textNode.attributedText = NSAttributedString(string: Localizations.Collection.allcards, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title2), NSAttributedString.Key.foregroundColor: UIColor.textTint])
        
        self.textNode.isAccessibilityElement = false
        self.cover.isAccessibilityElement = true
        self.cover.accessibilityLabel = Localizations.Collection.allcards
        self.cover.accessibilityTraits = UIAccessibilityTraits.button
        self.cover.accessibilityIdentifier = "AllCards"
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.imageNode.style.preferredSize = CGSize(width: 26.0, height: 26.0)
        self.disclosure.style.preferredSize = CGSize(width: 14.0, height: 14.0)
        
        let spacing = ASLayoutSpec()
        spacing.style.flexGrow = 1.0
        let items = ASStackLayoutSpec.horizontal()
        items.spacing = 20.0
        items.style.flexGrow = 1.0
        items.alignItems = .center
        items.children = [self.imageNode, self.textNode, spacing, self.disclosure]
        
        let itemsInsets = UIEdgeInsets(top: 12.0, left: 20.0, bottom: 12.0, right: 10.0)
        let itemInset = ASInsetLayoutSpec(insets: itemsInsets, child: items)
        
        let cell = ASBackgroundLayoutSpec(child: itemInset, background: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.selected
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.main
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.main
        }
    }
}
