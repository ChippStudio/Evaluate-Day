//
//  CriterionThreeEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol CriterionThreeEvaluateNodeStyle {
    var criterionThreeEvaluatePositiveColor: UIColor { get }
    var criterionThreeEvaluateNeutralColor: UIColor { get }
    var criterionThreeEvaluateNegativeColor: UIColor { get }
    var criterionThreeEvaluateUnsetColor: UIColor { get }
    var criterionThreeEvaluateSeparatorColor: UIColor { get }
    var criterionThreeEvaluateDateColor: UIColor { get }
    var criterionThreeEvaluateDateFont: UIFont { get }
}

class CriterionThreeEvaluateNode: ASCellNode {
    // MARK: - UI
    var topButton = ASButtonNode()
    var middleButton = ASButtonNode()
    var bottomButton = ASButtonNode()
    var currentDate = ASTextNode()
    var previousDate: ASTextNode!
    var previousImage: ASImageNode!
    var separator: ASDisplayNode!
    
    // MARK: - Variables
    private var goodColor: UIColor!
    private var neutralColor: UIColor!
    private var badColor: UIColor!
    
    var didChangeValue: ((_ value: Int) -> Void)?
    
    // MARK: - Init
    init(value: Double?, previousValue: Double?, date: Date, lock: Bool, positive: Bool, style: CriterionThreeEvaluateNodeStyle) {
        super.init()
        
        self.topButton.setImage(#imageLiteral(resourceName: "good").resizedImage(newSize: CGSize(width: 50.0, height: 50.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.middleButton.setImage(#imageLiteral(resourceName: "neutral").resizedImage(newSize: CGSize(width: 50.0, height: 50.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.bottomButton.setImage(#imageLiteral(resourceName: "bad").resizedImage(newSize: CGSize(width: 50.0, height: 50.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        
        self.topButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.criterionThreeEvaluateUnsetColor)
        self.middleButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.criterionThreeEvaluateUnsetColor)
        self.bottomButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.criterionThreeEvaluateUnsetColor)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.currentDate.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: style.criterionThreeEvaluateDateFont, NSAttributedStringKey.foregroundColor: style.criterionThreeEvaluateDateColor])
        
        goodColor = style.criterionThreeEvaluatePositiveColor
        neutralColor = style.criterionThreeEvaluateNeutralColor
        badColor = style.criterionThreeEvaluateNegativeColor
        
        if !positive {
            goodColor = style.criterionThreeEvaluateNegativeColor
            badColor = style.criterionThreeEvaluatePositiveColor
        }
        
        if value != nil {
            if value == 0 {
                self.bottomButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(badColor)
            } else if value == 1 {
                self.middleButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(neutralColor)
            } else if value == 2 {
                self.topButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(goodColor)
            }
        }
        
        if let previousValue = previousValue {
            self.previousImage = ASImageNode()
            if previousValue == 0 {
                self.previousImage.image = #imageLiteral(resourceName: "bad")
                self.previousImage.imageModificationBlock = ASImageNodeTintColorModificationBlock(badColor)
            } else if previousValue == 1 {
                self.previousImage.image = #imageLiteral(resourceName: "neutral")
                self.previousImage.imageModificationBlock = ASImageNodeTintColorModificationBlock(neutralColor)
            } else if previousValue == 2 {
                self.previousImage.image = #imageLiteral(resourceName: "good")
                self.previousImage.imageModificationBlock = ASImageNodeTintColorModificationBlock(goodColor)
            }
            
            var components = DateComponents()
            components.day = -1
            
            let previousDate = Calendar.current.date(byAdding: components, to: date)!
            self.previousDate = ASTextNode()
            self.previousDate.attributedText = NSAttributedString(string: formatter.string(from: previousDate), attributes: [NSAttributedStringKey.font: style.criterionThreeEvaluateDateFont, NSAttributedStringKey.foregroundColor: style.criterionThreeEvaluateDateColor])
            
            self.separator = ASDisplayNode()
            self.separator.backgroundColor = style.criterionThreeEvaluateSeparatorColor
            self.separator.cornerRadius = 2.0
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
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.topButton.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        self.middleButton.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        self.bottomButton.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        
        let buttons = ASStackLayoutSpec.horizontal()
        buttons.spacing = 20
        buttons.children = [self.topButton, self.middleButton, self.bottomButton]
        
        let currentStack = ASStackLayoutSpec.vertical()
        currentStack.spacing = 15
        currentStack.alignItems = .end
        currentStack.children = [buttons, self.currentDate]
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 20.0
        cell.children = [currentStack]
        
        if self.previousDate != nil {
            self.previousImage.style.preferredSize = CGSize(width: 50.0, height: 50.0)
            self.separator.style.preferredSize.width = 4.0
            
            let previousStack = ASStackLayoutSpec.vertical()
            previousStack.spacing = 15.0
            previousStack.alignItems = .end
            previousStack.children = [self.previousImage, self.previousDate]
            
            cell.children?.append(self.separator)
            cell.children?.append(previousStack)
        }
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 30.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc private func buttonsAction(sender: ASButtonNode) {
        let value = sender.view.tag
        self.didChangeValue?(value)
    }
}
