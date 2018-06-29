//
//  ListItemEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol ListItemEvaluateNodeStyle {
    var listItemTextFont: UIFont { get }
    var listItemTextColor: UIColor { get }
    var listItemTintColor: UIColor { get }
}

class ListItemEvaluateNode: ASCellNode {
    // MARK: - UI
    var doneDot = ASDisplayNode()
    var doneDotCover = ASDisplayNode()
    var doneButton = ASButtonNode()
    var text = ASTextNode()
    
    // MARK: - Variables
    var doneDidPressed: ((_ indexPath: IndexPath) -> Void)?
    
    // MARK: - Init
    init(text: String, done: Bool, style: ListItemEvaluateNodeStyle) {
        super.init()
        
        self.text.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: style.listItemTextFont, NSAttributedStringKey.foregroundColor: style.listItemTextColor, NSAttributedStringKey.strikethroughColor: style.listItemTintColor, NSAttributedStringKey.strikethroughStyle: NSNumber(value: done)])
        
        self.doneDotCover.borderColor = style.listItemTintColor.cgColor
        self.doneDotCover.borderWidth = 1.0
        
        if done {
            self.doneDot.backgroundColor = style.listItemTintColor
        }
        
        self.doneButton.addTarget(self, action: #selector(self.buttonAction(sender:)), forControlEvents: .touchUpInside)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let dotSize: CGFloat = 30.0
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
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
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
