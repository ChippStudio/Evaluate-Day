//
//  HabitNegativeNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 07/04/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol HabitNegativeNodeStyle {
    var habitNegativeDescriptionFont: UIFont { get }
    var habitNegativeDescriptionColor: UIColor { get }
    var habitNegativeCoverColor: UIColor { get }
    var habitNegativeCoverAlpha: CGFloat { get }
}

class HabitNegativeNode: ASCellNode {

    // MARK: - UI
    var descriptionNode = ASTextNode()
    var coverNode = ASDisplayNode()
    
    // MARK: - Init
    init(style: HabitNegativeNodeStyle) {
        super.init()
        
        self.coverNode.backgroundColor = style.habitNegativeCoverColor
        self.coverNode.alpha = style.habitNegativeCoverAlpha
        
        self.descriptionNode.attributedText = NSAttributedString(string: Localizations.Evaluate.Habit.negative, attributes: [NSAttributedStringKey.font: style.habitNegativeDescriptionFont, NSAttributedStringKey.foregroundColor: style.habitNegativeDescriptionColor])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.descriptionNode.style.flexShrink = 1.0
        let descriptionInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
        let descriptionInset = ASInsetLayoutSpec(insets: descriptionInsets, child: self.descriptionNode)
        descriptionInset.style.flexShrink = 1.0
        
        let cell = ASBackgroundLayoutSpec(child: descriptionInset, background: self.coverNode)
        return cell
    }
}
