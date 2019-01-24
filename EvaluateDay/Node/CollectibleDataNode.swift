//
//  CollectibleDataNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CollectibleDataNode: ASCellNode {
    // MARK: - UI
    var imageNode = ASImageNode()
    var titleNode = ASTextNode()
    var dataNode = ASTextNode()
    
    // MARK: - Init
    init(title: String, image: UIImage, data: String) {
        super.init()
        
        self.imageNode.image = image.resizedImage(newSize: CGSize(width: 24.0, height: 24.0)).withRenderingMode(.alwaysTemplate)
        self.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        
        self.titleNode.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .title3), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        self.dataNode.attributedText = NSAttributedString(string: data, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.main])
        
        self.isAccessibilityElement = true
        self.accessibilityLabel = title
        self.accessibilityValue = data
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.imageNode.style.preferredSize = CGSize(width: 24.0, height: 24.0)
        self.titleNode.style.flexShrink = 1.0
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 15.0
        cell.alignItems = .center
        cell.children = [self.imageNode, self.titleNode, spacer, self.dataNode]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
