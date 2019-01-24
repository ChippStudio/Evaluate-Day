//
//  SeparatorNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 08/08/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class SeparatorNode: ASCellNode {

    // MARK: - UI
    var separator = ASDisplayNode()
    
    // MARK: - Variables
    var insets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    // MARK: - Init
    override init() {
        super.init()
        
        self.separator.backgroundColor = UIColor.main
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.separator.style.preferredSize.height = 0.5
        let separatorInsets = self.insets
        let separatorInset = ASInsetLayoutSpec(insets: separatorInsets, child: self.separator)
        return separatorInset
    }
}
