//
//  WelcomeImageNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 14/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol WelcomeImageNodeStyle {
    var welcomeImageNodeTextFont: UIFont { get }
}

class WelcomeImageNode: ASCellNode {
    
    // MARK: - UI
    var imageNode: ASImageNode = ASImageNode()
    var cover = ASDisplayNode()
    var label = ASTextNode()
    
    // MARK: - Init
    init(image: UIImage?, text: String, style: WelcomeImageNodeStyle) {
        super.init()
        
        self.imageNode.image = image
        self.imageNode.clipsToBounds = true
        self.imageNode.cornerRadius = 10.0
        
        let right = NSMutableParagraphStyle()
        right.alignment = .right
        
        self.label.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: style.welcomeImageNodeTextFont, NSAttributedStringKey.paragraphStyle: right])
        
        self.cover.backgroundColor = UIColor.black
        self.cover.alpha = 0.4
        self.cover.cornerRadius = 10.0
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let textInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        let textInset = ASInsetLayoutSpec(insets: textInsets, child: self.label)
        
        let coverText = ASBackgroundLayoutSpec(child: textInset, background: self.cover)
        
        let coverInsets = UIEdgeInsets(top: CGFloat.infinity, left: 0.0, bottom: 0.0, right: 0.0)
        let coverInset = ASInsetLayoutSpec(insets: coverInsets, child: coverText)
        
        let cell = ASOverlayLayoutSpec(child: imageNode, overlay: coverInset)
        
        let cellInsets = UIEdgeInsets(top: 40.0, left: 20.0, bottom: 60.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
