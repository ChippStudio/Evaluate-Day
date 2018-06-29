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
    private var colorStyle: ColorEvaluateNodeStyle
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
    init(color: String, style: ColorEvaluateNodeStyle) {
        self.colorString = color
        self.colorStyle = style
        
        super.init()
        self.dot.backgroundColor = color.color
        self.done.image = #imageLiteral(resourceName: "done")
    
        if colorString == "FFFFFF" {
            self.dot.borderColor = UIColor.gunmetal.cgColor
            self.dot.borderWidth = 0.5
            self.done.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.gunmetal)
        } else {
            self.done.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.white)
        }
        
        self.addSubnode(self.dot)
        self.dot.addSubnode(self.done)
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.dot.style.preferredSize = CGSize(width: 60.0, height: 60.0)
        self.dot.cornerRadius = 30.0
        
        self.dot.layoutSpecBlock = { (_, _) in
            self.done.style.preferredSize = CGSize(width: 34.0, height: 34.0)
            
            let center = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: self.done)
            return center
        }
        
        let dotInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        let dotInset = ASInsetLayoutSpec(insets: dotInsets, child: self.dot)
        
        return dotInset
    }
}
