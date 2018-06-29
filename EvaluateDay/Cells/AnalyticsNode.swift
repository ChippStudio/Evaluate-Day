//
//  AnalyticsNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 15/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol AnalyticsNodeStyle {
    var analyticsNodeTextColor: UIColor { get }
    var analyticsNodeTextFont: UIFont { get }
    var analyticsNodeTintColor: UIColor { get }
}

class AnalyticsNode: ASCellNode {
    // MARK: - UI
    var title = ASTextNode()
    var image = ASImageNode()
    var button = ASButtonNode()
    
    // MARK: - Init
    init(style: AnalyticsNodeStyle) {
        super.init()
        
        self.title.attributedText = NSAttributedString(string: Localizations.analytics.action, attributes: [NSAttributedStringKey.font: style.analyticsNodeTextFont, NSAttributedStringKey.foregroundColor: style.analyticsNodeTextColor])
        self.image.image = #imageLiteral(resourceName: "analyticsB")
        self.image.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.analyticsNodeTintColor)
        
        self.button.accessibilityIdentifier = "analytics"
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.image.style.preferredSize = CGSize(width: 20.0, height: 20.0)
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 15.0
        cell.alignItems = .center
        cell.children = [self.image, self.title]
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 15.0, bottom: 20.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        let overlay = ASOverlayLayoutSpec(child: cellInset, overlay: self.button)
        
        return overlay
    }
}
