//
//  CounterEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 20/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

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
    var currentMeasurement = ASTextNode()
    var previousDate = ASTextNode()
    var previousMeasurement = ASTextNode()
    var previousValue = ASTextNode()
    var separator = ASDisplayNode()
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Variables
    private let numberFormatter = NumberFormatter()
    
    // MARK: - Init
    init(value: Double, sumValue: Double?, previousValue: Double, date: Date, step: Double, measurement: String) {
        super.init()
        
        // Set number formatter
        self.numberFormatter.numberStyle = .decimal
        self.numberFormatter.maximumFractionDigits = 2
        
        // Plus and minus buttons and covers
        let font = UIFont.systemFont(ofSize: 36.0, weight: .regular)
        
        let plusAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.textTint]
        
        let minusAttributes = [NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColor.textTint]
        
        let customAttributes = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.textTint]
        
        self.plus.setAttributedTitle(NSAttributedString(string: "+", attributes: plusAttributes), for: .normal)
        
        self.minus.setAttributedTitle(NSAttributedString(string: "-", attributes: minusAttributes), for: .normal)
        
        self.customValueButton.setAttributedTitle(NSAttributedString(string: Localizations.Evaluate.Counter.customValue, attributes: customAttributes), for: .normal)
        
        self.plusCover.backgroundColor = UIColor.main
        
        self.minusCover.backgroundColor = UIColor.main
        
        self.customValueButtonCover.backgroundColor = UIColor.main
        
        // Sum title if needed
        if sumValue != nil {
            let sumString = self.numberFormatter.string(from: NSNumber(value: sumValue!))!
            self.sumText = ASTextNode()
            self.sumText?.attributedText = NSAttributedString(string: "∑ \(sumString)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.text])
            self.sumText!.isAccessibilityElement = false
        }
        
        // counter
        let valueString = self.numberFormatter.string(from: NSNumber(value: value))!
        self.counter.attributedText = NSAttributedString(string: valueString, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 40.0, weight: .medium), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        let previousValueString = self.numberFormatter.string(from: NSNumber(value: previousValue))!
        self.previousValue.attributedText = NSAttributedString(string: previousValueString, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 40.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        self.currentMeasurement.attributedText = NSAttributedString(string: measurement, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.text])
        self.previousMeasurement.attributedText = NSAttributedString(string: measurement, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.currentDate.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        var components = DateComponents()
        components.day = -1
        
        let previousDate = Calendar.current.date(byAdding: components, to: date)!
        self.previousDate.attributedText = NSAttributedString(string: formatter.string(from: previousDate), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        self.separator.backgroundColor = UIColor.main
        self.separator.cornerRadius = 2.0
        
        //Accessibility
        self.currentDate.isAccessibilityElement = false
        self.counter.isAccessibilityElement = false
        self.previousValue.isAccessibilityElement = false
        self.previousDate.isAccessibilityElement = false
        
        self.plus.accessibilityLabel = Localizations.Accessibility.Evaluate.Counter.increase("\(step)")
        self.minus.accessibilityLabel = Localizations.Accessibility.Evaluate.Counter.decrease("\(step)")
        
        self.accessibilityNode.isAccessibilityElement = true
        self.accessibilityNode.accessibilityLabel = Localizations.Accessibility.Evaluate.Counter.summory("\(value)", formatter.string(from: date), "\(previousValue)")
        if sumValue != nil {
            self.accessibilityNode.accessibilityValue = Localizations.Accessibility.Evaluate.Counter.summorySum("\(sumValue!)")
        }
        
        self.customValueButton.addTarget(self, action: #selector(self.enterValueInitialAction(sender:)), forControlEvents: .touchDown)
        self.customValueButton.addTarget(self, action: #selector(self.enterValueEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.customValueButton.addTarget(self, action: #selector(self.enterValueEndAction(sender:)), forControlEvents: .touchUpInside)
        self.customValueButton.addTarget(self, action: #selector(self.enterValueEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.plus.addTarget(self, action: #selector(self.plusInitialAction(sender:)), forControlEvents: .touchDown)
        self.plus.addTarget(self, action: #selector(self.plusEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.plus.addTarget(self, action: #selector(self.plusEndAction(sender:)), forControlEvents: .touchUpInside)
        self.plus.addTarget(self, action: #selector(self.plusEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.minus.addTarget(self, action: #selector(self.minusInitialAction(sender:)), forControlEvents: .touchDown)
        self.minus.addTarget(self, action: #selector(self.minusEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.minus.addTarget(self, action: #selector(self.minusEndAction(sender:)), forControlEvents: .touchUpInside)
        self.minus.addTarget(self, action: #selector(self.minusEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        // Buttons
        let buttonsSize: CGFloat = 50.0
        let buttonCornerRadius: CGFloat = 10.0
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
        
        let measurementInsets = UIEdgeInsets(top: -17.0, left: 0.0, bottom: 0.0, right: 5.0)
        let currentMeasurementInset = ASInsetLayoutSpec(insets: measurementInsets, child: self.currentMeasurement)
        let previousMeasurementInset = ASInsetLayoutSpec(insets: measurementInsets, child: self.previousMeasurement)
        
        let currentStack = ASStackLayoutSpec.vertical()
        currentStack.alignItems = .end
        currentStack.spacing = 10.0
        currentStack.children = [self.counter, currentMeasurementInset, self.currentDate]
        
        let previousStack = ASStackLayoutSpec.vertical()
        previousStack.alignItems = .end
        previousStack.spacing = 10.0
        previousStack.children = [self.previousValue, previousMeasurementInset, self.previousDate]
        
        self.separator.style.preferredSize = CGSize(width: 4.0, height: 80.0)
        
        let valuesStack = ASStackLayoutSpec.horizontal()
        valuesStack.spacing = 20.0
        valuesStack.alignItems = .end
        valuesStack.flexWrap = .wrap
        valuesStack.children = [currentStack, self.separator, previousStack]
        
        let fullValueStack = ASStackLayoutSpec.vertical()
        fullValueStack.spacing = 5.0
        fullValueStack.children = [valuesStack]
        
        if self.sumText != nil {
            let sumStack = ASStackLayoutSpec.horizontal()
            sumStack.justifyContent = .end
            sumStack.children = [self.sumText!]
            
            fullValueStack.children?.append(sumStack)
        }
        
        let valueInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
        let valueInset = ASInsetLayoutSpec(insets: valueInsets, child: fullValueStack)
        
        let valueInsetAccessibility = ASBackgroundLayoutSpec(child: valueInset, background: self.accessibilityNode)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 5.0
        cell.children = [valueInsetAccessibility, buttons]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func enterValueInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.customValueButtonCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func enterValueEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.customValueButtonCover.backgroundColor = UIColor.main
        }
    }
    
    @objc func plusInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.plusCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func plusEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.plusCover.backgroundColor = UIColor.main
        }
    }
    
    @objc func minusInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.minusCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func minusEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.minusCover.backgroundColor = UIColor.main
        }
    }
}
