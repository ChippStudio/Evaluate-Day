//
//  DashboardsNoneNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 06/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol DashboardsNoneNodeStyle {
    var dashboardsNoneNodeTitleFont: UIFont { get }
    var dashboardsNoneNodeTitleColor: UIColor { get }
    var dashboardsNoneNodeSubtitleFont: UIFont { get }
    var dashboardsNoneNodeSubtitleColor: UIColor { get }
    var dashboardsNoneNodeTintColor: UIColor { get }
}

class DashboardsNoneNode: ASCellNode {
    
    // MARK: - UI
    var imageView = ASImageNode()
    var title = ASTextNode()
    var subtitle = ASTextNode()
    var rightNode = ASDisplayNode()
    var leftNode = ASDisplayNode()

    // MARK: - Init
    init(style: DashboardsNoneNodeStyle) {
        super.init()
        
        self.imageView.image = #imageLiteral(resourceName: "speedometer")
        self.imageView.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.dashboardsNoneNodeTintColor)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        self.title.attributedText = NSAttributedString(string: Localizations.collection.title, attributes: [NSAttributedStringKey.font: style.dashboardsNoneNodeTitleFont, NSAttributedStringKey.foregroundColor: style.dashboardsNoneNodeTitleColor])
        
        self.subtitle.attributedText = NSAttributedString(string: Localizations.collection.addNew, attributes: [NSAttributedStringKey.font: style.dashboardsNoneNodeSubtitleFont, NSAttributedStringKey.foregroundColor: style.dashboardsNoneNodeSubtitleColor, NSAttributedStringKey.paragraphStyle: paragraph])
        
        self.rightNode.backgroundColor = style.dashboardsNoneNodeTintColor
        self.leftNode.backgroundColor = style.dashboardsNoneNodeTintColor
        
        self.isAccessibilityElement = true
        self.accessibilityLabel = Localizations.collection.title
        self.accessibilityValue = Localizations.collection.addNew
        self.accessibilityTraits = UIAccessibilityTraitButton
        
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.imageView.style.preferredSize = CGSize(width: 45.0, height: 45.0)
        self.leftNode.style.preferredSize = CGSize(width: 125.0, height: 1.0)
        self.rightNode.style.preferredSize = CGSize(width: 125.0, height: 1.0)
        
        self.subtitle.style.flexShrink = 1.0
        
        let image = ASStackLayoutSpec.horizontal()
        image.spacing = 5.0
        image.alignItems = .center
        image.style.flexGrow = 1.0
        image.children = [self.leftNode, self.imageView, self.rightNode]
        
        let text = ASStackLayoutSpec.vertical()
        text.children = [self.title, self.subtitle]
        text.alignItems = .center
        text.style.flexShrink = 1.0
        
        let cell = ASStackLayoutSpec.vertical()
        cell.alignItems = .center
        cell.spacing = 20.0
        cell.children = [image, text]
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 40.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
