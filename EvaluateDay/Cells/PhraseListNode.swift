//
//  PhraseListNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 19/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol PhraseListNodeStyle {
    var phraseListDateFont: UIFont { get }
    var phraseListDateColor: UIColor { get }
    var phraseListTextFont: UIFont { get }
    var phraseListTextColor: UIColor { get }
}

class PhraseListNode: ASCellNode {
    // MARK: - UI
    var textNode = ASTextNode()
    var dateNode = ASTextNode()
    
    // MARK: - Init
    init(text: String, date: Date, style: PhraseListNodeStyle) {
        super.init()
        
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        self.dateNode.attributedText = NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: style.phraseListDateFont, NSAttributedStringKey.foregroundColor: style.phraseListDateColor])
        
        self.textNode.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: style.phraseListTextFont, NSAttributedStringKey.foregroundColor: style.phraseListTextColor])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.textNode.style.flexShrink = 1.0
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 5.0
        cell.children = [self.dateNode, self.textNode]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
