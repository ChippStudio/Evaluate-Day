//
//  SettingsSelectNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 28/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class SettingsSelectNode: ASCellNode {
    // MARK: - UI
    var title = ASTextNode()
    var subtitle: ASTextNode!
    var imageNode: ASImageNode!
    
    private var selectImage = ASImageNode()
    
    var cover = ASDisplayNode()
    
    var select: Bool = false {
        didSet {
            if select == true {
                self.selectImage.alpha = 1.0
                self.accessibilityValue = Localizations.Accessibility.selected
            } else {
                self.selectImage.alpha = 0.0
                self.accessibilityValue = Localizations.Accessibility.unselected
            }
        }
    }
    
    // MARK: - Init
    init(title: String, subtitle: String?, image: UIImage?) {
        super.init()
        
        self.cover.backgroundColor = UIColor.background
        self.cover.cornerRadius = 10.0
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.text])
        
        if subtitle != nil {
            self.subtitle = ASTextNode()
            self.subtitle.attributedText = NSAttributedString(string: subtitle!, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedString.Key.foregroundColor: UIColor.text])
        }
        
        if image != nil {
            self.imageNode = ASImageNode()
            self.imageNode.image = image
        }
        
        self.selectImage.image = Images.Media.done.image
        self.selectImage.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraits.button
        self.accessibilityLabel = title
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spacing = ASLayoutSpec()
        spacing.style.flexGrow = 1.0
        
        let content = ASStackLayoutSpec.horizontal()
        content.spacing = 10.0
        content.alignItems = .center
        content.children = [self.title, spacing]
        if self.subtitle != nil {
            content.children?.append(self.subtitle)
        }
        if self.imageNode != nil {
            self.imageNode.style.preferredSize = CGSize(width: 25.0, height: 25.0)
            self.imageNode.cornerRadius = 3.0
            content.children?.insert(self.imageNode, at: 0)
        }
        
        self.selectImage.style.preferredSize = CGSize(width: 20.0, height: 20.0)
        content.children?.append(self.selectImage)
        
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
