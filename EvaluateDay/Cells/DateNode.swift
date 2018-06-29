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
}

class DateNode: ASCellNode {
    // MARK: - UI
    var dateNode = ASTextNode()
    
    // MARK: - Init
    init(date: Date, style: DateNodeStyle) {
        super.init()
        
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .full, timeStyle: .medium)
        self.dateNode.attributedText = NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: style.dateNodeFont, NSAttributedStringKey.foregroundColor: style.dateFontColor])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.dateNode.style.flexShrink = 1.0
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 50.0, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: self.dateNode)
        
        return cellInset
    }
}
