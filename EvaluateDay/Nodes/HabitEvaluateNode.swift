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
    var evaluateHabitDateColor: UIColor { get }
    var evaluateHabitDateFont: UIFont { get }
    var evaluateHabitPreviousCountColor: UIColor { get }
    var evaluateHabitPreviousCountFont: UIFont { get }
}

class HabitEvaluateNode: ASCellNode {
    // MARK: - UI
    var marksCount = ASTextNode()
    var previousMarkCount = ASTextNode()
    var currentDate = ASTextNode()
    var previousDate = ASTextNode()
    var countSeparator = ASDisplayNode()
    
    var markButton = ASButtonNode()
    var markAndCommentButton = ASButtonNode()
    var separator = ASDisplayNode()
    
    var deleteButton: ASButtonNode?
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(marks: Int, previousMarks: Int, date: Date, style: HabitEvaluateNodeStyle) {
        super.init()
        
        self.marksCount.attributedText = NSAttributedString(string: "\(marks)", attributes: [NSAttributedStringKey.font: style.evaluateHabitCounterFont, NSAttributedStringKey.foregroundColor: style.evaluateHabitCounterColor])
        self.previousMarkCount.attributedText = NSAttributedString(string: "\(previousMarks)", attributes: [NSAttributedStringKey.font: style.evaluateHabitPreviousCountFont, NSAttributedStringKey.foregroundColor: style.evaluateHabitPreviousCountColor])
        
        var components = DateComponents()
        components.day = -1
        
        let previousDate = Calendar.current.date(byAdding: components, to: date)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.currentDate.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: style.evaluateHabitDateFont, NSAttributedStringKey.foregroundColor: style.evaluateHabitDateColor])
        self.previousDate.attributedText = NSAttributedString(string: formatter.string(from: previousDate), attributes: [NSAttributedStringKey.font: style.evaluateHabitDateFont, NSAttributedStringKey.foregroundColor: style.evaluateHabitDateColor])
        
        self.countSeparator.backgroundColor = style.evaluateHabitSeparatorColor
        self.countSeparator.cornerRadius = 2.0
        
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
        
        // Accessibility
        self.currentDate.isAccessibilityElement = false
        self.marksCount.isAccessibilityElement = false
        self.previousDate.isAccessibilityElement = false
        self.previousMarkCount.isAccessibilityElement = false
        
        self.accessibilityNode.isAccessibilityElement = true
        self.accessibilityNode.accessibilityLabel = Localizations.accessibility.evaluate.habit.summory(value1: "\(marks)", formatter.string(from: date), "\(previousMarks)")
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Overrirde
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let currentStack = ASStackLayoutSpec.vertical()
        currentStack.alignItems = .end
        currentStack.spacing = 5.0
        currentStack.children = [self.marksCount, currentDate]
        
        let previousStack = ASStackLayoutSpec.vertical()
        previousStack.alignItems = .end
        previousStack.spacing = 5.0
        previousStack.children = [self.previousMarkCount, self.previousDate]
        
        self.countSeparator.style.preferredSize = CGSize(width: 4.0, height: 80.0)
        
        let allMarks = ASStackLayoutSpec.horizontal()
        allMarks.spacing = 20.0
        allMarks.alignItems = .end
        allMarks.children = [currentStack, self.countSeparator, previousStack]
        
        let allMarksAccessibility = ASBackgroundLayoutSpec(child: allMarks, background: self.accessibilityNode)
        
        let marksCounter = ASStackLayoutSpec.horizontal()
        marksCounter.justifyContent = .spaceBetween
        marksCounter.spacing = 10.0
        marksCounter.children = [allMarksAccessibility]
        marksCounter.flexWrap = .wrap
        marksCounter.alignItems = .end
        if self.deleteButton != nil {
            marksCounter.children?.append(self.deleteButton!)
        }
        
        self.separator.style.preferredSize = CGSize(width: 100.0, height: 1.0)
        
        let buttons = ASStackLayoutSpec.vertical()
        buttons.spacing = 10.0
        buttons.alignItems = .center
        buttons.children = [self.markButton, self.separator, self.markAndCommentButton]
        
        let counterInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
        let counterInset = ASInsetLayoutSpec(insets: counterInsets, child: marksCounter)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 20.0
        cell.children = [counterInset, buttons]
        
        let cellInsets = UIEdgeInsets(top: 30.0, left: 30.0, bottom: 30.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
