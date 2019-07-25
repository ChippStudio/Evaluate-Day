//
//  CardSettingsEditSiriNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/07/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CardSettingsEditSiriNode: ASCellNode {
    // MARK: - UI
    var title = ASTextNode()
    var siriCover = ASDisplayNode()
    var siriLabel = ASTextNode()
    var siriIcon = ASImageNode()
    var siriPhrase = ASTextNode()
    
    var cover = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, phrase: String) {
        super.init()
        
        self.cover.backgroundColor = UIColor.background
        self.cover.cornerRadius = 10.0
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.text])
        
        self.siriCover.cornerRadius = 8.0
        self.siriCover.backgroundColor = UIColor.background
        self.siriCover.borderColor = UIColor.main.cgColor
        self.siriCover.borderWidth = 1.0
        
        self.siriIcon.image = Images.Media.siriCheckmark.image
        self.siriIcon.contentMode = .scaleAspectFill
        self.siriIcon.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.inverseBackground)
        
        self.siriLabel.attributedText = NSAttributedString(string: Localizations.Siri.Settings.add, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedString.Key.foregroundColor: UIColor.text])
        
        self.siriPhrase.attributedText = NSAttributedString(string: "\"" + phrase + "\"", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2), NSAttributedString.Key.foregroundColor: UIColor.main])
        
        self.automaticallyManagesSubnodes = true
    }
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.siriIcon.style.preferredSize = CGSize(width: 25.0, height: 25.0)
        let texts = ASStackLayoutSpec.vertical()
        texts.children = [self.siriLabel, self.siriPhrase]
        
        let siriIconAndLabel = ASStackLayoutSpec.horizontal()
        siriIconAndLabel.alignItems = .center
        siriIconAndLabel.spacing = 10.0
        siriIconAndLabel.children = [self.siriIcon, texts]
        
        let siriIconInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let siriIconInset = ASInsetLayoutSpec(insets: siriIconInsets, child: siriIconAndLabel)
        
        let siriBadge = ASBackgroundLayoutSpec(child: siriIconInset, background: self.siriCover)
        
        let content = ASStackLayoutSpec.horizontal()
        content.flexWrap = .wrap
        content.spacing = 10.0
        content.alignItems = .center
        content.justifyContent = .spaceBetween
        content.children = [self.title, siriBadge]
        
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
