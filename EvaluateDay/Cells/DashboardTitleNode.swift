//
//  DashboardTitleNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 04/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol DashboardTitleNodeStyle {
    var dashbordTitleNodeTitleFont: UIFont { get }
    var dashbordTitleNodeTitleColor: UIColor { get }
    var dashbordTitleNodeButtonColor: UIColor { get }
    var dashbordTitleNodeButtonTint: UIColor { get }
}

class DashboardTitleNode: ASCellNode, UITextFieldDelegate {
    // MARK: - UI
    var buttonCover = ASDisplayNode()
    var button = ASButtonNode()
    var textFieldNode: ASDisplayNode!
    var textField: UITextField!
    
    // MARK: - Variable
    var textFieldDidLoad: (() -> Void)?
    
    // MARK: - Init
    init(style: DashboardTitleNodeStyle) {
        super.init()
        
        self.buttonCover.backgroundColor = style.dashbordTitleNodeButtonColor
        self.button.setImage(#imageLiteral(resourceName: "disclosure").withRenderingMode(.alwaysTemplate), for: .normal)
        self.button.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.dashbordTitleNodeButtonTint)
        
        self.textFieldNode = ASDisplayNode(viewBlock: { () -> UIView in
            self.textField = UITextField()
            self.textField.textColor = style.dashbordTitleNodeTitleColor
            self.textField.font = style.dashbordTitleNodeTitleFont
            self.textField.placeholder = Localizations.dashboard.titlePlaceholder
            
            self.textField.returnKeyType = .done
            self.textField.autocapitalizationType = .words
            self.textField.delegate = self
            return self.textField
        }, didLoad: { (_) in
            self.textFieldDidLoad?()
        })
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        print(constrainedSize.max.width)
        if constrainedSize.max.width > 50.0 {
            self.textFieldNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 60.0, height: 50.0)
        } else {
            self.textFieldNode.style.preferredSize = CGSize(width: 250.0, height: 50.0)
        }
        self.button.style.preferredSize.width = 50.0
        
        let buttonStack = ASBackgroundLayoutSpec(child: self.button, background: self.buttonCover)
        let cell = ASStackLayoutSpec.horizontal()
        cell.children = [self.textFieldNode, buttonStack]
        
        let cellInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.button.sendActions(forControlEvents: .touchUpInside, with: nil)
        return true
    }
}
