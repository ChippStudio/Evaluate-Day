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
}

class GoalEvaluateNode: ASCellNode {
    // MARK: - UI
    var sumText: ASTextNode?
    var goalText = ASTextNode()
    var counter = ASTextNode()
    var plus = ASButtonNode()
    var minus = ASButtonNode()
    var customValueButton = ASButtonNode()
    var customValueButtonCover = ASDisplayNode()
    var plusCover = ASDisplayNode()
    var minusCover = ASDisplayNode()
    
    // MARK: - Init
    init(value: Double, goalValue: Double, sumValue: Double?, style: GoalEvaluateNodeStyle) {
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
        self.goalText.attributedText = NSAttributedString(string: Localizations.cardSettings.goal.goal + " - \(goalString)", attributes: [NSAttributedStringKey.font: style.goalEvaluateSumFont, NSAttributedStringKey.foregroundColor: style.goalEvaluateSumColor])
        
        // Sum title if needed
        if sumValue != nil {
            let sumString = String(format: "%.2f", sumValue!)
            self.sumText = ASTextNode()
            self.sumText?.attributedText = NSAttributedString(string: Localizations.evaluate.counter.sum(value1: sumString), attributes: [NSAttributedStringKey.font: style.goalEvaluateSumFont, NSAttributedStringKey.foregroundColor: style.goalEvaluateSumColor])
        }
        
        // counter
        let valueString = String(format: "%.2f", value)
        self.counter.attributedText = NSAttributedString(string: valueString, attributes: [NSAttributedStringKey.font: style.goalEvaluateCounterFont, NSAttributedStringKey.foregroundColor: style.goalEvaluateCounterColor])
        
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
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 5.0
        cell.children = [self.counter, self.goalText, buttons]
        
        if self.sumText != nil {
            cell.children?.insert(self.sumText!, at: 1)
        }
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 50.0, bottom: 10.0, right: 25.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
