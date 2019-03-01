//
//  AnalyticsProReviewNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 30/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class AnalyticsProReviewNode: ASCellNode {
    
    // MARK: - UI
    var title = ASTextNode()
    var proNode: ASDisplayNode!
    var pro: ProView!
    
    // MARK: - Variables
    var didLoadProView: ((_ view: ProView) -> Void)?
    
    // MARK: - Init
    override init() {
        super.init()
        
        self.title.attributedText = NSAttributedString(string: Localizations.Settings.Pro.Review.Analytics.title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.main])
        
        self.proNode = ASDisplayNode(viewBlock: { () -> UIView in
            self.pro = ProView()
            return self.pro
        }, didLoad: { (_) in
            self.didLoadProView?(self.pro)
        })
        
        self.automaticallyManagesSubnodes = true
    }

    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let offset: CGFloat = 10.0
        
        self.proNode.style.preferredSize = CGSize(width: constrainedSize.max.width - offset * 2, height: 140.0)
        self.title.style.flexShrink = 1.0
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 10.0
        cell.children = [self.title, self.proNode]
        
        let cellInsets = UIEdgeInsets(top: 50.0, left: offset, bottom: 30.0, right: offset)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
