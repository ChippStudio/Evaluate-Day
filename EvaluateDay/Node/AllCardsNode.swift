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
        
        self.imageNode.image = UIImage(named: "cards")?.resizedImage(newSize: CGSize(width: 26.0, height: 26.0))
        self.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.tint)
        
        self.disclosure.image = UIImage(named: "disclosure")?.resizedImage(newSize: CGSize(width: 8.0, height: 14.0))
        self.disclosure.contentMode = .scaleAspectFit
        self.disclosure.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.tint)
        
        self.textNode.attributedText = NSAttributedString(string: Localizations.Collection.allcards, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .title2), NSAttributedStringKey.foregroundColor: UIColor.tint])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let spacing = ASLayoutSpec()
        spacing.style.flexGrow = 1.0
        let items = ASStackLayoutSpec.horizontal()
        items.spacing = 20.0
        items.style.flexGrow = 1.0
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
