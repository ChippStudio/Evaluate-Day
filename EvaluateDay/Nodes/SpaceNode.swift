//
//  SpaceNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 15/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class SpaceNode: ASCellNode {
    
    // MARK: - UI
    var spacer = ASDisplayNode()
    
    // MARK: - Variable
    var space: CGFloat = 0.0

    // MARK: - Init
    init(space: CGFloat) {
        super.init()
        
        self.space = space
        
        self.spacer.backgroundColor = UIColor.clear
        
        self.isAccessibilityElement = false
        
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.spacer.style.preferredSize = CGSize(width: constrainedSize.max.width, height: self.space)
        
        let spaceInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        let spaceInset = ASInsetLayoutSpec(insets: spaceInsets, child: self.spacer)
        
        return spaceInset
    }
}
