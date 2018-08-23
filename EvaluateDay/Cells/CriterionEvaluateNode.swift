//
//  CriterionEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 07/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol CriterionEvaluateNodeStyle {
    var criterionEvaluateCurrentValueFont: UIFont { get }
    var criterionEvaluateDateColor: UIColor { get }
    var criterionEvaluateDateFont: UIFont { get }
    var criterionEvaluatePreviousValueColor: UIColor { get }
    var criterionEvaluatePreviousValueFont: UIFont { get }
    var criterionEvaluatePersentColor: UIColor { get }
    var criterionEvaluatePersentFont: UIFont { get }
    var criterionEvaluateSeparatorColor: UIColor { get }
    var criterionEvaluateMaximumTrackColor: UIColor { get }
    var criterionEvaluateMinimumPositiveTrackColor: UIColor { get }
    var criterionEvaluateMinimumNegativeTrackColor: UIColor { get }
}
class CriterionEvaluateNode: ASCellNode {
    // MARK: - UI
    var sliderNode = ASDisplayNode()
    var currentValue = ASTextNode()
    var currentDate = ASTextNode()
    var previousValue = ASTextNode()
    var previousDate = ASTextNode()
    var separator = ASDisplayNode()
    var persent = ASTextNode()
    
    var accessibilityNode = ASDisplayNode()
    
    var slider: UISlider!
    
    // MARK: - Variables
    private var valueTextAtributes: [NSAttributedStringKey: Any]
    private var persentTextAttributes: [NSAttributedStringKey: Any]
    private let previousValueNumber: Float
    private let currentDateNumber: Date
    /// (value: Int)
    var didChangeValue: ((Int) -> Void)?
    var didSliderLoad: (() -> Void)?
    
    // MARK: - Init
    init(current: Float, previous: Float, date: Date, maxValue: Float, isPositive: Bool, lock: Bool = false, style: CriterionEvaluateNodeStyle) {
        var currentValuaeColor = style.criterionEvaluateMinimumPositiveTrackColor
        if !isPositive {
            currentValuaeColor = style.criterionEvaluateMinimumNegativeTrackColor
        }
        
        self.valueTextAtributes = [NSAttributedStringKey.font: style.criterionEvaluateCurrentValueFont, NSAttributedStringKey.foregroundColor: currentValuaeColor]
        self.persentTextAttributes = [NSAttributedStringKey.font: style.criterionEvaluatePersentFont, NSAttributedStringKey.foregroundColor: style.criterionEvaluatePersentColor]
        
        self.previousValueNumber = previous
        self.currentDateNumber = date
        
        super.init()
        
        self.currentValue.attributedText = NSAttributedString(string: "\(Int(current))", attributes: self.valueTextAtributes)
        self.previousValue.attributedText = NSAttributedString(string: "\(Int(previous))", attributes: [NSAttributedStringKey.font: style.criterionEvaluatePreviousValueFont, NSAttributedStringKey.foregroundColor: style.criterionEvaluatePreviousValueColor])
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        
        var components = DateComponents()
        components.day = -1
        
        let previousDate = Calendar.current.date(byAdding: components, to: date)!
        
        self.currentDate.attributedText = NSAttributedString(string: dateFormatter.string(from: date), attributes: [NSAttributedStringKey.font: style.criterionEvaluateDateFont, NSAttributedStringKey.foregroundColor: style.criterionEvaluateDateColor])
        self.previousDate.attributedText = NSAttributedString(string: dateFormatter.string(from: previousDate), attributes: [NSAttributedStringKey.font: style.criterionEvaluateDateFont, NSAttributedStringKey.foregroundColor: style.criterionEvaluateDateColor])
        
        self.separator.backgroundColor = style.criterionEvaluateSeparatorColor
        self.separator.cornerRadius = 2.0
        
        self.persent.attributedText = NSAttributedString(string: "\(calculatePercent(value: current))", attributes: self.persentTextAttributes)
        
        self.sliderNode = ASDisplayNode(viewBlock: { () -> UIView in
            self.slider = UISlider()
            self.slider.minimumValue = 0.0
            self.slider.maximumValue = maxValue
            self.slider.setValue(current, animated: true)
            self.slider.maximumTrackTintColor = style.criterionEvaluateMaximumTrackColor
            if isPositive {
                self.slider.minimumTrackTintColor = style.criterionEvaluateMinimumPositiveTrackColor
            } else {
                self.slider.minimumTrackTintColor = style.criterionEvaluateMinimumNegativeTrackColor
            }
            self.slider.isEnabled = !lock
            self.slider.addTarget(self, action: #selector(self.sliderAction(sender:)), for: .valueChanged)
            return self.slider
        }, didLoad: { (_) in
            self.didSliderLoad?()
        })
        
        // Accessibility
        self.currentDate.isAccessibilityElement = false
        self.currentValue.isAccessibilityElement = false
        self.previousDate.isAccessibilityElement = false
        self.previousValue.isAccessibilityElement = false
        self.persent.isAccessibilityElement = false
        
        self.accessibilityNode.isAccessibilityElement = true
        self.setAccessibilityLabel(current: current)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.sliderNode.style.preferredSize.height = 30.0
        self.separator.style.preferredSize = CGSize(width: 4.0, height: 80.0)
        
        let currentValueStack = ASStackLayoutSpec.vertical()
        currentValueStack.alignItems = .end
        currentValueStack.children = [self.currentValue, self.currentDate]
        
        let previousValueStack = ASStackLayoutSpec.vertical()
        previousValueStack.alignItems = .end
        previousValueStack.children = [self.previousValue, self.previousDate]
        
        let persentStack = ASStackLayoutSpec.horizontal()
        persentStack.children = [self.persent]
        
        let dataStack = ASStackLayoutSpec.horizontal()
        dataStack.alignItems = .end
        dataStack.spacing = 20.0
        dataStack.flexWrap = .wrap
        dataStack.children = [currentValueStack, self.separator, previousValueStack, persentStack]
        
        let dataStackAccessibility = ASBackgroundLayoutSpec(child: dataStack, background: self.accessibilityNode)
        
        let cellStack = ASStackLayoutSpec.vertical()
        cellStack.spacing = 40.0
        cellStack.children = [dataStackAccessibility, self.sliderNode]
        
        let sliderInsets = UIEdgeInsets(top: 30.0, left: 30.0, bottom: 40.0, right: 20.0)
        let sliderInset = ASInsetLayoutSpec(insets: sliderInsets, child: cellStack)
        
        return sliderInset
    }
    
    // MARK: - Actions
    private var timer: Timer = Timer()
    @objc func sliderAction(sender: UISlider) {
        self.timer.invalidate()
        self.currentValue.attributedText = NSAttributedString(string: "\(Int(sender.value))", attributes: self.valueTextAtributes)
        self.persent.attributedText = NSAttributedString(string: "\(calculatePercent(value: sender.value))", attributes: self.persentTextAttributes)
        self.setAccessibilityLabel(current: sender.value)
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.didChangeValue?(Int(sender.value))
        })
    }
    
    private func calculatePercent(value: Float) -> String {
        if value == 0.0 || self.previousValueNumber == 0.0 {
            return "---"
        }
        
        var calcResult = (value/self.previousValueNumber) - 1.0
        var arrow = "▲"
        
        if calcResult < 0 {
            arrow = "▼"
            calcResult = calcResult * -1
        }
        
        let persent = calcResult * 100
        
        return "\(arrow)\(Int(persent))%"
    }
    
    private func setAccessibilityLabel(current: Float) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        
        var persent = self.calculatePercent(value: current)
        var moreLess = ""
        
        if persent.first! == "▲" {
            moreLess = Localizations.accessibility.evaluate.value.more
        } else if persent.first! == "▼" {
            moreLess = Localizations.accessibility.evaluate.value.less
        }
        
        let index = String.Index(encodedOffset: 1)
        persent = String(persent[index...])
        
        self.accessibilityNode.accessibilityLabel = Localizations.accessibility.evaluate.value.criterion.value(value1: dateFormatter.string(from: self.currentDateNumber), "\(Int(current))", persent, moreLess, "\(Int(self.previousValueNumber))")
    }
}
