//
//  SettingsProNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 11/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol SettingsProNodeStyle {
    var proTitleColor: UIColor { get }
    var proTitleIsProColor: UIColor { get }
    var proTitleFont: UIFont { get }
    var proSubtitleColor: UIColor { get }
    var proSubtitleFont: UIFont { get }
    var proTintColor: UIColor { get }
}
class SettingsProNode: ASCellNode {

    // MARK: - UI
    var images = [ASImageNode]()
    var titleNode = ASTextNode()
    var subtileNode = ASTextNode()
    
    // MARK: - Init
    init(pro: Bool, style: SettingsProNodeStyle) {
        super.init()
        
        // Set images
        let first = ASImageNode()
        first.image = #imageLiteral(resourceName: "sandClock").withRenderingMode(.alwaysTemplate)
        first.style.preferredSize = CGSize(width: 30.0, height: 30.0)
        self.images.append(first)
        let second = ASImageNode()
        second.image = #imageLiteral(resourceName: "analytics").withRenderingMode(.alwaysTemplate)
        second.style.preferredSize = CGSize(width: 30.0, height: 30.0)
        self.images.append(second)
        let proImg = ASImageNode()
        proImg.image = #imageLiteral(resourceName: "pro").withRenderingMode(.alwaysTemplate)
        proImg.style.preferredSize = CGSize(width: 85.0, height: 30.0)
        self.images.append(proImg)
        let third = ASImageNode()
        third.image = #imageLiteral(resourceName: "list").withRenderingMode(.alwaysTemplate)
        third.style.preferredSize = CGSize(width: 30.0, height: 30.0)
        self.images.append(third)
        let fourth = ASImageNode()
        fourth.image = #imageLiteral(resourceName: "new").withRenderingMode(.alwaysTemplate)
        fourth.style.preferredSize = CGSize(width: 30.0, height: 30.0)
        self.images.append(fourth)
        
        for i in self.images {
            i.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.proTintColor)
        }
        
        let center = NSMutableParagraphStyle()
        center.alignment = .center
        
        var titleString = Localizations.settings.pro.node.title
        var titleColor = style.proTitleColor
        
        var subtitleString = Localizations.settings.pro.node.subtitle
        
        if pro {
            titleString = Localizations.settings.pro.node.ispro.title
            subtitleString = Localizations.settings.pro.node.ispro.subtitle
            titleColor = style.proTitleIsProColor
        }
        
        self.titleNode.attributedText = NSAttributedString(string: titleString, attributes: [NSAttributedStringKey.font: style.proTitleFont, NSAttributedStringKey.foregroundColor: titleColor, NSAttributedStringKey.paragraphStyle: center])
        self.subtileNode.attributedText = NSAttributedString(string: subtitleString, attributes: [NSAttributedStringKey.font: style.proSubtitleFont, NSAttributedStringKey.foregroundColor: style.proSubtitleColor, NSAttributedStringKey.paragraphStyle: center])
        
        //Accessibility
        self.isAccessibilityElement = true
        self.accessibilityLabel = "\(titleString), \(subtitleString)"
        self.accessibilityTraits = UIAccessibilityTraitButton
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let icons = ASStackLayoutSpec.horizontal()
        icons.spacing = 20.0
        icons.children = self.images
        
        let text = ASStackLayoutSpec.vertical()
        text.children = [self.titleNode, self.subtileNode]
        
        let cell = ASStackLayoutSpec.vertical()
        cell.alignItems = .center
        cell.spacing = 15.0
        cell.children = [icons, text]
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
