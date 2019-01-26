//
//  WeatherNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 02/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class WeatherNode: ASCellNode {
    // MARK: - UI
    var iconImage = ASImageNode()
    var textNode = ASTextNode()
    
    var cover = ASDisplayNode()
    
    // MARK: - Init
    init(icon: UIImage?, text: String, data: [String]) {
        super.init()
        
        self.cover.backgroundColor = UIColor.main
        self.cover.cornerRadius = 10.0
        
        self.iconImage.image = icon
        self.iconImage.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.textTint)
        self.iconImage.contentMode = .scaleAspectFit
        
        let textString = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.textTint])
        
        for d in data {
            textString.addAttributes([NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0, weight: .bold)], range: (textString.string as NSString).range(of: d))
        }
        
        self.textNode.attributedText = textString
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.iconImage.style.preferredSize = CGSize(width: 30.0, height: 30.0)
        self.textNode.style.flexShrink = 1.0
        
        let content = ASStackLayoutSpec.horizontal()
        content.spacing = 10.0
        content.alignItems = .center
        content.children = [self.iconImage, self.textNode]
        
        let contentInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
