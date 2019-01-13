//
//  EvaluateDotsAnalyticsNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 03/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class EvaluateDotsAnalyticsNode: ASCellNode {
    
    // MARK: - UI
    var dots = [ASDisplayNode]()
    var cover = ASDisplayNode()
    var disclosure = ASImageNode()
    var analytics = ASImageNode()
    var button = ASButtonNode()
    
    // MARK: - Init
    init(values: [Bool]) {
        super.init()
        
        for v in values {
            let l = ASDisplayNode()
            l.style.preferredSize = CGSize(width: 16.0, height: 16.0)
            if v {
                l.backgroundColor = UIColor.tint
            } else {
                l.borderWidth = 1.0
                l.borderColor = UIColor.tint.cgColor
            }
            l.cornerRadius = 8.0
            self.dots.append(l)
        }
        
        self.cover.backgroundColor = UIColor.main
        self.cover.cornerRadius = 10.0
        
        self.button.addTarget(self, action: #selector(self.analyticsInitialAction(sender:)), forControlEvents: .touchDown)
        self.button.addTarget(self, action: #selector(self.analyticsEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.button.addTarget(self, action: #selector(self.analyticsEndAction(sender:)), forControlEvents: .touchUpInside)
        self.button.addTarget(self, action: #selector(self.analyticsEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.disclosure.image = UIImage(named: "disclosure")?.resizedImage(newSize: CGSize(width: 8.0, height: 13.0))
        self.disclosure.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.tint)
        
        self.analytics.image = Images.Media.analytics.image.resizedImage(newSize: CGSize(width: 24.0, height: 24.0))
        self.analytics.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.tint)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let dotsStack = ASStackLayoutSpec.horizontal()
        dotsStack.spacing = 10.0
        dotsStack.children = self.dots
        
        let dotsInsets = UIEdgeInsets(top: 22.0, left: 0.0, bottom: 22.0, right: 0.0)
        let dotsInset = ASInsetLayoutSpec(insets: dotsInsets, child: dotsStack)
        
        let analyticsStack = ASStackLayoutSpec.horizontal()
        analyticsStack.spacing = 5
        analyticsStack.alignItems = .center
        analyticsStack.children = [self.analytics, self.disclosure]
        
        let content = ASStackLayoutSpec.horizontal()
        content.spacing = 10.0
        content.justifyContent = .spaceBetween
        content.children = [dotsInset, analyticsStack]
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        let buttonStack = ASOverlayLayoutSpec(child: cellInset, overlay: self.button)
        
        return buttonStack
    }
    
    // MARK: - Actions
    @objc func analyticsInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func analyticsEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.main
        }
    }
}
