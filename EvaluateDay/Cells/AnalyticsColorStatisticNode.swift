//
//  AnalyticsColorStatisticNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol AnalyticsColorStatisticNodeStyle {
    var statisticTitleColor: UIColor { get }
    var statisticTitleFont: UIFont { get }
    var statisticSeparatorColor: UIColor { get }
    var statisticDataColor: UIColor { get }
    var statisticDataFont: UIFont { get }
}

class AnalyticsColorStatisticNode: ASCellNode {
    
    // MARK: - UI
    var titleNode: ASTextNode = ASTextNode()
    var stats = [(dot: ASDisplayNode, title: ASTextNode, separator: ASDisplayNode)]()
    
    // MARK: - Variables
    var topInset: CGFloat = 0.0
    
    // MARK: - Init
    init(data: [(color: String, data: String)], style: AnalyticsColorStatisticNodeStyle) {
        super.init()
        
        self.titleNode.attributedText = NSAttributedString(string: Localizations.analytics.statistics.color.title, attributes: [NSAttributedStringKey.foregroundColor: style.statisticTitleColor, NSAttributedStringKey.font: style.statisticTitleFont])
        
        for d in data {
            let dotNode = ASDisplayNode()
            dotNode.backgroundColor = d.color.color
            if d.color == "FFFFFF" {
                dotNode.borderColor = UIColor.black.cgColor
                dotNode.borderWidth = 0.5
            }
            
            let dataTitleNode = ASTextNode()
            dataTitleNode.attributedText = NSAttributedString(string: d.data, attributes: [NSAttributedStringKey.font: style.statisticDataFont, NSAttributedStringKey.foregroundColor: style.statisticDataColor])
            
            let separatorNode = ASDisplayNode()
            separatorNode.backgroundColor = style.statisticSeparatorColor
            
            self.stats.append((dot: dotNode, title: dataTitleNode, separator: separatorNode))
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        var statsStaks = [ASLayoutSpec]()
        for s in self.stats {
            s.dot.style.preferredSize = CGSize(width: 20.0, height: 20.0)
            s.dot.cornerRadius = 20.0/2
            s.separator.style.preferredSize.width = 0.5
            
            let dataStack = ASStackLayoutSpec.horizontal()
            dataStack.spacing = 10.0
            dataStack.children = [s.dot, s.title, s.separator]
            
            let cellStackInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 0.0, right: 0.0)
            let cellStackInset = ASInsetLayoutSpec(insets: cellStackInsets, child: dataStack)
            
            statsStaks.append(cellStackInset)
        }
        
        let dots = ASStackLayoutSpec.horizontal()
        dots.spacing = 10.0
        dots.flexWrap = ASStackLayoutFlexWrap.wrap
        dots.children = statsStaks
        
        let fullCell = ASStackLayoutSpec.vertical()
        fullCell.children = [self.titleNode, dots]
        
        let fullCellInsets = UIEdgeInsets(top: self.topInset, left: 50.0, bottom: 0.0, right: 10.0)
        let fullCellInset = ASInsetLayoutSpec(insets: fullCellInsets, child: fullCell)
        
        return fullCellInset
    }
}
