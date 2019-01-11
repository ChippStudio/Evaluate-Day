//
//  ColorDotNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 09/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ColorDotNode: ASCellNode {
    // MARK: - UI
    var colorString: String
    var dot: ASDisplayNode = ASDisplayNode()
    var done = ASImageNode()
    
    // MARK: - Variable
    var colorSelected: Bool = false {
        didSet {
            if colorSelected {
                self.done.alpha = 1.0
            } else {
                self.done.alpha = 0.0
            }
        }
    }
    
    // MARK: - Init
    init(color: String) {
        self.colorString = color
        
        super.init()
        self.dot.backgroundColor = color.color
        self.done.image = #imageLiteral(resourceName: "done")
    
        if colorString == "FFFFFF" {
            self.dot.borderColor = UIColor.main.cgColor
            self.dot.borderWidth = 0.5
            self.done.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.selected)
        } else {
            self.done.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.tint)
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.dot.cornerRadius = 10.0
        
        self.done.style.preferredSize = CGSize(width: 20.0, height: 20.0)
        
        let markInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 30.0, right: 60.0)
        let markInset = ASInsetLayoutSpec(insets: markInsets, child: self.done)
        
        let cell = ASBackgroundLayoutSpec(child: markInset, background: self.dot)
        
        let cellInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
