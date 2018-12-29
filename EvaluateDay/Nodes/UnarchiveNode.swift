//
//  UnarchiveNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 15/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol UnarchiveNodeStyle {
    var unarchiveButtonFont: UIFont { get }
    var unarchiveButtonColor: UIColor { get }
    var unarchiveDividerColor: UIColor { get }
}

class UnarchiveNode: ASCellNode {
    
    // MARK: - UI
    var unarchiveButton = ASButtonNode()
    var topDivider: ASDisplayNode!
    var dotDivider: ASDisplayNode!
    
    // MARK: - Variables
    var bottomOffset: CGFloat = 50.0
    
    // MARK: - Init
    init(isDividers: Bool = true, style: UnarchiveNodeStyle) {
        super.init()
        
        if isDividers {
            self.topDivider = ASDisplayNode()
            self.dotDivider = ASDisplayNode()
            
            self.topDivider.backgroundColor = style.unarchiveDividerColor
            self.dotDivider.backgroundColor = style.unarchiveDividerColor
            
            self.topDivider.style.preferredSize = CGSize(width: 1.0, height: 10.0)
            self.dotDivider.style.preferredSize = CGSize(width: 20.0, height: 20.0)
            self.dotDivider.cornerRadius = 5.0
        }
        
        let title = NSAttributedString(string: Localizations.general.unarchive, attributes: [NSAttributedStringKey.font: style.unarchiveButtonFont, NSAttributedStringKey.foregroundColor: style.unarchiveButtonColor])
        
        self.unarchiveButton.setAttributedTitle(title, for: .normal)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let spacing = ASLayoutSpec()
        spacing.style.flexGrow = 1.0
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.children = [spacing, self.unarchiveButton]
        
        let cellInsets = UIEdgeInsets(top: 5.0, left: 20.0, bottom: bottomOffset, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        if self.topDivider != nil {
            let divides = ASStackLayoutSpec.vertical()
            divides.alignItems = .center
            divides.children = [self.topDivider, self.dotDivider]
            
            let fullCell = ASStackLayoutSpec.horizontal()
            fullCell.spacing = 0.0
            fullCell.justifyContent = .end
            fullCell.children = [cellInset, divides]
            
            let fullCellInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 10.0)
            let fullCellInset = ASInsetLayoutSpec(insets: fullCellInsets, child: fullCell)
            
            return fullCellInset
        }
        
        return cellInset
    }
}
