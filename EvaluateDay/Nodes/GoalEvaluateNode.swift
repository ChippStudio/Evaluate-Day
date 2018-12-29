//
//  GoalEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 26/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol GoalEvaluateNodeStyle {
    var goalEvaluateCounterFont: UIFont { get }
    var goalEvaluateCounterColor: UIColor { get }
    var goalEvaluateSumFont: UIFont { get }
    var goalEvaluateSumColor: UIColor { get }
    var goalEvaluatePlusColor: UIColor { get }
    var goalEvaluatePlusHighlightedColor: UIColor { get }
    var goalEvaluateMinusColor: UIColor { get }
    var goalEvaluateMinusHighlightedColor: UIColor { get }
    var goalEvaluateCustomValueFont: UIFont { get }
    var goalEvaluateCustomValueColor: UIColor { get }
    var goalEvaluateCustomValueHighlightedColor: UIColor { get }
    var goalEvaluateGoalFont: UIFont { get }
    var goalEvaluateGoalColor: UIColor { get }
    var goalEvaluateDateColor: UIColor { get }
    var goalEvaluateDateFont: UIFont { get }
    var goalEvaluatePreviousValueFont: UIFont { get }
    var goalEvaluatePreviousValueColor: UIColor { get }
    var goalEvaluateSeparatorColor: UIColor { get }
}

class GoalEvaluateNode: ASCellNode {
    // MARK: - UI
    var sumText: ASTextNode?
    var goalText = ASTextNode()
    
    var counter = ASTextNode()
    var previousCounter = ASTextNode()
    
    var currentDate = ASTextNode()
    var previousDate = ASTextNode()
    
    var separator = ASDisplayNode()
    
    var plus = ASButtonNode()
    var minus = ASButtonNode()
    var customValueButton = ASButtonNode()
    var customValueButtonCover = ASDisplayNode()
    var plusCover = ASDisplayNode()
    var minusCover = ASDisplayNode()
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(value: Double, previousValue: Double, date: Date, goalValue: Double, sumValue: Double?, step: Double, style: GoalEvaluateNodeStyle) {
        super.init()
        
        // Plus and minus buttons and covers
        let font = UIFont.systemFont(ofSize: 36.0, weight: .regular)
        
        let plusAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: style.goalEvaluatePlusColor]
        let plusHighlightedAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: style.goalEvaluatePlusHighlightedColor]
        
        let minusAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: style.goalEvaluateMinusColor]
        let minusHighlightedAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: style.goalEvaluateMinusHighlightedColor]
        
        let customAttributes = [NSAttributedStringKey.font: style.goalEvaluateCustomValueFont, NSAttributedStringKey.foregroundColor: style.goalEvaluateCustomValueColor]
        let customHighlightedAttributes = [NSAttributedStringKey.font: style.goalEvaluateCustomValueFont, NSAttributedStringKey.foregroundColor: style.goalEvaluateCustomValueHighlightedColor]
        
        self.plus.setAttributedTitle(NSAttributedString(string: "+", attributes: plusAttributes), for: .normal)
        self.plus.setAttributedTitle(NSAttributedString(string: "+", attributes: plusHighlightedAttributes), for: .highlighted)
        
        self.minus.setAttributedTitle(NSAttributedString(string: "-", attributes: minusAttributes), for: .normal)
        self.minus.setAttributedTitle(NSAttributedString(string: "-", attributes: minusHighlightedAttributes), for: .highlighted)
        
        self.customValueButton.setAttributedTitle(NSAttributedString(string: Localizations.evaluate.counter.customValue, attributes: customAttributes), for: .normal)
        self.customValueButton.setAttributedTitle(NSAttributedString(string: Localizations.evaluate.counter.customValue, attributes: customHighlightedAttributes), for: .highlighted)
        
        self.plusCover.borderWidth = 1.0
        self.plusCover.borderColor = style.goalEvaluatePlusColor.cgColor
        
        self.minusCover.borderWidth = 1.0
        self.minusCover.borderColor = style.goalEvaluateMinusColor.cgColor
        
        self.customValueButtonCover.borderWidth = 1.0
        self.customValueButtonCover.borderColor = style.goalEvaluateCustomValueColor.cgColor
        
        let goalString = String(format: "%.2f", goalValue)
        self.goalText.attributedText = NSAttributedString(string: Localizations.cardSettings.goal.goal + " - \(goalString)", attributes: [NSAttributedStringKey.font: style.goalEvaluateGoalFont, NSAttributedStringKey.foregroundColor: style.goalEvaluateGoalColor])
        
        // Sum title if needed
        if sumValue != nil {
            let sumString = String(format: "%.2f", sumValue!)
            self.sumText = ASTextNode()
            self.sumText?.attributedText = NSAttributedString(string: "∑ \(sumString)", attributes: [NSAttributedStringKey.font: style.goalEvaluateSumFont, NSAttributedStringKey.foregroundColor: style.goalEvaluateSumColor])
            self.sumText!.isAccessibilityElement = false
        }
        
        // counter
        let valueString = String(format: "%.2f", value)
        self.counter.attributedText = NSAttributedString(string: valueString, attributes: [NSAttributedStringKey.font: style.goalEvaluateCounterFont, NSAttributedStringKey.foregroundColor: style.goalEvaluateCounterColor])
        
        let previousValueString = String(format: "%.2f", previousValue)
        self.previousCounter.attributedText = NSAttributedString(string: previousValueString, attributes: [NSAttributedStringKey.font: style.goalEvaluatePreviousValueFont, NSAttributedStringKey.foregroundColor: style.goalEvaluatePreviousValueColor])
        
        // Date
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        var compnents = DateComponents()
        compnents.day = -1
        
        let previousDate = Calendar.current.date(byAdding: compnents, to: date)!
        
        self.currentDate.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: style.goalEvaluateDateFont, NSAttributedStringKey.foregroundColor: style.goalEvaluateDateColor])
        self.previousDate.attributedText = NSAttributedString(string: formatter.string(from: previousDate), attributes: [NSAttributedStringKey.font: style.goalEvaluateDateFont, NSAttributedStringKey.foregroundColor: style.goalEvaluateDateColor])
        
        self.separator.backgroundColor = style.goalEvaluateSeparatorColor
        self.separator.cornerRadius = 2.0
        
        // Accessibility
        self.goalText.isAccessibilityElement = false
        
        self.counter.isAccessibilityElement = false
        self.previousCounter.isAccessibilityElement = false
        
        self.currentDate.isAccessibilityElement = false
        self.previousDate.isAccessibilityElement = false
        
        self.plus.accessibilityLabel = Localizations.accessibility.evaluate.goal.increase(value1: "\(step)")
        self.minus.accessibilityLabel = Localizations.accessibility.evaluate.goal.decrease(value1: "\(step)")
        
        self.accessibilityNode.isAccessibilityElement = true
        self.accessibilityNode.accessibilityLabel = Localizations.accessibility.evaluate.goal.summory(value1: "\(value)", formatter.string(from: date), "\(previousValue)")
        if sumValue != nil {
            self.accessibilityNode.accessibilityValue = Localizations.accessibility.evaluate.goal.summorySum(value1: "\(sumValue!)")
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        // Buttons
        let buttonsSize: CGFloat = 50.0
        let buttonCornerRadius: CGFloat = 5.0
        self.plus.style.preferredSize = CGSize(width: buttonsSize, height: buttonsSize)
        self.minus.style.preferredSize = CGSize(width: buttonsSize, height: buttonsSize)
        self.customValueButton.style.preferredSize.height = buttonsSize
        
        self.plusCover.cornerRadius = buttonCornerRadius
        self.minusCover.cornerRadius = buttonCornerRadius
        self.customValueButtonCover.cornerRadius = buttonCornerRadius
        
        let plusButton = ASBackgroundLayoutSpec(child: self.plus, background: self.plusCover)
        let minusButton = ASBackgroundLayoutSpec(child: self.minus, background: self.minusCover)
        let customButton = ASBackgroundLayoutSpec(child: self.customValueButton, background: self.customValueButtonCover)
        
        customButton.style.flexGrow = 1.0
        
        let buttons = ASStackLayoutSpec.horizontal()
        buttons.spacing = 10.0
        buttons.children = [plusButton, minusButton, customButton]
        
        let currentStack = ASStackLayoutSpec.vertical()
        currentStack.alignItems = .end
        currentStack.spacing = 10.0
        currentStack.children = [self.counter, self.currentDate]
        
        let previousStack = ASStackLayoutSpec.vertical()
        previousStack.alignItems = .end
        previousStack.spacing = 10.0
        previousStack.children = [self.previousCounter, self.previousDate]
        
        self.separator.style.preferredSize = CGSize(width: 4.0, height: 80.0)
        
        let valuesStack = ASStackLayoutSpec.horizontal()
        valuesStack.spacing = 20.0
        valuesStack.alignItems = .end
        valuesStack.flexWrap = .wrap
        valuesStack.children = [currentStack, self.separator, previousStack]
        
        if self.sumText != nil {
            valuesStack.children?.append(self.sumText!)
        }
        
        let valuesStactInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 30.0, right: 10.0)
        let valuesStackInset = ASInsetLayoutSpec(insets: valuesStactInsets, child: valuesStack)
        
        let goalInsets = UIEdgeInsets(top: 30.0, left: 10.0, bottom: 20.0, right: 10.0)
        let goalInset = ASInsetLayoutSpec(insets: goalInsets, child: self.goalText)
        
        let allStack = ASStackLayoutSpec.vertical()
        allStack.spacing = 5.0
        allStack.children = [goalInset, valuesStackInset]
        
        let allStackAccessibility = ASBackgroundLayoutSpec(child: allStack, background: self.accessibilityNode)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 5.0
        cell.children = [allStackAccessibility, buttons]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
