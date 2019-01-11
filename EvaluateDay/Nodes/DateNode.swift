//
//  DateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 02/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class DateNode: ASCellNode {
    // MARK: - UI
    var dateNode = ASTextNode()
    var cover = ASDisplayNode()
    
    // MARK: - Init
    init(date: Date) {
        super.init()
        
        self.cover.backgroundColor = UIColor.main
        self.cover.cornerRadius = 10.0
        
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .full, timeStyle: .medium)
        self.dateNode.attributedText = NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedStringKey.foregroundColor: UIColor.tint])
        
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraitButton
        self.accessibilityLabel = dateString
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.dateNode.style.flexShrink = 1.0
        
        let content = ASStackLayoutSpec.vertical()
        content.spacing = 30.0
        content.children = [self.dateNode]
        
        let contentInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
