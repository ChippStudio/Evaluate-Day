//
//  JournalNewEntryActionNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 02/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class JournalNewEntryActionNode: ASCellNode {
    // MARK: - UI
    var actionButton = ASButtonNode()
    var actionButtonCover = ASDisplayNode()
    var currentDate = ASTextNode()
    
    var cover = ASDisplayNode()
    
    // MARK: - Init
    init(date: Date) {
        super.init()
        
        self.cover.backgroundColor = UIColor.background
        self.cover.cornerRadius = 10.0
        
        self.actionButtonCover.backgroundColor = UIColor.main
        self.actionButtonCover.cornerRadius = 10.0
        
        let actionTitle = NSAttributedString(string: Localizations.Evaluate.Journal.newEntry, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .title2), NSAttributedStringKey.foregroundColor: UIColor.textTint])
        
        self.actionButton.setAttributedTitle(actionTitle, for: .normal)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.currentDate.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.foregroundColor: UIColor.text, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0, weight: .regular)])
        
        self.currentDate.isAccessibilityElement = false
        self.actionButton.accessibilityLabel = Localizations.Accessibility.Evaluate.Journal.newEntry(formatter.string(from: date))
        
        self.actionButton.addTarget(self, action: #selector(self.buttonInitialAction(sender:)), forControlEvents: .touchDown)
        self.actionButton.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.actionButton.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchUpInside)
        self.actionButton.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let buttonInsets = UIEdgeInsets(top: 15.0, left: 15.0, bottom: 15.0, right: 15.0)
        let buttonInset = ASInsetLayoutSpec(insets: buttonInsets, child: self.actionButton)
        
        let button = ASBackgroundLayoutSpec(child: buttonInset, background: self.actionButtonCover)
        
        let content = ASStackLayoutSpec.vertical()
        content.spacing = 10.0
        content.children = [self.currentDate, button]
        
        let contentInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func buttonInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.actionButtonCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func buttonEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.actionButtonCover.backgroundColor = UIColor.tint
        }
    }
}
