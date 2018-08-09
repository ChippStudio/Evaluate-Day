//
//  DateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 02/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol DateNodeStyle {
    var dateNodeFont: UIFont { get }
    var dateFontColor: UIColor { get }
    var dateNodeSeparatorColor: UIColor { get }
}

class DateNode: ASCellNode {
    // MARK: - UI
    var dateNode = ASTextNode()
    var separator = ASDisplayNode()
    
    // MARK: - Init
    init(date: Date, style: DateNodeStyle) {
        super.init()
        
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .full, timeStyle: .medium)
        self.dateNode.attributedText = NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: style.dateNodeFont, NSAttributedStringKey.foregroundColor: style.dateFontColor])
        
        self.separator.backgroundColor = style.dateNodeSeparatorColor
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.separator.style.preferredSize = CGSize(width: 200.0, height: 0.5)
        
        self.dateNode.style.flexShrink = 1.0
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 30.0
        cell.children = [self.dateNode, self.separator]
        
        let cellInsets = UIEdgeInsets(top: 30.0, left: 30.0, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
