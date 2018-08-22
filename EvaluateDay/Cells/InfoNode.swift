//
//  InfoNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 05/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol InfoNodeStyle {
    var infoNodeTintColor: UIColor { get }
    var infoNodeTitleFont: UIFont { get }
}

class InfoNode: ASCellNode {
    
    // MARK: - UI
    var title = ASTextNode()
    var infoButton = ASButtonNode()
    
    // MARK: - Variables
    var topInset: CGFloat = 5.0
    var infoSelected: (() -> Void)?
    
    // MARK: - Init
    init(title: String, style: InfoNodeStyle) {
        super.init()
        
        self.selectionStyle = .none
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.foregroundColor: style.infoNodeTintColor, NSAttributedStringKey.font: style.infoNodeTitleFont, NSAttributedStringKey.paragraphStyle: paragraph])
        
        self.title.isAccessibilityElement = false
        
        self.infoButton.setImage(#imageLiteral(resourceName: "info").withRenderingMode(.alwaysTemplate), for: .normal)
        self.infoButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.infoNodeTintColor)
        self.infoButton.imageNode.contentMode = .scaleAspectFit
        self.infoButton.addTarget(self, action: #selector(infoButtonAction(sender:)), forControlEvents: .touchUpInside)
        
        self.infoButton.accessibilityLabel = title + "info"
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.infoButton.style.preferredSize = CGSize(width: 20.0, height: 20.0)
        self.title.style.flexGrow = 1.0
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 10.0
        cell.justifyContent = .end
        cell.alignContent = .stretch
        cell.children = [self.title, self.infoButton]
        
        let cellInsets = UIEdgeInsets(top: self.topInset, left: 10.0, bottom: 0.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func infoButtonAction(sender: ASButtonNode) {
        self.infoSelected?()
    }
}
