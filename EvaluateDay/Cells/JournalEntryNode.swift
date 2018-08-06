//
//  JournalEntryNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 04/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol JournalEntryNodeStyle {
    var journalNodeTextFont: UIFont { get }
    var journalNodeTextColor: UIColor { get }
    var journalNodeMetadataFont: UIFont { get }
    var journalNodeMetadataColor: UIColor { get }
}

class JournalEntryNode: ASCellNode {
    // MARK: - UI
    var imageNode: ASImageNode!
    var textPreview = ASTextNode()
    var metadataNode = ASTextNode()
    var separator = ASDisplayNode()
    
    private var button: ASButtonNode!
    
    // MARK: - Variables
    
    var didSelectItem: ((_ index: Int) -> Void)?
    
    private var index: Int = 0
    
    // MARK: - Init
    init(text: String, metadata: [String], photo: UIImage?, index: Int? = nil, style: JournalEntryNodeStyle) {
        super.init()
        
        if index != nil {
            self.index = index!
        }
        
        var newText = text
        if newText.isEmpty {
            newText = Localizations.evaluate.journal.entry.placeholder
        }
        
        if photo != nil {
            self.imageNode = ASImageNode ()
            self.imageNode.image = photo
            self.imageNode.contentMode = .scaleAspectFill
            self.imageNode.clipsToBounds = true
            self.imageNode.cornerRadius = 5.0
        }
        
        self.textPreview.attributedText = NSAttributedString(string: newText, attributes: [NSAttributedStringKey.font: style.journalNodeTextFont, NSAttributedStringKey.foregroundColor: style.journalNodeTextColor])
        
        var metadataString = ""
        for (i, m) in metadata.enumerated() {
            if i != 0 {
                metadataString += " • "
            }
            
            metadataString += m
        }
        
        self.metadataNode.attributedText = NSAttributedString(string: metadataString, attributes: [NSAttributedStringKey.font: style.journalNodeMetadataFont, NSAttributedStringKey.foregroundColor: style.journalNodeMetadataColor])
        
        self.separator.backgroundColor = style.journalNodeMetadataColor
        
        if index != nil {
            self.button = ASButtonNode()
            self.button.addTarget(self, action: #selector(self.buttonAction(sender:)), forControlEvents: .touchUpInside)
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let textInsets = UIEdgeInsets(top: 10.0, left: 5.0, bottom: 10.0, right: 5.0)
        let textInset = ASInsetLayoutSpec(insets: textInsets, child: self.textPreview)
        
        self.separator.style.preferredSize = CGSize(width: 200.0, height: 1.0)
        
        let meta = ASStackLayoutSpec.vertical()
        meta.spacing = 5.0
        meta.alignItems = .end
        meta.children = [self.metadataNode, self.separator]
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 5.0
        cell.children = [textInset, meta]
        
        if self.imageNode != nil {
            self.imageNode.style.preferredSize.height = constrainedSize.max.width / 1.70
            cell.children?.insert(self.imageNode, at: 0)
        }
        
        let cellInsets = UIEdgeInsets(top: 30.0, left: 10.0, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        if self.button != nil {
            let back = ASOverlayLayoutSpec(child: cellInset, overlay: self.button)
            return back
        }
        
        return cellInset
    }
    
    // MARK: - Action
    @objc func buttonAction(sender: ASButtonNode) {
        self.didSelectItem?(self.index)
    }
}
