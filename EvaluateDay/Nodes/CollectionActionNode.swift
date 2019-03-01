//
//  CollectionActionNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 30/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CollectionActionNode: ASCellNode {
    // MARK: - UI
    var title = ASTextNode()
    var imageNode: ASImageNode!
    var disclosureImage = ASImageNode()
    
    var cover = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, image: UIImage?, isMarked: Bool) {
        super.init()
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title3), NSAttributedString.Key.foregroundColor: UIColor.text])
        
        if image != nil {
            self.imageNode = ASImageNode()
            self.imageNode.image = image
            self.imageNode.contentMode = .scaleAspectFit
            self.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        }
        
        self.disclosureImage.image = #imageLiteral(resourceName: "disclosure")
        self.disclosureImage.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        
        self.cover.backgroundColor = UIColor.background
        self.cover.cornerRadius = 10.0
        
        //Accessibility
        self.cover.isAccessibilityElement = true
        self.cover.accessibilityLabel = title
        self.cover.accessibilityTraits = UIAccessibilityTraits.button
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.title.style.flexShrink = 1.0
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        let texts = ASStackLayoutSpec.horizontal()
        texts.spacing = 10.0
        texts.alignItems = .start
        texts.style.flexGrow = 1.0
        texts.children = [self.title, spacer]
        
        let imageTitle = ASStackLayoutSpec.horizontal()
        imageTitle.spacing = 20.0
        imageTitle.alignItems = .start
        imageTitle.style.flexGrow = 1.0
        imageTitle.children = [texts]
        if self.imageNode != nil {
            self.imageNode.style.preferredSize = CGSize(width: 25.0, height: 25.0)
            imageTitle.children?.insert(self.imageNode, at: 0)
        }
        
        self.disclosureImage.style.preferredSize = CGSize(width: 8.0, height: 13.0)
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 10.0
        cell.alignItems = .center
        cell.style.flexGrow = 1.0
        cell.children = [imageTitle, self.disclosureImage]
        
        let cellInsets = UIEdgeInsets(top: 12.0, left: 10.0, bottom: 12.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        let cellCover = ASBackgroundLayoutSpec(child: cellInset, background: self.cover)
        
        let cellCoverInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        let cellCoverInset = ASInsetLayoutSpec(insets: cellCoverInsets, child: cellCover)
        
        return cellCoverInset
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
