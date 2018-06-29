//
//  ThemeImageNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ThemeImageNode: ASCellNode {
    
    // MARK: - UI
    var previewImageNode = ASImageNode()
    
    // MARK: - Init
    init(image: UIImage) {
        super.init()
        
        self.previewImageNode.image = image
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.previewImageNode.style.preferredSize.height = 150.0
        self.previewImageNode.contentMode = .scaleAspectFit
        
        let insets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
        let cell = ASInsetLayoutSpec(insets: insets, child: self.previewImageNode)
        
        return cell
    }
}
