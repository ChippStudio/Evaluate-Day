//
//  DescriptionNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 03/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class DescriptionNode: ASCellNode {
    // MARK: - UI
    var textNode = ASTextNode()
    
    // MARK: - Variable
    var topInset: CGFloat = 0.0
    var leftInset: CGFloat = 20.0
    
    // MARK: - Init
    init(text: String, alignment: NSTextAlignment) {
        super.init()
        
        self.selectionStyle = .none
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        
        self.textNode.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .footnote), NSAttributedStringKey.foregroundColor: UIColor.main, NSAttributedStringKey.paragraphStyle: paragraph])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let cellInsets = UIEdgeInsets(top: self.topInset, left: self.leftInset, bottom: 10.0, right: 15.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: self.textNode)
        
        return cellInset
    }
}
