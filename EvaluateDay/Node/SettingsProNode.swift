//
//  SettingsProNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 11/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class SettingsProNode: ASCellNode {

    // MARK: - UI
    var mainView: ASDisplayNode!
    var proView: ProView!
    
    // MARK: - Variables
    var didLoadProView: ((_ view: ProView) -> Void)?
    
    // MARK: - Init
    override init() {
        super.init()
        
        self.mainView = ASDisplayNode(viewBlock: { () -> UIView in
            self.proView = ProView()
            return self.proView
        }, didLoad: { (_) in
            self.didLoadProView?(self.proView)
        })
        
        //Accessibility
        self.isAccessibilityElement = true
//        self.accessibilityLabel = "\(titleString), \(subtitleString)"
        self.accessibilityTraits = UIAccessibilityTraitButton
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    
        self.mainView.style.preferredSize = CGSize(width: constrainedSize.max.width - 40.0, height: 140.0)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.children = [self.mainView]
        
        let cellInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
