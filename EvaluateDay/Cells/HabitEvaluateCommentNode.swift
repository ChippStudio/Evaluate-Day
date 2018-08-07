//
//  HabitEvaluateCommentNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol HabitEvaluateCommentNodeStyle {
    var habitEvaluateCommentFont: UIFont { get }
    var habitEvaluateCommentTintColor: UIColor { get }
}

class HabitEvaluateCommentNode: ASCellNode {
    // MARK: - UI
    var commentTextNode = ASTextNode()
    var editButton = ASButtonNode()
    var separator = ASDisplayNode()
    
    // MARK: - Init
    init(comment: String, style: HabitEvaluateCommentNodeStyle) {
        super.init()
        
        self.commentTextNode.attributedText = NSAttributedString(string: comment, attributes: [NSAttributedStringKey.font: style.habitEvaluateCommentFont, NSAttributedStringKey.foregroundColor: style.habitEvaluateCommentTintColor])
        
        self.separator.backgroundColor = style.habitEvaluateCommentTintColor
        
        self.automaticallyManagesSubnodes = true
    }
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.separator.style.preferredSize = CGSize(width: 200.0, height: 1.0)
    
        self.commentTextNode.style.flexShrink = 1.0
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 10.0
        cell.alignItems = .end
        cell.children = [self.commentTextNode, self.separator]
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 10.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        let back = ASOverlayLayoutSpec(child: cellInset, overlay: self.editButton)
        return back
    }
}
