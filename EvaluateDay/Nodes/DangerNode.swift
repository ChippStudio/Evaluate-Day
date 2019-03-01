//
//  SettingsMoreNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 10/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class DangerNode: ASCellNode {
    // MARK: - UI
    var title = ASTextNode()
    var imageNode: ASImageNode!
    
    var cover = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, image: UIImage?, color: UIColor) {
        super.init()
        
        self.cover.backgroundColor = UIColor.background
        self.cover.cornerRadius = 10.0
        
        let titleNewAttributes = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: color]
        self.title.attributedText = NSAttributedString(string: title, attributes: titleNewAttributes)
        
        if image != nil {
            self.imageNode = ASImageNode()
            self.imageNode.image = image?.resizedImage(newSize: CGSize(width: 26.0, height: 26.0))
            self.imageNode.contentMode = .scaleAspectFit
            self.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(color)
        }
        
        //Accessibility
        self.isAccessibilityElement = true
        self.accessibilityLabel = title
        self.accessibilityTraits = UIAccessibilityTraits.button
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.title.style.flexShrink = 1.0
        
        let content = ASStackLayoutSpec.horizontal()
        content.spacing = 10.0
        content.alignItems = .center
        content.style.flexGrow = 1.0
        content.children = [self.title]
        if self.imageNode != nil {
            self.imageNode.style.preferredSize = CGSize(width: 26.0, height: 26.0)
            content.children?.insert(self.imageNode, at: 0)
        }
        
        let contentInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)

        let cellInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
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
