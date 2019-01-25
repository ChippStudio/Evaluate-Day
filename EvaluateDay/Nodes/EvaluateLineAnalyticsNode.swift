//
//  EvaluateLineAnalyticsNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 02/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class EvaluateLineAnalyticsNode: ASCellNode {
    
    // MARK: - UI
    var lines = [ASDisplayNode]()
    var cover = ASDisplayNode()
    var disclosure = ASImageNode()
    var analytics = ASImageNode()
    var standart = ASDisplayNode()
    var button = ASButtonNode()
    
    // MARK: - Variables
    
    // MARK: - Init
    init(values: [Float], maxValue: Float) {
        
        super.init()
        
        for v in values {
            let l = ASDisplayNode()
            l.backgroundColor = UIColor.textTint
            l.cornerRadius = 2.5
            var value: Float = 5.0
            if ((50.0 * v) / maxValue) > value {
                value = (50.0 * v) / maxValue
            }
            l.style.preferredSize = CGSize(width: 5.0, height: Double(value))
            self.lines.append(l)
        }
        
        self.cover.backgroundColor = UIColor.main
        self.cover.cornerRadius = 10.0
        
        self.disclosure.image = UIImage(named: "disclosure")?.resizedImage(newSize: CGSize(width: 8.0, height: 13.0))
        self.disclosure.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.textTint)
        
        self.analytics.image = Images.Media.analytics.image.resizedImage(newSize: CGSize(width: 24.0, height: 24.0))
        self.analytics.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.textTint)
        
        self.button.addTarget(self, action: #selector(self.analyticsInitialAction(sender:)), forControlEvents: .touchDown)
        self.button.addTarget(self, action: #selector(self.analyticsEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.button.addTarget(self, action: #selector(self.analyticsEndAction(sender:)), forControlEvents: .touchUpInside)
        self.button.addTarget(self, action: #selector(self.analyticsEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.standart.backgroundColor = UIColor.clear
        self.standart.style.preferredSize = CGSize(width: 5.0, height: 50.0)
        
        self.lines.insert(self.standart, at: 0)
        
        self.button.accessibilityLabel = Localizations.Accessibility.Analytics.open
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let linesStack = ASStackLayoutSpec.horizontal()
        linesStack.spacing = 15.0
        linesStack.alignItems = .center
        linesStack.children = self.lines
        
        let analyticsStack = ASStackLayoutSpec.horizontal()
        analyticsStack.spacing = 5
        analyticsStack.alignItems = .center
        analyticsStack.children = [self.analytics, self.disclosure]
        
        let content = ASStackLayoutSpec.horizontal()
        content.justifyContent = .spaceBetween
        content.alignItems = .center
        content.children = [linesStack, analyticsStack]
        
        let contentInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)
        let cellButton = ASOverlayLayoutSpec(child: cell, overlay: self.button)
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cellButton)
        
        return cellInset
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
