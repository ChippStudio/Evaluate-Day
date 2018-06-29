//
//  TitleCardNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol TitleNodeStyle {
    var titleTitleColor: UIColor { get }
    var titleTitleFont: UIFont { get }
    var titleSubtitleColor: UIColor { get }
    var titleSubtitleFont: UIFont { get }
    var titleShareTintColor: UIColor { get }
}

class TitleNode: ASCellNode {
    
    // MARK: - UI
    var title: ASTextNode = ASTextNode()
    var subtitle: ASTextNode = ASTextNode()
    var previewImage: ASImageNode = ASImageNode()
    var shareButton: ASButtonNode = ASButtonNode()
    
    // MARK: - Variable
    var topInset: CGFloat = 10.0

    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, style: TitleNodeStyle) {
        super.init()
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: style.titleTitleFont, NSAttributedStringKey.foregroundColor: style.titleTitleColor])
        self.subtitle.attributedText = NSAttributedString(string: subtitle, attributes: [NSAttributedStringKey.font: style.titleSubtitleFont, NSAttributedStringKey.foregroundColor: style.titleSubtitleColor])
        self.previewImage.image = image
        self.previewImage.contentMode = .scaleAspectFit
        self.shareButton.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        self.shareButton.imageNode.contentMode = .scaleAspectFit
        self.shareButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.titleShareTintColor)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.previewImage.style.preferredSize = CGSize(width: 30.0, height: 30.0)
        self.shareButton.style.preferredSize = CGSize (width: 50.0, height: 50.0)
        
        let text = ASStackLayoutSpec.vertical()
//        text.spacing = 5.0
        text.style.flexShrink = 1.0
        text.children = [self.title, self.subtitle]
        
        let spacing = ASLayoutSpec()
        spacing.style.flexGrow = 1.0
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 10.0
        cell.style.flexGrow = 1.0
        cell.alignItems = .start
        cell.children = [self.previewImage, text, spacing, self.shareButton]
        
        let cellInsets = UIEdgeInsets(top: self.topInset, left: 10.0, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
