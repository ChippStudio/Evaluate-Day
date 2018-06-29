//
//  AnalyticsStatisticNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol AnalyticsStatisticNodeStyle {
    var statisticTitleColor: UIColor { get }
    var statisticTitleFont: UIFont { get }
    var statisticSeparatorColor: UIColor { get }
    var statisticDataTitleColor: UIColor { get }
    var statisticDataTitleFont: UIFont { get }
    var statisticDataColor: UIColor { get }
    var statisticDataFont: UIFont { get }
}

class AnalyticsStatisticNode: ASCellNode {
    // MARK: - UI
    var titleNode = ASTextNode()
    var stats = [(title: ASTextNode, data: ASTextNode, separator: ASDisplayNode)]()
    
    // MARK: - Variables
    var topInset: CGFloat = 0.0
    var leftOffset: CGFloat = 50.0
    
    // MARK: - Init
    init(title: String, data: [(title: String, data: String)], style: AnalyticsStatisticNodeStyle) {
        super.init()
        self.titleNode.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.foregroundColor: style.statisticTitleColor, NSAttributedStringKey.font: style.statisticTitleFont])
        
        for d in data {
            let dataTitleNode = ASTextNode()
            dataTitleNode.attributedText = NSAttributedString(string: d.title, attributes: [NSAttributedStringKey.font: style.statisticDataTitleFont, NSAttributedStringKey.foregroundColor: style.statisticDataTitleColor])
            
            let dataNode = ASTextNode()
            dataNode.attributedText = NSAttributedString(string: d.data, attributes: [NSAttributedStringKey.font: style.statisticDataFont, NSAttributedStringKey.foregroundColor: style.statisticDataColor])
            
            let separatorNode = ASDisplayNode()
            separatorNode.backgroundColor = style.statisticSeparatorColor
            
            self.stats.append((title: dataTitleNode, data: dataNode, separator: separatorNode))
        }
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        var statsStaks = [ASLayoutSpec]()
        for s in self.stats {
            s.separator.style.preferredSize.width = 0.5
            
            s.title.style.flexShrink = 1.0
            s.data.style.flexShrink = 1.0
            
            let dataStack = ASStackLayoutSpec.horizontal()
            dataStack.spacing = 10.0
            dataStack.style.flexShrink = 1.0
            dataStack.children = [s.title, s.data, s.separator]
            
            let cellStackInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
            let cellStackInset = ASInsetLayoutSpec(insets: cellStackInsets, child: dataStack)
            cellStackInset.style.flexShrink = 1.0
            
            statsStaks.append(cellStackInset)
        }
        
        let dots = ASStackLayoutSpec.horizontal()
        dots.spacing = 10.0
        dots.style.flexShrink = 1.0
        dots.flexWrap = ASStackLayoutFlexWrap.wrap
        dots.children = statsStaks
        
        let fullCell = ASStackLayoutSpec.vertical()
        fullCell.children = [self.titleNode, dots]
        
        let fullCellInsets = UIEdgeInsets(top: self.topInset, left: leftOffset, bottom: 0.0, right: 10.0)
        let fullCellInset = ASInsetLayoutSpec(insets: fullCellInsets, child: fullCell)
        
        return fullCellInset
    }
}
