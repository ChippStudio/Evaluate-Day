//
//  JournalNewEntryActionNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 02/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol JournalNewEntryActionNodeStyle {
    var journalNewEntryActionButtonFont: UIFont { get }
    var journalNewEntryActionButtonColor: UIColor { get }
    var journalNewEntryActionButtonHighlightedColor: UIColor { get }
    var journalNewEntryActionTintColor: UIColor { get }
}

class JournalNewEntryActionNode: ASCellNode {
    // MARK: - UI
    var actionButton = ASButtonNode()
    var actionButtonCover = ASDisplayNode()
    var arrowView = ASImageNode()
    
    // MARK: - Init
    init(style: JournalNewEntryActionNodeStyle) {
        super.init()
        
        let actionTitle = NSAttributedString(string: Localizations.evaluate.journal.newEntry, attributes: [NSAttributedStringKey.font: style.journalNewEntryActionButtonFont, NSAttributedStringKey.foregroundColor: style.journalNewEntryActionButtonColor])
        let actionHighlightedTitle = NSAttributedString(string: Localizations.evaluate.journal.newEntry, attributes: [NSAttributedStringKey.font: style.journalNewEntryActionButtonFont, NSAttributedStringKey.foregroundColor: style.journalNewEntryActionButtonHighlightedColor])
        
        self.actionButton.setAttributedTitle(actionTitle, for: .normal)
        self.actionButton.setAttributedTitle(actionHighlightedTitle, for: .highlighted)
        
        self.actionButtonCover.cornerRadius = 5.0
        self.actionButtonCover.borderColor = style.journalNewEntryActionButtonColor.cgColor
        self.actionButtonCover.borderWidth = 1.0
        
        self.arrowView.image = #imageLiteral(resourceName: "disclosure")
        self.arrowView.contentMode = .scaleAspectFit
        self.arrowView.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.journalNewEntryActionTintColor)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let buttonInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        let buttonInset = ASInsetLayoutSpec(insets: buttonInsets, child: self.actionButton)
        
        let button = ASBackgroundLayoutSpec(child: buttonInset, background: self.actionButtonCover)
        button.style.flexGrow = 1.0
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 10.0
        cell.alignItems = .center
        cell.children = [button, self.arrowView]
        
        let cellInsets = UIEdgeInsets(top: 5.0, left: 50.0, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
