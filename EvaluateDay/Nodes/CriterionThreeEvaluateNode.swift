//
//  CriterionThreeEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CriterionThreeEvaluateNode: ASCellNode {
    // MARK: - UI
    var topButton = ASButtonNode()
    var middleButton = ASButtonNode()
    var bottomButton = ASButtonNode()
    var currentDate = ASTextNode()
    var previousDate: ASTextNode!
    var previousImage: ASImageNode!
    var cover = ASDisplayNode()
    
    var didChangeValue: ((_ value: Int) -> Void)?
    
    // MARK: - Init
    init(value: Double?, previousValue: Double?, date: Date, lock: Bool, positive: Bool) {
        super.init()
        
        self.cover.backgroundColor = positive ? UIColor.positive : UIColor.negative
        self.cover.cornerRadius = 10.0
        
        self.topButton.setImage(#imageLiteral(resourceName: "good").resizedImage(newSize: CGSize(width: 50.0, height: 50.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.middleButton.setImage(#imageLiteral(resourceName: "neutral").resizedImage(newSize: CGSize(width: 50.0, height: 50.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.bottomButton.setImage(#imageLiteral(resourceName: "bad").resizedImage(newSize: CGSize(width: 50.0, height: 50.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        
        self.topButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.textTint)
        self.middleButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.textTint)
        self.bottomButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.textTint)
        
        if value != nil {
            if value == 0 {
                self.bottomButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.selected)
            } else if value == 1 {
                self.middleButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.selected)
            } else if value == 2 {
                self.topButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.selected)
            }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.currentDate.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.textTint])
        
        if let previousValue = previousValue {
            self.previousImage = ASImageNode()
            if previousValue == 0 {
                self.previousImage.image = Images.Media.bad.image
            } else if previousValue == 1 {
                self.previousImage.image = Images.Media.neutral.image
            } else if previousValue == 2 {
                self.previousImage.image = Images.Media.good.image
            }
            self.previousImage.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.textTint)
            
            var previousValueString = ""
            if previousValue == 0 {
                previousValueString = Localizations.Accessibility.Evaluate.Criterion.Three.bad
                if !positive {
                    previousValueString = Localizations.Accessibility.Evaluate.Criterion.Three.good
                }
            } else if previousValue == 1 {
                previousValueString = Localizations.Accessibility.Evaluate.Criterion.Three.neutral
            } else {
                previousValueString = Localizations.Accessibility.Evaluate.Criterion.Three.good
                if !positive {
                    previousValueString = Localizations.Accessibility.Evaluate.Criterion.Three.bad
                }
            }
            
            var components = DateComponents()
            components.day = -1
            
            let previousDate = Calendar.current.date(byAdding: components, to: date)!
            self.previousDate = ASTextNode()
            self.previousDate.attributedText = NSAttributedString(string: formatter.string(from: previousDate), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.textTint])
            
            // Accessibility
            self.previousDate.isAccessibilityElement = false
            self.previousImage.isAccessibilityElement = true
            self.previousImage.accessibilityLabel = Localizations.Accessibility.previous(previousValueString)
            self.previousImage.accessibilityValue = formatter.string(from: previousDate)
        }
        
        OperationQueue.main.addOperation {
            self.topButton.view.tag = 2
            self.middleButton.view.tag = 1
            self.bottomButton.view.tag = 0
        }
        
        if !lock {
            self.topButton.addTarget(self, action: #selector(buttonsAction(sender:)), forControlEvents: .touchUpInside)
            self.middleButton.addTarget(self, action: #selector(buttonsAction(sender:)), forControlEvents: .touchUpInside)
            self.bottomButton.addTarget(self, action: #selector(buttonsAction(sender:)), forControlEvents: .touchUpInside)
        }
        
        // Accessibility
        self.currentDate.isAccessibilityElement = false
        self.topButton.accessibilityLabel = Localizations.Accessibility.Evaluate.Criterion.Three.good
        self.middleButton.accessibilityLabel = Localizations.Accessibility.Evaluate.Criterion.Three.neutral
        self.bottomButton.accessibilityLabel = Localizations.Accessibility.Evaluate.Criterion.Three.bad
        self.topButton.accessibilityHint = Localizations.Accessibility.Evaluate.Criterion.hint(formatter.string(from: date))
        self.middleButton.accessibilityHint = Localizations.Accessibility.Evaluate.Criterion.hint(formatter.string(from: date))
        self.bottomButton.accessibilityHint = Localizations.Accessibility.Evaluate.Criterion.hint(formatter.string(from: date))
        
        if !positive {
            self.topButton.accessibilityLabel = Localizations.Accessibility.Evaluate.Criterion.Three.bad
            self.bottomButton.accessibilityLabel = Localizations.Accessibility.Evaluate.Criterion.Three.good
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.topButton.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        self.middleButton.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        self.bottomButton.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        
        let buttons = ASStackLayoutSpec.horizontal()
        buttons.spacing = 10
        buttons.children = [self.topButton, self.middleButton, self.bottomButton]
        
        let currentStack = ASStackLayoutSpec.vertical()
        currentStack.spacing = 5
        currentStack.alignItems = .end
        currentStack.children = [buttons, self.currentDate]
        
        let content = ASStackLayoutSpec.horizontal()
        content.spacing = 30.0
        content.justifyContent = .spaceBetween
        content.children = [currentStack]
        
        if self.previousDate != nil {
            self.previousImage.style.preferredSize = CGSize(width: 50.0, height: 50.0)
            
            let previousStack = ASStackLayoutSpec.vertical()
            previousStack.spacing = 5.0
            previousStack.alignItems = .end
            previousStack.children = [self.previousImage, self.previousDate]
            
            content.children?.append(previousStack)
        }
        
        let contentInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc private func buttonsAction(sender: ASButtonNode) {
        let value = sender.view.tag
        self.didChangeValue?(value)
    }
}
