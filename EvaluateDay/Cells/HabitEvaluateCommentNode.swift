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
    var editButtonCover = ASDisplayNode()
    
    // MARK: - Init
    init(comment: String, style: HabitEvaluateCommentNodeStyle) {
        super.init()
        
        self.commentTextNode.attributedText = NSAttributedString(string: comment, attributes: [NSAttributedStringKey.font: style.habitEvaluateCommentFont, NSAttributedStringKey.foregroundColor: style.habitEvaluateCommentTintColor])
        
        self.editButton.setImage(#imageLiteral(resourceName: "edit").resizedImage(newSize: CGSize(width: 30.0, height: 30.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.editButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.habitEvaluateCommentTintColor)
        
        self.editButtonCover.borderColor = style.habitEvaluateCommentTintColor.cgColor
        self.editButtonCover.borderWidth = 1.0
        
        self.automaticallyManagesSubnodes = true
    }
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.editButton.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        self.editButtonCover.cornerRadius = 50.0/2.0
        
        let button = ASBackgroundLayoutSpec(child: self.editButton, background: self.editButtonCover)
        
        self.commentTextNode.style.flexShrink = 1.0
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 10.0
        cell.alignItems = .center
        cell.justifyContent = .spaceBetween
        cell.children = [self.commentTextNode, button]
        
        let cellInsets = UIEdgeInsets(top: 5.0, left: 50.0, bottom: 5.0, right: 25.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
