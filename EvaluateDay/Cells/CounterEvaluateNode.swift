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
    
    // MARK: - Init
    init(value: Double, sumValue: Double?, style: CounterEvaluateNodeStyle) {
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
            self.sumText?.attributedText = NSAttributedString(string: Localizations.evaluate.counter.sum(value1: sumString), attributes: [NSAttributedStringKey.font: style.counterEvaluateSumFont, NSAttributedStringKey.foregroundColor: style.counterEvaluateSumColor])
        }
        
        // counter
        let valueString = String(format: "%.2f", value)
        self.counter.attributedText = NSAttributedString(string: valueString, attributes: [NSAttributedStringKey.font: style.counterEvaluateCounterFont, NSAttributedStringKey.foregroundColor: style.counterEvaluateCounterColor])
        
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
        cell.children = [self.counter, buttons]
        
        if self.sumText != nil {
            cell.children?.insert(self.sumText!, at: 1)
        }
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 50.0, bottom: 10.0, right: 25.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
