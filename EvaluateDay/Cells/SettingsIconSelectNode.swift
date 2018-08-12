//
//  SettingsIconSelectNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/08/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol SettingsIconSelectNodeStyle {
    var settingsIconSelectNodeSelectedColor: UIColor { get }
}

class SettingsIconSelectNode: ASCellNode {
    // MARK: - UI
    var iconImage = ASImageNode()
    var iconImageNodeCover = ASDisplayNode()
    var selectedNode = ASDisplayNode()
    
    // MARK: - Init
    init(icon: UIImage?, selected: Bool, style: SettingsIconSelectNodeStyle) {
        super.init()
        
        self.iconImage.image = icon
        self.iconImage.clipsToBounds = true
        self.iconImage.cornerRadius = 10.0
        
        self.iconImageNodeCover.backgroundColor = UIColor.lightGray
        self.iconImageNodeCover.shadowColor = UIColor.lightGray.cgColor
        self.iconImageNodeCover.cornerRadius = 10.0
        self.iconImageNodeCover.shadowRadius = 6.0
        self.iconImageNodeCover.shadowOpacity = 0.5
        self.iconImageNodeCover.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        if selected {
            self.selectedNode.backgroundColor = style.settingsIconSelectNodeSelectedColor
        } else {
            self.selectedNode.backgroundColor = UIColor.clear
        }
        
        self.selectedNode.cornerRadius = 10.0
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let fullIcon = ASOverlayLayoutSpec(child: self.iconImageNodeCover, overlay: self.iconImage)
        
        let insetsIcon: CGFloat = 15.0
        let iconInsets = UIEdgeInsets(top: insetsIcon, left: insetsIcon, bottom: insetsIcon, right: insetsIcon)
        let iconInset = ASInsetLayoutSpec(insets: iconInsets, child: fullIcon)
        
        let cell = ASBackgroundLayoutSpec(child: iconInset, background: self.selectedNode)
        
        let insets: CGFloat = 12.0
        let cellInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
