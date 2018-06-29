//
//  HabitEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol HabitEvaluateNodeStyle {
    var evaluateHabitCounterFont: UIFont { get }
    var evaluateHabitCounterColor: UIColor { get }
    var evaluateHabitButtonsFont: UIFont { get }
    var evaluateHabitMarksColor: UIColor { get }
    var evaluateHabitDeleteColor: UIColor { get }
    var evaluateHabitHighlightedColor: UIColor { get }
    var evaluateHabitSeparatorColor: UIColor { get }
}

class HabitEvaluateNode: ASCellNode {
    // MARK: - UI
    var marksCount = ASTextNode()
    
    var markButton = ASButtonNode()
    var markAndCommentButton = ASButtonNode()
    var separator = ASDisplayNode()
    
    var deleteButton: ASButtonNode?
    
    // MARK: - Init
    init(marks: Int, style: HabitEvaluateNodeStyle) {
        super.init()
        
        self.marksCount.attributedText = NSAttributedString(string: "\(marks)", attributes: [NSAttributedStringKey.font: style.evaluateHabitCounterFont, NSAttributedStringKey.foregroundColor: style.evaluateHabitCounterColor])
        
        let markButtonString = NSAttributedString(string: Localizations.evaluate.habit.mark, attributes: [NSAttributedStringKey.font: style.evaluateHabitButtonsFont, NSAttributedStringKey.foregroundColor: style.evaluateHabitMarksColor])
        let markCommentButtonString = NSAttributedString(string: Localizations.evaluate.habit.markAndComment, attributes: [NSAttributedStringKey.font: style.evaluateHabitButtonsFont, NSAttributedStringKey.foregroundColor: style.evaluateHabitMarksColor])
        let deleteCommentString = NSAttributedString(string: Localizations.evaluate.habit.removeLast, attributes: [NSAttributedStringKey.font: style.evaluateHabitButtonsFont, NSAttributedStringKey.foregroundColor: style.evaluateHabitDeleteColor])
        
        let markHighlightedButtonString = NSAttributedString(string: Localizations.evaluate.habit.mark, attributes: [NSAttributedStringKey.font: style.evaluateHabitButtonsFont, NSAttributedStringKey.foregroundColor: style.evaluateHabitHighlightedColor])
        let markHighlightedCommentButtonString = NSAttributedString(string: Localizations.evaluate.habit.markAndComment, attributes: [NSAttributedStringKey.font: style.evaluateHabitButtonsFont, NSAttributedStringKey.foregroundColor: style.evaluateHabitHighlightedColor])
        let deleteHighlightedCommentString = NSAttributedString(string: Localizations.evaluate.habit.removeLast, attributes: [NSAttributedStringKey.font: style.evaluateHabitButtonsFont, NSAttributedStringKey.foregroundColor: style.evaluateHabitHighlightedColor])
        
        self.markButton.setAttributedTitle(markButtonString, for: .normal)
        self.markButton.setAttributedTitle(markHighlightedButtonString, for: .highlighted)
        
        self.markAndCommentButton.setAttributedTitle(markCommentButtonString, for: .normal)
        self.markAndCommentButton.setAttributedTitle(markHighlightedCommentButtonString, for: .highlighted)
        
        if marks != 0 {
            self.deleteButton = ASButtonNode()
            self.deleteButton!.setAttributedTitle(deleteCommentString, for: .normal)
            self.deleteButton!.setAttributedTitle(deleteHighlightedCommentString, for: .highlighted)
        }
        
        self.separator.backgroundColor = style.evaluateHabitSeparatorColor
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Overrirde
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let marksCounter = ASStackLayoutSpec.horizontal()
        marksCounter.justifyContent = .spaceBetween
        marksCounter.spacing = 10.0
        marksCounter.children = [self.marksCount]
        if self.deleteButton != nil {
            marksCounter.children?.append(self.deleteButton!)
        }
        
        self.separator.style.preferredSize = CGSize(width: 100.0, height: 1.0)
        
        let buttons = ASStackLayoutSpec.vertical()
        buttons.spacing = 10.0
        buttons.alignItems = .center
        buttons.children = [self.markButton, self.separator, self.markAndCommentButton]
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 20.0
        cell.children = [marksCounter, buttons]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 50.0, bottom: 20.0, right: 25.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
