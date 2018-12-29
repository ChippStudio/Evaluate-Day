//
//  CounterEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 20/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol CounterEvaluateNodeStyle {
    var counterEvaluateCounterFont: UIFont { get }
    var counterEvaluateCounterColor: UIColor { get }
    var counterEvaluateSumFont: UIFont { get }
    var counterEvaluateSumColor: UIColor { get }
    var counterEvaluatePlusColor: UIColor { get }
    var counterEvaluatePlusHighlightedColor: UIColor { get }
    var counterEvaluateMinusColor: UIColor { get }
    var counterEvaluateMinusHighlightedColor: UIColor { get }
    var counterEvaluateCustomValueFont: UIFont { get }
    var counterEvaluateCustomValueColor: UIColor { get }
    var counterEvaluateCustomValueHighlightedColor: UIColor { get }
    var counterEvaluateDateColor: UIColor { get }
    var counterEvaluateDateFont: UIFont { get }
    var counterEvaluatePreviousValueFont: UIFont { get }
    var counterEvaluatePreviousValueColor: UIColor { get }
    var counterEvaluateSeparatorColor: UIColor { get }
}

class CounterEvaluateNode: ASCellNode {

    // MARK: - UI
    var sumText: ASTextNode?
    var counter = ASTextNode()
    var plus = ASButtonNode()
    var minus = ASButtonNode()
    var customValueButton = ASButtonNode()
    var customValueButtonCover = ASDisplayNode()
    var plusCover = ASDisplayNode()
    var minusCover = ASDisplayNode()
    var currentDate = ASTextNode()
    var previousDate = ASTextNode()
    var previousValue = ASTextNode()
    var separator = ASDisplayNode()
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(value: Double, sumValue: Double?, previousValue: Double, date: Date, step: Double, style: CounterEvaluateNodeStyle) {
        super.init()
        
        // Plus and minus buttons and covers
        let font = UIFont.systemFont(ofSize: 36.0, weight: .regular)
        
        let plusAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: style.counterEvaluatePlusColor]
        let plusHighlightedAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: style.counterEvaluatePlusHighlightedColor]
        
        let minusAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: style.counterEvaluateMinusColor]
        let minusHighlightedAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: style.counterEvaluateMinusHighlightedColor]
        
        let customAttributes = [NSAttributedStringKey.font: style.counterEvaluateCustomValueFont, NSAttributedStringKey.foregroundColor: style.counterEvaluateCustomValueColor]
        let customHighlightedAttributes = [NSAttributedStringKey.font: style.counterEvaluateCustomValueFont, NSAttributedStringKey.foregroundColor: style.counterEvaluateCustomValueHighlightedColor]
        
        self.plus.setAttributedTitle(NSAttributedString(string: "+", attributes: plusAttributes), for: .normal)
        self.plus.setAttributedTitle(NSAttributedString(string: "+", attributes: plusHighlightedAttributes), for: .highlighted)
        
        self.minus.setAttributedTitle(NSAttributedString(string: "-", attributes: minusAttributes), for: .normal)
        self.minus.setAttributedTitle(NSAttributedString(string: "-", attributes: minusHighlightedAttributes), for: .highlighted)
        
        self.customValueButton.setAttributedTitle(NSAttributedString(string: Localizations.evaluate.counter.customValue, attributes: customAttributes), for: .normal)
        self.customValueButton.setAttributedTitle(NSAttributedString(string: Localizations.evaluate.counter.customValue, attributes: customHighlightedAttributes), for: .highlighted)
        
        self.plusCover.borderWidth = 1.0
        self.plusCover.borderColor = style.counterEvaluatePlusColor.cgColor
        
        self.minusCover.borderWidth = 1.0
        self.minusCover.borderColor = style.counterEvaluateMinusColor.cgColor
        
        self.customValueButtonCover.borderWidth = 1.0
        self.customValueButtonCover.borderColor = style.counterEvaluateCustomValueColor.cgColor
        
        // Sum title if needed
        if sumValue != nil {
            let sumString = String(format: "%.2f", sumValue!)
            self.sumText = ASTextNode()
            self.sumText?.attributedText = NSAttributedString(string: "∑ \(sumString)", attributes: [NSAttributedStringKey.font: style.counterEvaluateSumFont, NSAttributedStringKey.foregroundColor: style.counterEvaluateSumColor])
            self.sumText!.isAccessibilityElement = false
        }
        
        // counter
        let valueString = String(format: "%.2f", value)
        self.counter.attributedText = NSAttributedString(string: valueString, attributes: [NSAttributedStringKey.font: style.counterEvaluateCounterFont, NSAttributedStringKey.foregroundColor: style.counterEvaluateCounterColor])
        
        let previousValueString = String(format: "%.2f", previousValue)
        self.previousValue.attributedText = NSAttributedString(string: previousValueString, attributes: [NSAttributedStringKey.font: style.counterEvaluatePreviousValueFont, NSAttributedStringKey.foregroundColor: style.counterEvaluatePreviousValueColor])
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.currentDate.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: style.counterEvaluateDateFont, NSAttributedStringKey.foregroundColor: style.counterEvaluateDateColor])
        
        var components = DateComponents()
        components.day = -1
        
        let previousDate = Calendar.current.date(byAdding: components, to: date)!
        self.previousDate.attributedText = NSAttributedString(string: formatter.string(from: previousDate), attributes: [NSAttributedStringKey.font: style.counterEvaluateDateFont, NSAttributedStringKey.foregroundColor: style.counterEvaluateDateColor])
        
        self.separator.backgroundColor = style.counterEvaluateSeparatorColor
        self.separator.cornerRadius = 2.0
        
        //Accessibility
        self.currentDate.isAccessibilityElement = false
        self.counter.isAccessibilityElement = false
        self.previousValue.isAccessibilityElement = false
        self.previousDate.isAccessibilityElement = false
        
        self.plus.accessibilityLabel = Localizations.accessibility.evaluate.counter.increase(value1: "\(step)")
        self.minus.accessibilityLabel = Localizations.accessibility.evaluate.counter.decrease(value1: "\(step)")
        
        self.accessibilityNode.isAccessibilityElement = true
        self.accessibilityNode.accessibilityLabel = Localizations.accessibility.evaluate.counter.summory(value1: "\(value)", formatter.string(from: date), "\(previousValue)")
        if sumValue != nil {
            self.accessibilityNode.accessibilityValue = Localizations.accessibility.evaluate.counter.summorySum(value1: "\(sumValue!)")
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
        previousStack.children = [self.previousValue, self.previousDate]
        
        self.separator.style.preferredSize = CGSize(width: 4.0, height: 80.0)
        
        let valuesStack = ASStackLayoutSpec.horizontal()
        valuesStack.spacing = 20.0
        valuesStack.alignItems = .end
        valuesStack.flexWrap = .wrap
        valuesStack.children = [currentStack, self.separator, previousStack]
        
        if self.sumText != nil {
            valuesStack.children?.append(self.sumText!)
        }
        
        let valueInsets = UIEdgeInsets(top: 30.0, left: 20.0, bottom: 30.0, right: 0.0)
        let valueInset = ASInsetLayoutSpec(insets: valueInsets, child: valuesStack)
        
        let valueInsetAccessibility = ASBackgroundLayoutSpec(child: valueInset, background: self.accessibilityNode)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 5.0
        cell.children = [valueInsetAccessibility, buttons]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 30.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
