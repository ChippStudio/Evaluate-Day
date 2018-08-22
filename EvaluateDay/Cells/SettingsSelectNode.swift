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
    
    // MARK: - Variable
    var topInset: CGFloat = 10.0
    var leftInset: CGFloat = 15.0
    
    var select: Bool = false {
        didSet {
            if select == true {
                self.selectImage.alpha = 1.0
                self.accessibilityValue = Localizations.accessibility.selected
            } else {
                self.selectImage.alpha = 0.0
                self.accessibilityValue = Localizations.accessibility.unselected
            }
        }
    }
    
    // MARK: - Init
    init(title: String, subtitle: String?, image: UIImage?, style: SettingsMoreNodeStyle) {
        super.init()
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: style.settingsTitleNodeFont, NSAttributedStringKey.foregroundColor: style.settingsTitleNodeColor])
        
        if subtitle != nil {
            self.subtitle = ASTextNode()
            self.subtitle.attributedText = NSAttributedString(string: subtitle!, attributes: [NSAttributedStringKey.font: style.settingsSubtitleNodeFont, NSAttributedStringKey.foregroundColor: style.settingsSubtitleNodeColor])
        }
        
        if image != nil {
            self.imageNode = ASImageNode()
            self.imageNode.image = image
        }
        
        self.selectImage.image = #imageLiteral(resourceName: "done")
        self.selectImage.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.disclosureTintColor)
        
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraitButton
        self.accessibilityLabel = title
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spacing = ASLayoutSpec()
        spacing.style.flexGrow = 1.0
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 10.0
        cell.alignItems = .center
        cell.children = [self.title, spacing]
        if self.subtitle != nil {
            cell.children?.append(self.subtitle)
        }
        if self.imageNode != nil {
            self.imageNode.style.preferredSize = CGSize(width: 25.0, height: 25.0)
            self.imageNode.cornerRadius = 3.0
            cell.children?.insert(self.imageNode, at: 0)
        }
        
        self.selectImage.style.preferredSize = CGSize(width: 20.0, height: 20.0)
        cell.children?.append(self.selectImage)
        
        let cellInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
