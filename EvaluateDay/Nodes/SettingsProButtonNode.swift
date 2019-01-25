//
//  ProButtonCellNode.swift
//  Rency
//
//  Created by Konstantin Tsistjakov on 19/07/2017.
//  Copyright © 2017 Chipp Studio. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class SettingsProButtonNode: ASCellNode {
    
    // MARK: - UI
    var textNode = ASTextNode()
    var cover = ASDisplayNode()
    
    // MARK: - Handler
    var didPressed: (() -> Void)?
    
    // MARK: - Variable
    var topInset: CGFloat = 5.0
    
    // MARK: - Initi
    init(title: String) {
        super.init()
    
        cover.cornerRadius = 5
        cover.backgroundColor = UIColor.main
        textNode.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.textTint])
    
        //Accessibility
        self.isAccessibilityElement = true
        self.accessibilityLabel = title
        self.accessibilityTraits = UIAccessibilityTraitButton
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let center = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: [], child: textNode)
        let centerInsets = UIEdgeInsets(top: 12.0, left: 0.0, bottom: 12.0, right: 0.0)
        let centerInset = ASInsetLayoutSpec(insets: centerInsets, child: center)
        let background = ASBackgroundLayoutSpec(child: centerInset, background: cover)
        let cellInsets = UIEdgeInsets(top: self.topInset, left: 10.0, bottom: 5.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: background)
        return cellInset
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {
            self.cover.backgroundColor = UIColor.selected
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {
            self.cover.backgroundColor = UIColor.main
        }
        
        if let table = self.owningNode as? ASTableNode {
//            table.selectRow(at: self.indexPath, animated: true, scrollPosition: .none)
            if self.indexPath != nil {
                table.delegate?.tableNode!(table, didSelectRowAt: self.indexPath!)
            }
        } else if let collection = self.owningNode as? ASCollectionNode {
            if self.indexPath != nil {
                collection.delegate?.collectionNode!(collection, didSelectItemAt: indexPath!)
            }
        }
        
        self.didPressed?()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        UIView.animate(withDuration: 0.3) {
            self.cover.backgroundColor = UIColor.main
        }
    }
}
