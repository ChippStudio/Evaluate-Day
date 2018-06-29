//
//  WelcomePermissionButtonNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class WelcomePermissionButtonNode: ASCellNode {
    // MARK: - UI
    var cover = ASDisplayNode()
    var title = ASTextNode()
    var subtitle = ASTextNode()
    var image = ASImageNode()
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, set: Bool) {
        super.init()
        
        self.cover.cornerRadius = 10.0
        self.cover.borderColor = UIColor.gunmetal.cgColor
        self.cover.borderWidth = 1.0
        
        self.image.image = image
        self.image.contentMode = .scaleAspectFit
        if set {
            self.image.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.viridian)
        } else {
           self.image.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.gunmetal)
        }
        
        let center = NSMutableParagraphStyle()
        center.alignment = .left
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.avenirNext(size: 24.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.gunmetal, NSAttributedStringKey.paragraphStyle: center])
        self.subtitle.attributedText = NSAttributedString(string: subtitle, attributes: [NSAttributedStringKey.font: UIFont.avenirNext(size: 14.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.paragraphStyle: center])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.subtitle.style.flexShrink = 1.0
        self.title.style.flexShrink = 1.0
        
        let text = ASStackLayoutSpec.vertical()
        text.style.flexShrink = 1.0
        text.children = [self.title, self.subtitle]
        
        let textInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let textInset = ASInsetLayoutSpec(insets: textInsets, child: text)
        textInset.style.flexShrink = 1.0
        
        self.image.style.preferredSize = CGSize(width: 40.0, height: 40.0)
        let imageInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        let imageInset = ASInsetLayoutSpec(insets: imageInsets, child: self.image)
        
        let items = ASStackLayoutSpec.horizontal()
        items.spacing = 10.0
        items.style.flexShrink = 1.0
        items.alignItems = .center
        items.children = [imageInset, textInset]
        
        let cell = ASBackgroundLayoutSpec(child: items, background: self.cover)
        cell.style.flexShrink = 1.0
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.brownishRed
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.clear
        }
        (self.owningNode as! ASTableNode).delegate?.tableNode?((self.owningNode as! ASTableNode), didSelectRowAt: self.indexPath!)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.clear
        }
    }

}
