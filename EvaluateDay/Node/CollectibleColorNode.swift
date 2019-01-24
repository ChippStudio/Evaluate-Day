//
//  CollectibleColorNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CollectibleColorNode: ASCellNode {
    // MARK: - UI
    var imageNode = ASImageNode()
    var titleNode = ASTextNode()
    var colorNode = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, image: UIImage, color: String) {
        super.init()
        
        self.imageNode.image = image.resizedImage(newSize: CGSize(width: 24.0, height: 24.0)).withRenderingMode(.alwaysTemplate)
        self.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        
        self.titleNode.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .title3), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        self.colorNode.backgroundColor = color.color
        self.colorNode.cornerRadius = 10.0
        if color == "FFFFFF" {
            self.colorNode.borderColor = UIColor.main.cgColor
            self.colorNode.borderWidth = 0.5
        }
        
        self.isAccessibilityElement = true
        self.accessibilityLabel = title
        var acColor: String = ""
        for item in colorsForSelection {
            if item.color == color {
                acColor = item.name
                break
            }
        }
        self.accessibilityValue = acColor
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.imageNode.style.preferredSize = CGSize(width: 24.0, height: 24.0)
        self.colorNode.style.preferredSize = CGSize(width: 20.0, height: 20.0)
        self.titleNode.style.flexShrink = 1.0
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 15.0
        cell.alignItems = .center
        cell.children = [self.imageNode, self.titleNode, spacer, self.colorNode]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
