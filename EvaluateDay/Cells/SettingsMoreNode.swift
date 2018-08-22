//
//  SettingsMoreNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 10/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol SettingsMoreNodeStyle {
    var settingsTitleNodeColor: UIColor { get }
    var settingsTitleNodeFont: UIFont { get }
    var settingsSubtitleNodeColor: UIColor { get }
    var settingsSubtitleNodeFont: UIFont { get }
    var disclosureTintColor: UIColor { get }
    var imageTintColor: UIColor { get }
}

class SettingsMoreNode: ASCellNode {
    // MARK: - UI
    var title = ASTextNode()
    var subtitle: ASTextNode!
    var imageNode: ASImageNode!
    var disclosureImage = ASImageNode()
    
    var topInset: CGFloat = 10.0
    var leftInset: CGFloat = 15.0
    
    // MARK: - Init
    init(title: String, subtitle: String?, image: UIImage?, style: SettingsMoreNodeStyle, titleAttributes: [NSAttributedStringKey: NSObject]? = nil) {
        super.init()
        
        var titleNewAttributes = [NSAttributedStringKey.font: style.settingsTitleNodeFont, NSAttributedStringKey.foregroundColor: style.settingsTitleNodeColor]
        if titleAttributes != nil {
            titleNewAttributes = titleAttributes!
        }
        self.title.attributedText = NSAttributedString(string: title, attributes: titleNewAttributes)
        
        if subtitle != nil {
            self.subtitle = ASTextNode()
            let right = NSMutableParagraphStyle()
            right.alignment = .right
            self.subtitle.attributedText = NSAttributedString(string: subtitle!, attributes: [NSAttributedStringKey.font: style.settingsSubtitleNodeFont, NSAttributedStringKey.foregroundColor: style.settingsSubtitleNodeColor, NSAttributedStringKey.paragraphStyle: right])
        }
        
        if image != nil {
            self.imageNode = ASImageNode()
            self.imageNode.image = image
            self.imageNode.contentMode = .scaleAspectFit
            self.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.disclosureTintColor)
        }
        
        self.disclosureImage.image = #imageLiteral(resourceName: "disclosure")
        self.disclosureImage.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.disclosureTintColor)
        
        //Accessibility
        self.isAccessibilityElement = true
        self.accessibilityLabel = title
        self.accessibilityValue = subtitle
        self.accessibilityTraits = UIAccessibilityTraitButton
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.title.style.flexShrink = 1.0
        
        let texts: ASStackLayoutSpec
        if self.subtitle == nil {
            texts = ASStackLayoutSpec.horizontal()
            texts.spacing = 10.0
        } else {
            if constrainedSize.max.width - (self.title.attributedText!.size().width + self.subtitle.attributedText!.size().width) > 100.0 {
                texts = ASStackLayoutSpec.horizontal()
                texts.spacing = 10.0
            } else {
                texts = ASStackLayoutSpec.vertical()
                texts.spacing = 0.0
            }
        }
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        texts.alignItems = .start
        texts.style.flexGrow = 1.0
        texts.children = [self.title, spacer]
        if self.subtitle != nil {
            self.subtitle.style.flexShrink = 1.0
            texts.children?.append(self.subtitle)
        }
        
        let imageTitle = ASStackLayoutSpec.horizontal()
        imageTitle.spacing = 10.0
        imageTitle.alignItems = .start
        imageTitle.style.flexGrow = 1.0
        imageTitle.children = [texts]
        if self.imageNode != nil {
            self.imageNode.style.preferredSize = CGSize(width: 25.0, height: 25.0)
            imageTitle.children?.insert(self.imageNode, at: 0)
        }
        
        self.disclosureImage.style.preferredSize = CGSize(width: 8.0, height: 13.0)

        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 10.0
        cell.alignItems = .center
        cell.style.flexGrow = 1.0
        cell.children = [imageTitle, self.disclosureImage]

        let cellInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)

        return cellInset
    }
}
