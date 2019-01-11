//
//  ProDescriptionCellNode.swift
//  Rency
//
//  Created by Konstantin Tsistjakov on 19/07/2017.
//  Copyright © 2017 Chipp Studio. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol SettingsProDescriptionNodeStyle {
    var proDescriptionTextColor: UIColor { get }
    var proDescriptionMainTextFont: UIFont { get }
    var proDescriptionListTextFont: UIFont { get }
    var proDescriptionDotColor: UIColor { get }
    var proDescriptionMoreButtonFont: UIFont { get }
    var proDescriptionMoreButtonColor: UIColor { get }
    var proDescriptionMoreButtonHighlightedColor: UIColor { get }
}

class SettingsProDescriptionNode: ASCellNode {
    
    // MARK: - UI
    var descriptionNode = ASTextNode()
    var descriptionList = [(dot: ASDisplayNode, text: ASDisplayNode)]()
    var moreButton = ASButtonNode()
    
    // MARK: - Variable
    let list = [Localizations.Settings.Pro.Description.first, Localizations.Settings.Pro.Description.second, Localizations.Settings.Pro.Description.third, Localizations.Settings.Pro.Description.fourth]
    var moreDidSelected: (() -> Void)?
    
    // MARK: - Init
    init(style: SettingsProDescriptionNodeStyle) {
        super.init()
        
        descriptionNode.attributedText = NSAttributedString(string: Localizations.Settings.Pro.Description.title, attributes: [NSAttributedStringKey.font: style.proDescriptionMainTextFont, NSAttributedStringKey.foregroundColor: style.proDescriptionTextColor])
        
        let buttonTitle = NSAttributedString(string: Localizations.Settings.Pro.Description.More.title, attributes: [NSAttributedStringKey.font: style.proDescriptionMoreButtonFont, NSAttributedStringKey.foregroundColor: style.proDescriptionMoreButtonColor])
        
        self.moreButton.setAttributedTitle(buttonTitle, for: .normal)
        
        self.moreButton.addTarget(self, action: #selector(moreButtonAction(sender:)), forControlEvents: .touchUpInside)
        
        for item in list {
            let dot = ASDisplayNode()
            dot.cornerRadius = 5.0
            dot.backgroundColor = style.proDescriptionDotColor
            
            let text = ASTextNode()
            text.attributedText = NSAttributedString(string: item, attributes: [NSAttributedStringKey.font: style.proDescriptionListTextFont, NSAttributedStringKey.foregroundColor: style.proDescriptionTextColor])
            
            self.descriptionList.append((dot: dot, text: text))
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let descriptionInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 10.0, right: 15.0)
        let descriptionInset = ASInsetLayoutSpec(insets: descriptionInsets, child: descriptionNode)
        
        var itemsList = [ASLayoutSpec]()
        
        for elemets in self.descriptionList {
            let dot = elemets.dot
            dot.style.preferredSize = CGSize(width: 10.0, height: 10.0)
            
            elemets.text.style.flexShrink = 1.0
            
            let hSpec = ASStackLayoutSpec.horizontal()
            hSpec.spacing = 10.0
            hSpec.alignItems = .center
            hSpec.children = [dot, elemets.text]
            itemsList.append(hSpec)
        }
        
        let itemsSpec = ASStackLayoutSpec.vertical()
        itemsSpec.spacing = 10.0
        itemsSpec.children = itemsList
        
        let itemsInsets = UIEdgeInsets(top: 0.0, left: 25.0, bottom: 0.0, right: 15.0)
        let itemsInset = ASInsetLayoutSpec(insets: itemsInsets, child: itemsSpec)
        itemsInset.style.flexShrink = 1.0
        
        let buttonInsets = UIEdgeInsets(top: 10.0, left: CGFloat.infinity, bottom: 10.0, right: 20.0)
        let buttonInset = ASInsetLayoutSpec(insets: buttonInsets, child: self.moreButton)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.children = [descriptionInset, itemsInset, buttonInset]
        return cell
    }
    
    // MARK: - Actions
    @objc func moreButtonAction(sender: ASButtonNode) {
        self.moreDidSelected?()
    }
}
