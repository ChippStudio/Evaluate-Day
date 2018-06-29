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
}

class CriterionThreeEvaluateNode: ASCellNode {
    // MARK: - UI
    var topButton = ASButtonNode()
    var middleButton = ASButtonNode()
    var bottomButton = ASButtonNode()
    
    // MARK: - Variables
    private var goodColor: UIColor!
    private var neutralColor: UIColor!
    private var badColor: UIColor!
    
    var didChangeValue: ((_ value: Int) -> Void)?
    
    // MARK: - Init
    init(value: Double?, lock: Bool, positive: Bool, style: CriterionThreeEvaluateNodeStyle) {
        super.init()
        
        self.topButton.setImage(#imageLiteral(resourceName: "good").resizedImage(newSize: CGSize(width: 40.0, height: 40.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.middleButton.setImage(#imageLiteral(resourceName: "neutral").resizedImage(newSize: CGSize(width: 40.0, height: 40.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.bottomButton.setImage(#imageLiteral(resourceName: "bad").resizedImage(newSize: CGSize(width: 40.0, height: 40.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        
        self.topButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.criterionThreeEvaluateUnsetColor)
        self.middleButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.criterionThreeEvaluateUnsetColor)
        self.bottomButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.criterionThreeEvaluateUnsetColor)
        
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
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 5.0
        cell.justifyContent = .end
        cell.children = [self.topButton, self.middleButton, self.bottomButton]
        
        let cellInsets = UIEdgeInsets(top: 5.0, left: 0.0, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc private func buttonsAction(sender: ASButtonNode) {
        let value = sender.view.tag
        self.didChangeValue?(value)
    }
}
