//
//  CollectibleImageNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CollectibleImageNode: ASCellNode {
    // MARK: - UI
    var imageNode = ASImageNode()
    var titleNode = ASTextNode()
    var dataImageNode = ASImageNode()
    
    // MARK: - Init
    init(title: String, image: UIImage, data: UIImage) {
        super.init()
        
        self.imageNode.image = image.resizedImage(newSize: CGSize(width: 24.0, height: 24.0)).withRenderingMode(.alwaysTemplate)
        self.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        
        self.titleNode.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .title3), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        self.dataImageNode.image = data.resizedImage(newSize: CGSize(width: 20.0, height: 20.0)).withRenderingMode(.alwaysTemplate)
        self.dataImageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        
        self.isAccessibilityElement = true
        self.accessibilityLabel = title
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.imageNode.style.preferredSize = CGSize(width: 24.0, height: 24.0)
        self.dataImageNode.style.preferredSize = CGSize(width: 20.0, height: 20.0)
        self.titleNode.style.flexShrink = 1.0
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 15.0
        cell.alignItems = .center
        cell.children = [self.imageNode, self.titleNode, spacer, self.dataImageNode]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
