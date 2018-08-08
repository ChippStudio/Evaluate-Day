//
//  SeparatorNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 08/08/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol SeparatorNodeStyle {
    var separatorNodeColor: UIColor { get }
}

class SeparatorNode: ASCellNode {

    // MARK: - UI
    var separator = ASDisplayNode()
    
    // MARK: - Variables
    var leftInset: CGFloat = 0.0
    var bottomInset: CGFloat = 0.0
    
    // MARK: - Init
    init(style: SeparatorNodeStyle) {
        super.init()
        
        self.separator.backgroundColor = style.separatorNodeColor
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Layout
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.separator.style.preferredSize.height = 0.5
        let separatorInsets = UIEdgeInsets(top: 0.0, left: self.leftInset, bottom: bottomInset, right: 0.0)
        let separatorInset = ASInsetLayoutSpec(insets: separatorInsets, child: self.separator)
        return separatorInset
    }
}
