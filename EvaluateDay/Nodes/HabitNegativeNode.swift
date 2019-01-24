//
//  HabitNegativeNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 07/04/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class HabitNegativeNode: ASCellNode {

    // MARK: - UI
    var descriptionNode = ASTextNode()
    var coverNode = ASDisplayNode()
    
    // MARK: - Init
    override init() {
        super.init()
        
        self.coverNode.backgroundColor = UIColor.negative
        self.coverNode.cornerRadius = 10.0
        
        self.descriptionNode.attributedText = NSAttributedString(string: Localizations.Evaluate.Habit.negative, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.tint])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.descriptionNode.style.flexShrink = 1.0
        let descriptionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let descriptionInset = ASInsetLayoutSpec(insets: descriptionInsets, child: self.descriptionNode)
        descriptionInset.style.flexShrink = 1.0
        
        let cell = ASBackgroundLayoutSpec(child: descriptionInset, background: self.coverNode)
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
