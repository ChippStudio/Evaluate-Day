//
//  CollectionActionButtonNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 30/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CollectionActionButtonNode: ASCellNode {
    
    // MARK: - UI
    var text = ASTextNode()
    var cover = ASDisplayNode()
    var button = ASButtonNode()
    
    // MARK: - Init
    override init() {
        super.init()
        
        self.text.attributedText = NSAttributedString(string: Localizations.collection.addNew, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.tint])
        self.cover.backgroundColor = UIColor.main
        self.cover.cornerRadius = 25.0
        self.button.addTarget(self, action: #selector(self.buttonInitialAction(sender:)), forControlEvents: .touchDown)
        self.button.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.button.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchUpInside)
        self.button.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let textInsets = UIEdgeInsets(top: 15.0, left: 50.0, bottom: 15.0, right: 50.0)
        let textInset = ASInsetLayoutSpec(insets: textInsets, child: self.text)
        
        let buttonCover = ASBackgroundLayoutSpec(child: textInset, background: self.cover)
        let buttonFull = ASOverlayLayoutSpec(child: buttonCover, overlay: self.button)
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.justifyContent = .center
        cell.children = [buttonFull]
        
        let cellInsets = UIEdgeInsets(top: 70.0, left: 0.0, bottom: 0.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func buttonInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func buttonEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.main
        }
    }
}
