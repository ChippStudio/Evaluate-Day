//
//  DateShowNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 30/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class DateShowNode: ASCellNode {
    
    // MARK: - UI
    var dateView = ASTextNode()
    
    // MARK: - Variable
    var date: Date! {
        didSet {
            let dateString = DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
            self.dateView.attributedText = NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1), NSAttributedString.Key.foregroundColor: UIColor.text])
        }
    }
    
    // MARK: - Init
    init(date: Date) {
        super.init()
        
        let dateString = DateFormatter.localizedString(from: date, dateStyle: .long, timeStyle: .none)
        self.dateView.attributedText = NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title1), NSAttributedString.Key.foregroundColor: UIColor.text])
        
        self.automaticallyManagesSubnodes = true
        
        self.date = date
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let cell = ASStackLayoutSpec.horizontal()
        cell.justifyContent = .end
        cell.children = [self.dateView]
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
