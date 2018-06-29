//
//  WeatherNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 02/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol WeatherNodeStyle {
    var weatherNodeTintColor: UIColor { get }
    var weatherNodeDataTextFont: UIFont { get }
    var weatherNodeTextFont: UIFont { get }
    var weatherNodeTextColor: UIColor { get }
}

class WeatherNode: ASCellNode {
    // MARK: - UI
    var iconImage = ASImageNode()
    var textNode = ASTextNode()
    
    // MARK: - Init
    init(icon: UIImage?, text: String, data: [String], style: WeatherNodeStyle) {
        super.init()
        
        self.iconImage.image = icon
        self.iconImage.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.weatherNodeTintColor)
        self.iconImage.contentMode = .scaleAspectFit
        
        let textString = NSMutableAttributedString(string: text, attributes: [NSAttributedStringKey.font: style.weatherNodeTextFont, NSAttributedStringKey.foregroundColor: style.weatherNodeTextColor])
        
        for d in data {
            textString.addAttributes([NSAttributedStringKey.font: style.weatherNodeDataTextFont], range: (textString.string as NSString).range(of: d))
        }
        
        self.textNode.attributedText = textString
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.iconImage.style.preferredSize = CGSize(width: 30.0, height: 30.0)
        self.textNode.style.flexShrink = 1.0
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 10.0
        cell.children = [self.iconImage, self.textNode]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
