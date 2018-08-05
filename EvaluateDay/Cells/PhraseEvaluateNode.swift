//
//  PhraseEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol PhraseEvaluateNodeStyle {
    var phraseEvaluateTextFont: UIFont { get }
    var phraseEvaluateTextColor: UIColor { get }
    var phraseEvaluateButtonColor: UIColor { get }
    var phraseEvaluateButtonTextFont: UIFont { get }
    var phraseEvaluateDateColor: UIColor { get }
    var phraseEvaluateDateFont: UIFont { get }
}

class PhraseEvaluateNode: ASCellNode {
    
    // MARK: - UI
    var text = ASTextNode()
    var date = ASTextNode()
    var editButton = ASButtonNode()
    var editButtonCover = ASDisplayNode()
    
    // MARK: - Init
    init(text: String, date: Date, style: PhraseEvaluateNodeStyle) {
        super.init()
        
        self.editButtonCover.borderColor = style.phraseEvaluateButtonColor.cgColor
        self.editButtonCover.borderWidth = 1.0
        
        self.editButton.setAttributedTitle(NSAttributedString(string: Localizations.general.edit, attributes: [NSAttributedStringKey.font: style.phraseEvaluateButtonTextFont, NSAttributedStringKey.foregroundColor: style.phraseEvaluateButtonColor]), for: .normal)
        
        self.text.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: style.phraseEvaluateTextFont, NSAttributedStringKey.foregroundColor: style.phraseEvaluateTextColor])
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.date.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: style.phraseEvaluateDateFont, NSAttributedStringKey.foregroundColor: style.phraseEvaluateDateColor])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.editButtonCover.cornerRadius = 10.0
        let buttonInsets = UIEdgeInsets(top: 7.0, left: 40.0, bottom: 7.0, right: 40.0)
        let buttonInset = ASInsetLayoutSpec(insets: buttonInsets, child: self.editButton)
        
        let edit = ASBackgroundLayoutSpec(child: buttonInset, background: self.editButtonCover)
        
        self.text.style.flexShrink = 1.0
        
        let editAndDate = ASStackLayoutSpec.horizontal()
        editAndDate.justifyContent = .spaceBetween
        editAndDate.alignItems = .end
        editAndDate.children = [edit, self.date]
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 10.0
        cell.children = [self.text, editAndDate]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 20.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
