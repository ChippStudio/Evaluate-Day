//
//  CardSettingsCollectionNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CardSettingsCollectionNode: ASCellNode {

    // MARK: - UI
    var collectionImage = ASImageNode()
    var collectionTitle = ASTextNode()
    
    var cover = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, image: UIImage?) {
        super.init()
        
        self.cover.backgroundColor = UIColor.background
        self.cover.cornerRadius = 10.0
        
        self.collectionImage.image = image
        self.collectionImage.cornerRadius = 10.0
        self.collectionImage.clipsToBounds = true
        
        self.collectionTitle.attributedText = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.text])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.collectionImage.style.preferredSize = CGSize(width: constrainedSize.max.width - 40.0, height: 120.0)
        
        self.collectionTitle.style.flexShrink = 1.0
        
        let content = ASStackLayoutSpec.vertical()
        content.spacing = 10.0
        content.children = [self.collectionImage, self.collectionTitle]
        
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
