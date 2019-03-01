//
//  CriterionEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 07/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CriterionEvaluateNode: ASCellNode {
    // MARK: - UI
    var sliderNode = ASDisplayNode()
    var currentValue = ASTextNode()
    var currentDate = ASTextNode()
    var previousValue = ASTextNode()
    var previousDate = ASTextNode()
    var separator = ASDisplayNode()
    var persent = ASTextNode()
    var cover = ASDisplayNode()
    
    var accessibilityNode = ASDisplayNode()
    
    var slider: UISlider!
    
    // MARK: - Variables
    private var valueTextAtributes: [NSAttributedString.Key: Any]
    private var persentTextAttributes: [NSAttributedString.Key: Any]
    private let previousValueNumber: Float
    private let currentDateNumber: Date
    /// (value: Int)
    var didChangeValue: ((Int) -> Void)?
    var didSliderLoad: (() -> Void)?
    
    // MARK: - Init
    init(current: Float, previous: Float, date: Date, maxValue: Float, isPositive: Bool, lock: Bool = false) {
        
        self.previousValueNumber = previous
        self.currentDateNumber = date
        
        self.valueTextAtributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 50.0, weight: .medium), NSAttributedString.Key.foregroundColor: UIColor.textTint]
        self.persentTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.textTint]
        
        super.init()
        
        self.cover.backgroundColor = isPositive ? UIColor.positive : UIColor.negative
        self.cover.cornerRadius = 10.0
        
        self.currentValue.attributedText = NSAttributedString(string: "\(Int(current))", attributes: self.valueTextAtributes)
        self.previousValue.attributedText = NSAttributedString(string: "\(Int(previous))", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 50.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.textTint])
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        
        var components = DateComponents()
        components.day = -1
        
        let previousDate = Calendar.current.date(byAdding: components, to: date)!
        
        self.currentDate.attributedText = NSAttributedString(string: dateFormatter.string(from: date), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.textTint])
        self.previousDate.attributedText = NSAttributedString(string: dateFormatter.string(from: previousDate), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedString.Key.foregroundColor: UIColor.textTint])
        
        self.separator.backgroundColor = UIColor.textTint
        self.separator.cornerRadius = 2.0
        
        self.persent.attributedText = NSAttributedString(string: "\(calculatePercent(value: current))", attributes: self.persentTextAttributes)
        
        self.sliderNode = ASDisplayNode(viewBlock: { () -> UIView in
            self.slider = UISlider()
            self.slider.minimumValue = 0.0
            self.slider.maximumValue = maxValue
            self.slider.setValue(current, animated: true)
            self.slider.maximumTrackTintColor = UIColor.textTint
            self.slider.minimumTrackTintColor = UIColor.selected
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
        persentStack.justifyContent = .end
        persentStack.children = [self.persent]
        
        let dataStack = ASStackLayoutSpec.horizontal()
        dataStack.alignItems = .end
        dataStack.spacing = 20.0
        dataStack.flexWrap = .wrap
        dataStack.children = [currentValueStack, self.separator, previousValueStack]
        
        let fullStack = ASStackLayoutSpec.vertical()
        fullStack.spacing = 10.0
        fullStack.children = [dataStack, persentStack]
        
        let dataStackAccessibility = ASBackgroundLayoutSpec(child: fullStack, background: self.accessibilityNode)
        
        let cellStack = ASStackLayoutSpec.vertical()
        cellStack.spacing = 10.0
        cellStack.children = [dataStackAccessibility, self.sliderNode]
        
        let sliderInsets = UIEdgeInsets(top: 15.0, left: 10.0, bottom: 10.0, right: 10.0)
        let sliderInset = ASInsetLayoutSpec(insets: sliderInsets, child: cellStack)
        
        let cell = ASBackgroundLayoutSpec(child: sliderInset, background: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
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
            moreLess = Localizations.Accessibility.more
        } else if persent.first! == "▼" {
            moreLess = Localizations.Accessibility.less
        }
        
        let index = String.Index(encodedOffset: 1)
        persent = String(persent[index...])
        
        self.accessibilityNode.accessibilityLabel = Localizations.Accessibility.Evaluate.Criterion.value(dateFormatter.string(from: self.currentDateNumber), "\(Int(current))", persent, moreLess, "\(Int(self.previousValueNumber))")
    }
}
