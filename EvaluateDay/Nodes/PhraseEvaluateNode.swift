//
//  PhraseEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class PhraseEvaluateNode: ASCellNode {
    
    // MARK: - UI
    var text = ASTextNode()
    var date = ASTextNode()
    var editButton = ASButtonNode()
    var cover = ASDisplayNode()
    
    // MARK: - Init
    init(text: String, date: Date) {
        super.init()
        
        self.cover.backgroundColor = UIColor.main
        self.cover.cornerRadius = 10.0
        
        self.text.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.textTint])
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.date.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.textTint])
        self.date.isAccessibilityElement = false
        
        self.text.accessibilityLabel = text
        self.text.accessibilityValue = formatter.string(from: date)
        
        self.editButton.addTarget(self, action: #selector(self.editInitialAction(sender:)), forControlEvents: .touchDown)
        self.editButton.addTarget(self, action: #selector(self.editEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.editButton.addTarget(self, action: #selector(self.editEndAction(sender:)), forControlEvents: .touchUpInside)
        self.editButton.addTarget(self, action: #selector(self.editEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.editButton.accessibilityValue = Localizations.Accessibility.Evaluate.phraseEdit(formatter.string(from: date))
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.text.style.flexShrink = 1.0
        
        let dateStack = ASStackLayoutSpec.horizontal()
        dateStack.justifyContent = .end
        dateStack.children = [self.date]
        
        let content = ASStackLayoutSpec.vertical()
        content.spacing = 10.0
        content.children = [self.text, dateStack]
        
        let contentInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 10.0, right: 10.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cellCover = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)
        
        let cell = ASOverlayLayoutSpec(child: cellCover, overlay: self.editButton)
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func editInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func editEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.main
        }
    }
}
