//
//  BigDescriptionNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 05/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol BigDescriptionNodeStyle {
    var bigDescriptionNodeTextColor: UIColor { get }
    var bigDescriptionNodeTextFont: UIFont { get }
}

class BigDescriptionNode: ASCellNode {
    
    // MARK: - UI
    var textNode = ASTextNode()
    
    // MARK: - Variable
    var topInset: CGFloat = 0.0
    
    // MARK: - Init
    init(text: String, alignment: NSTextAlignment, style: BigDescriptionNodeStyle) {
        super.init()
        
        self.selectionStyle = .none
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        
        self.textNode.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: style.bigDescriptionNodeTextFont, NSAttributedStringKey.foregroundColor: style.bigDescriptionNodeTextColor, NSAttributedStringKey.paragraphStyle: paragraph])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let cellInsets = UIEdgeInsets(top: self.topInset, left: 15.0, bottom: 0.0, right: 15.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: self.textNode)
        
        return cellInset
    }
}
