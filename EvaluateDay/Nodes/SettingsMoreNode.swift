//
//  SettingsMoreNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 10/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class SettingsMoreNode: ASCellNode {
    // MARK: - UI
    var title = ASTextNode()
    var subtitle: ASTextNode!
    var imageNode: ASImageNode!
    var disclosureImage = ASImageNode()
    
    var cover = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, subtitle: String?, image: UIImage?, titleAttributes: [NSAttributedStringKey: NSObject]? = nil) {
        super.init()
        
        self.cover.backgroundColor = UIColor.main
        self.cover.cornerRadius = 10.0
        
        var titleNewAttributes = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.tint]
        if titleAttributes != nil {
            titleNewAttributes = titleAttributes!
        }
        self.title.attributedText = NSAttributedString(string: title, attributes: titleNewAttributes)
        
        if subtitle != nil {
            self.subtitle = ASTextNode()
            let right = NSMutableParagraphStyle()
            right.alignment = .right
            self.subtitle.attributedText = NSAttributedString(string: subtitle!, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedStringKey.foregroundColor: UIColor.tint, NSAttributedStringKey.paragraphStyle: right])
        }
        
        if image != nil {
            self.imageNode = ASImageNode()
            self.imageNode.image = image?.resizedImage(newSize: CGSize(width: 26.0, height: 26.0))
            self.imageNode.contentMode = .scaleAspectFit
            self.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.tint)
        }
        
        self.disclosureImage.image = Images.Media.disclosure.image
        self.disclosureImage.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.tint)
        
        //Accessibility
        self.isAccessibilityElement = true
        self.accessibilityLabel = title
        self.accessibilityValue = subtitle
        self.accessibilityTraits = UIAccessibilityTraitButton
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.title.style.flexShrink = 1.0
        
        let texts: ASStackLayoutSpec
        if self.subtitle == nil {
            texts = ASStackLayoutSpec.horizontal()
            texts.spacing = 10.0
        } else {
            if constrainedSize.max.width - (self.title.attributedText!.size().width + self.subtitle.attributedText!.size().width) > 100.0 {
                texts = ASStackLayoutSpec.horizontal()
                texts.alignItems = .center
                texts.spacing = 10.0
            } else {
                texts = ASStackLayoutSpec.vertical()
                texts.alignItems = .start
                texts.spacing = 0.0
            }
        }
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        texts.style.flexGrow = 1.0
        texts.children = [self.title, spacer]
        if self.subtitle != nil {
            self.subtitle.style.flexShrink = 1.0
            texts.children?.append(self.subtitle)
        }
        
        let imageTitle = ASStackLayoutSpec.horizontal()
        imageTitle.spacing = 10.0
        imageTitle.alignItems = .center
        imageTitle.style.flexGrow = 1.0
        imageTitle.children = [texts]
        if self.imageNode != nil {
            self.imageNode.style.preferredSize = CGSize(width: 26.0, height: 26.0)
            imageTitle.children?.insert(self.imageNode, at: 0)
        }
        
        self.disclosureImage.style.preferredSize = CGSize(width: 8.0, height: 13.0)

        let content = ASStackLayoutSpec.horizontal()
        content.spacing = 10.0
        content.alignItems = .center
        content.style.flexGrow = 1.0
        content.children = [imageTitle, self.disclosureImage]
        
        let contentInsets = UIEdgeInsets(top: 15.0, left: 10.0, bottom: 15.0, right: 10.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)

        let cellInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
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
