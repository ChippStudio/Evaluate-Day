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
    var journalNewEntryActionDateFont: UIFont { get }
    var journalNewEntryActionDateColor: UIColor { get }
}

class JournalNewEntryActionNode: ASCellNode {
    // MARK: - UI
    var actionButton = ASButtonNode()
    var currentDate = ASTextNode()
    
    // MARK: - Init
    init(date: Date, style: JournalNewEntryActionNodeStyle) {
        super.init()
        
        let actionTitle = NSAttributedString(string: Localizations.evaluate.journal.newEntry, attributes: [NSAttributedStringKey.font: style.journalNewEntryActionButtonFont, NSAttributedStringKey.foregroundColor: style.journalNewEntryActionButtonColor])
        let actionHighlightedTitle = NSAttributedString(string: Localizations.evaluate.journal.newEntry, attributes: [NSAttributedStringKey.font: style.journalNewEntryActionButtonFont, NSAttributedStringKey.foregroundColor: style.journalNewEntryActionButtonHighlightedColor])
        
        self.actionButton.setAttributedTitle(actionTitle, for: .normal)
        self.actionButton.setAttributedTitle(actionHighlightedTitle, for: .highlighted)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.currentDate.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.foregroundColor: style.journalNewEntryActionDateColor, NSAttributedStringKey.font: style.journalNewEntryActionDateFont])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let newSatck = ASStackLayoutSpec.vertical()
        newSatck.spacing = 10.0
        newSatck.alignItems = .start
        newSatck.children = [self.currentDate, self.actionButton]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 20.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: newSatck)
        
        return cellInset
    }
}
