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
    
    private var button: ASButtonNode!
    
    // MARK: - Variables
    
    var didSelectItem: ((_ index: Int) -> Void)?
    
    var leftOffset: CGFloat = 50.0
    private var sizeText: NSAttributedString!
    
    private var index: Int = 0
    
    // MARK: - Init
    init(text: String, metadata: [String], photo: UIImage?, index: Int? = nil, style: JournalEntryNodeStyle) {
        super.init()
        
        if index != nil {
            self.index = index!
        }
        
        if photo != nil {
            self.imageNode = ASImageNode ()
            self.imageNode.image = photo
            self.imageNode.contentMode = .scaleAspectFill
            self.imageNode.clipsToBounds = true
            self.imageNode.cornerRadius = 5.0
        }
        
        self.textPreview.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: style.journalNodeTextFont, NSAttributedStringKey.foregroundColor: style.journalNodeTextColor])
        
        var metadataString = ""
        for (i, m) in metadata.enumerated() {
            if i != 0 {
                metadataString += " • "
            }
            
            metadataString += m
        }
        
        self.metadataNode.attributedText = NSAttributedString(string: metadataString, attributes: [NSAttributedStringKey.font: style.journalNodeMetadataFont, NSAttributedStringKey.foregroundColor: style.journalNodeMetadataColor])
        
        self.sizeText = NSAttributedString(string: "A \n A", attributes: [NSAttributedStringKey.font: style.journalNodeTextFont, NSAttributedStringKey.foregroundColor: style.journalNodeTextColor])
        
        if index != nil {
            self.button = ASButtonNode()
            self.button.addTarget(self, action: #selector(self.buttonAction(sender:)), forControlEvents: .touchUpInside)
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let rightOffset: CGFloat = 10.0
        let itemsSpacingOffset: CGFloat = 10.0
        var imageOffset: CGFloat = 0.0
        if self.imageNode != nil {
            self.imageNode.style.preferredSize = CGSize(width: 50.0, height: 50.0)
            imageOffset = 50.0
        }
        
        self.textPreview.truncationMode = .byCharWrapping
        self.textPreview.style.preferredSize.width = constrainedSize.max.width - self.leftOffset - imageOffset - itemsSpacingOffset - rightOffset
        self.textPreview.style.preferredSize.height = self.sizeText.size().height
        
        let data = ASStackLayoutSpec.horizontal()
        data.spacing = itemsSpacingOffset
        data.children = [self.textPreview]
        if self.imageNode != nil {
            data.children?.insert(self.imageNode, at: 0)
        }
        
        self.metadataNode.style.flexShrink = 1.0
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 5.0
        cell.children = [data, self.metadataNode]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: self.leftOffset, bottom: 10.0, right: rightOffset)
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
