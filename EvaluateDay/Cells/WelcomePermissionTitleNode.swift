//
//  WelcomePermissionTitleNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class WelcomePermissionTitleNode: ASCellNode {
    // MARK: - UI
    var title = ASTextNode()
    var subtitle = ASTextNode()
    
    // MARK: - Init
    override init() {
        super.init()
        
        let center = NSMutableParagraphStyle()
        center.alignment = .left
        
        self.title.attributedText = NSAttributedString(string: Localizations.permission.description.title, attributes: [NSAttributedStringKey.font: UIFont.avenirNext(size: 40.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.gunmetal, NSAttributedStringKey.paragraphStyle: center])
        self.subtitle.attributedText = NSAttributedString(string: Localizations.permission.description.subtitle, attributes: [NSAttributedStringKey.font: UIFont.avenirNext(size: 16.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.lightGray, NSAttributedStringKey.paragraphStyle: center])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let cell = ASStackLayoutSpec.vertical()
        cell.children = [self.title, self.subtitle]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }

}
