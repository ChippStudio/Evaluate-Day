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
    var criterionEvaluateCurrentValueColor: UIColor { get }
    var criterionEvaluateCurrentValueFont: UIFont { get }
    var criterionEvaluateMaximumTrackColor: UIColor { get }
    var criterionEvaluateMinimumPositiveTrackColor: UIColor { get }
    var criterionEvaluateMinimumNegativeTrackColor: UIColor { get }
}
class CriterionEvaluateNode: ASCellNode {
    // MARK: - UI
    var sliderNode = ASDisplayNode()
    var currentValue = ASTextNode()
    
    // MARK: - Variables
    private var valueTextAtributes: [NSAttributedStringKey: Any]
    /// (value: Int)
    var didChangeValue: ((Int) -> Void)?
    
    // MARK: - Init
    init(current: Float, maxValue: Float, isPositive: Bool, lock: Bool = false, style: CriterionEvaluateNodeStyle) {
        self.valueTextAtributes = [NSAttributedStringKey.font: style.criterionEvaluateCurrentValueFont, NSAttributedStringKey.foregroundColor: style.criterionEvaluateCurrentValueColor]
        
        super.init()
        
        self.currentValue.attributedText = NSAttributedString(string: "\(Int(current))", attributes: self.valueTextAtributes)
        
        self.sliderNode = ASDisplayNode(viewBlock: { () -> UIView in
            let slider = UISlider()
            slider.minimumValue = 0.0
            slider.maximumValue = maxValue
            slider.setValue(current, animated: true)
            slider.maximumTrackTintColor = style.criterionEvaluateMaximumTrackColor
            if isPositive {
                slider.minimumTrackTintColor = style.criterionEvaluateMinimumPositiveTrackColor
            } else {
                slider.minimumTrackTintColor = style.criterionEvaluateMinimumNegativeTrackColor
            }
            slider.isEnabled = !lock
            slider.addTarget(self, action: #selector(self.sliderAction(sender:)), for: .valueChanged)
            return slider
        })
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.sliderNode.style.preferredSize.height = 30.0
        
        let cellStack = ASStackLayoutSpec.vertical()
        cellStack.spacing = 5.0
        cellStack.children = [self.currentValue, self.sliderNode]
        
        let sliderInsets = UIEdgeInsets(top: 0.0, left: 50.0, bottom: 10.0, right: 20.0)
        let sliderInset = ASInsetLayoutSpec(insets: sliderInsets, child: cellStack)
        
        return sliderInset
    }
    
    // MARK: - Actions
    private var timer: Timer = Timer()
    @objc func sliderAction(sender: UISlider) {
        self.timer.invalidate()
        self.currentValue.attributedText = NSAttributedString(string: "\(Int(sender.value))", attributes: self.valueTextAtributes)
        //self.didChangeValue?(Int(sender.value))
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            self.didChangeValue?(Int(sender.value))
        })
    }
}
