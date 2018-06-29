//
//  ActivityPhotoNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 20/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ActivityPhotoNode: ASCellNode {
    // MARK: - UI
    var imageNode = ASImageNode()
    
    // MARK: - Init
    init(image: UIImage) {
        super.init()
        
        self.imageNode.image = image
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let inset: CGFloat = 5.0
        let imageWidth = constrainedSize.max.width - inset * 2
        self.imageNode.style.preferredSize = CGSize(width: imageWidth, height: imageWidth)
        
        let cellInsets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: self.imageNode)
        return cellInset
    }
}
