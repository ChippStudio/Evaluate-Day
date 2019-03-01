//
//  ListItemEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ListItemEvaluateNode: ASCellNode {
    // MARK: - UI
    var doneDot = ASDisplayNode()
    var doneDotCover = ASDisplayNode()
    var doneButton = ASButtonNode()
    var text = ASTextNode()
    
    // MARK: - Variables
    var doneDidPressed: ((_ indexPath: IndexPath) -> Void)?
    
    // MARK: - Init
    init(text: String, done: Bool) {
        super.init()
        
        self.text.attributedText = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.text, NSAttributedString.Key.strikethroughColor: UIColor.text, NSAttributedString.Key.strikethroughStyle: NSNumber(value: done)])
        
        self.doneDotCover.borderColor = UIColor.main.cgColor
        self.doneDotCover.borderWidth = 1.0
        
        if done {
            self.doneDot.backgroundColor = UIColor.main
        }
        
        self.doneButton.addTarget(self, action: #selector(self.buttonAction(sender:)), forControlEvents: .touchUpInside)
        
        // Accessibility
        self.text.accessibilityTraits = UIAccessibilityTraits.button
        self.text.accessibilityHint = Localizations.Accessibility.Evaluate.List.editItemHint
        
        self.doneButton.accessibilityLabel = Localizations.Accessibility.Evaluate.List.checkbox + ", \(text)"
        if done {
            self.doneButton.accessibilityValue = Localizations.Accessibility.Evaluate.List.completed
            self.doneButton.accessibilityHint = Localizations.Accessibility.Evaluate.List.checkboxHint(Localizations.Accessibility.Evaluate.List.uncompleted)
        } else {
            self.doneButton.accessibilityValue = Localizations.Accessibility.Evaluate.List.uncompleted
            self.doneButton.accessibilityHint = Localizations.Accessibility.Evaluate.List.checkboxHint(Localizations.Accessibility.Evaluate.List.completed)
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let dotSize: CGFloat = 20.0
        let dotOffset: CGFloat = 2.0
        
        self.doneButton.style.preferredSize = CGSize(width: dotSize, height: dotSize)
        self.doneDot.cornerRadius = dotSize / 2
        self.doneDotCover.cornerRadius = (dotSize + 2 * dotOffset) / 2
        
        let buttonDot = ASBackgroundLayoutSpec(child: self.doneButton, background: self.doneDot)
        
        let dotInsets = UIEdgeInsets(top: dotOffset, left: dotOffset, bottom: dotOffset, right: dotOffset)
        let dotInset = ASInsetLayoutSpec(insets: dotInsets, child: buttonDot)
        
        let fullDot = ASBackgroundLayoutSpec(child: dotInset, background: self.doneDotCover)
        
        self.text.style.flexShrink = 1.0
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 10.0
        cell.alignItems = .center
        cell.children = [fullDot, self.text]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func buttonAction(sender: ASButtonNode) {
        if self.indexPath != nil {
            self.doneDidPressed?(self.indexPath!)
        }
    }
}
