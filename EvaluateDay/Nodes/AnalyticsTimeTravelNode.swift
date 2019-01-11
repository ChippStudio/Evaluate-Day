//
//  AnalyticsTimeTravelNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/08/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol AnalyticsTimeTravelNodeStyle {
    var analyticsTimeTravelNodeTitleColor: UIColor { get }
    var analyticsTimeTravelNodeTitleFont: UIFont { get }
}

class AnalyticsTimeTravelNode: ASCellNode {
    // MARK: - UI
    var title = ASTextNode()
    var image = ASImageNode()
    
    // MARK: - Init
    init(style: AnalyticsTimeTravelNodeStyle) {
        super.init()
        
        let parahraph = NSMutableParagraphStyle()
        parahraph.alignment = .center
        
        self.title.attributedText = NSAttributedString(string: Localizations.Analytics.timeTravel, attributes: [NSAttributedStringKey.font: style.analyticsTimeTravelNodeTitleFont, NSAttributedStringKey.foregroundColor: style.analyticsTimeTravelNodeTitleColor, NSAttributedStringKey.paragraphStyle: parahraph])
        
        self.image.image = #imageLiteral(resourceName: "timeTravel")
        self.image.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.analyticsTimeTravelNodeTitleColor)
        
        // Accessibility
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraitButton
        self.accessibilityLabel = Localizations.Analytics.timeTravel
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.image.style.preferredSize = CGSize(width: 30.0, height: 30.0)
        
        self.title.style.flexShrink = 1.0
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 20.0
        cell.alignItems = .center
        cell.justifyContent = .center
        cell.style.flexShrink = 1.0
        cell.children = [self.title, self.image]
        
        let cellInsets = UIEdgeInsets(top: 40.0, left: 0.0, bottom: 40.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
