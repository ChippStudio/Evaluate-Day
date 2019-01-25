//
//  EvaluateEmptyCardNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 15/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class EvaluateEmptyCardNode: ASCellNode {
    // MARK: - UI
    var imageNode = ASImageNode()
    var titleNode = ASTextNode()
    var subtitleNode = ASTextNode()
    
    var newCardButton = ASButtonNode()
    var newCardButtonCover = ASDisplayNode()
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage) {
        super.init()
        
        self.imageNode.image = image.resizedImage(newSize: CGSize(width: 60.0, height: 60.0))
        self.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        self.titleNode.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .title1), NSAttributedStringKey.paragraphStyle: paragraph, NSAttributedStringKey.foregroundColor: UIColor.main])
        self.subtitleNode.attributedText = NSAttributedString(string: subtitle, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.paragraphStyle: paragraph, NSAttributedStringKey.foregroundColor: UIColor.main])
        
        self.newCardButton.setAttributedTitle(NSAttributedString(string: Localizations.General.Shortcut.New.title, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.textTint]), for: .normal)
        self.newCardButtonCover.backgroundColor = UIColor.main
        self.newCardButtonCover.cornerRadius = 10.0
        
        self.newCardButton.addTarget(self, action: #selector(self.newInitialAction(sender:)), forControlEvents: .touchDown)
        self.newCardButton.addTarget(self, action: #selector(self.newEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.newCardButton.addTarget(self, action: #selector(self.newEndAction(sender:)), forControlEvents: .touchUpInside)
        self.newCardButton.addTarget(self, action: #selector(self.newEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.imageNode.style.preferredSize = CGSize(width: 60.0, height: 60.0)
        
        let buttonInsets = UIEdgeInsets(top: 9.0, left: 30.0, bottom: 9.0, right: 30.0)
        let buttonInset = ASInsetLayoutSpec(insets: buttonInsets, child: self.newCardButton)
        
        let button = ASBackgroundLayoutSpec(child: buttonInset, background: self.newCardButtonCover)
        
        self.subtitleNode.style.flexShrink = 1.0
        self.titleNode.style.flexShrink = 1.0
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 20.0
        cell.style.flexShrink = 1.0
        cell.alignItems = .center
        cell.children = [self.imageNode, self.titleNode, self.subtitleNode, button]
        
        let cellInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func newInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.newCardButtonCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func newEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.newCardButtonCover.backgroundColor = UIColor.main
        }
    }
}
