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
    var phraseEvaluateTintColor: UIColor { get }
}

class PhraseEvaluateNode: ASCellNode {
    
    // MARK: - UI
    var text = ASTextNode()
    var editButton = ASButtonNode()
    var editButtonCover = ASDisplayNode()
    
    // MARK: - Init
    init(text: String, style: PhraseEvaluateNodeStyle) {
        super.init()
        
        self.editButtonCover.borderColor = style.phraseEvaluateTintColor.cgColor
        self.editButtonCover.borderWidth = 1.0
        
        self.editButton.setImage(#imageLiteral(resourceName: "edit").resizedImage(newSize: CGSize(width: 30.0, height: 30.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.editButton.imageNode.contentMode = .scaleAspectFit
        self.editButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.phraseEvaluateTintColor)
        
        self.text.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: style.phraseEvaluateTextFont, NSAttributedStringKey.foregroundColor: style.phraseEvaluateTextColor])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.editButton.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        self.editButtonCover.cornerRadius = 25.0
        
        let edit = ASBackgroundLayoutSpec(child: self.editButton, background: self.editButtonCover)
        
        self.text.style.flexShrink = 1.0
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.alignItems = .center
        cell.justifyContent = .spaceBetween
        cell.spacing = 10.0
        cell.children = [self.text, edit]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 50.0, bottom: 10.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
