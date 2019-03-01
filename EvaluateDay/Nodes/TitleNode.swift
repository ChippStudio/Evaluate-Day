//
//  TitleCardNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class TitleNode: ASCellNode {
    
    // MARK: - UI
    var title: ASTextNode = ASTextNode()
    var subtitle: ASTextNode = ASTextNode()
    var previewImage: ASImageNode = ASImageNode()

    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage) {
        super.init()
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1), NSAttributedString.Key.foregroundColor: UIColor.text])
        self.subtitle.attributedText = NSAttributedString(string: subtitle, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.text])
        self.previewImage.image = image
        self.previewImage.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.text)
        self.previewImage.contentMode = .scaleAspectFit
        self.previewImage.alpha = 0.5
        
        // Accessibility
        
        self.title.isAccessibilityElement = false
        self.subtitle.isAccessibilityElement = false
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.previewImage.style.preferredSize = CGSize(width: 35.0, height: 35.0)
        
        self.title.style.flexShrink = 1.0
        
        let titleImage = ASStackLayoutSpec.horizontal()
        titleImage.justifyContent = .spaceBetween
        titleImage.spacing = 10.0
        titleImage.children = [self.title, self.previewImage]
        
        let subtitleInsets = UIEdgeInsets(top: 0.0, left: 30.0, bottom: 0.0, right: 20.0)
        let subtitleInset = ASInsetLayoutSpec(insets: subtitleInsets, child: self.subtitle)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.children = [titleImage, subtitleInset]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
