//
//  HabitEvaluateCommentNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class HabitEvaluateCommentNode: ASCellNode {
    // MARK: - UI
    var commentTextNode = ASTextNode()
    var indexTextNode = ASTextNode()
    var editButton = ASButtonNode()
    
    var cover = ASDisplayNode()
    
    // MARK: - Init
    init(comment: String, index: Int) {
        super.init()
        
        self.cover.backgroundColor = UIColor.background
        self.cover.cornerRadius = 10.0
        
        self.commentTextNode.attributedText = NSAttributedString(string: comment, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.main])
        self.indexTextNode.attributedText = NSAttributedString(string: "\(index).", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.main])
        
        // Accessibility
        self.commentTextNode.isAccessibilityElement = false
        self.editButton.accessibilityLabel = comment
        self.editButton.accessibilityHint = Localizations.Accessibility.Evaluate.Habit.commentHint
        
        self.editButton.addTarget(self, action: #selector(self.markInitialAction(sender:)), forControlEvents: .touchDown)
        self.editButton.addTarget(self, action: #selector(self.markValueEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.editButton.addTarget(self, action: #selector(self.markValueEndAction(sender:)), forControlEvents: .touchUpInside)
        self.editButton.addTarget(self, action: #selector(self.markValueEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.automaticallyManagesSubnodes = true
    }
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.commentTextNode.style.flexShrink = 1.0
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 5.0
        cell.children = [self.indexTextNode, self.commentTextNode]
        
        let cellInsets = UIEdgeInsets(top: 5.0, left: 20.0, bottom: 5.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        let overlay = ASOverlayLayoutSpec(child: cellInset, overlay: self.editButton)
        let back = ASBackgroundLayoutSpec(child: overlay, background: self.cover)
        
        return back
    }
    
    // MARK: - Actions
    @objc func markInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.tint
        }
    }
    
    @objc func markValueEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.background
        }
    }
}
