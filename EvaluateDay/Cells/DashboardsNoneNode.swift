//
//  DashboardsNoneNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 06/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol DashboardsNoneNodeStyle {
    var dashboardsNoneNodeTitleFont: UIFont { get }
    var dashboardsNoneNodeTitleColor: UIColor { get }
    var dashboardsNoneNodeSubtitleFont: UIFont { get }
    var dashboardsNoneNodeSubtitleColor: UIColor { get }
    var dashboardsNoneNodeTintColor: UIColor { get }
}

class DashboardsNoneNode: ASCellNode {
    
    // MARK: - UI
    var imageView = ASImageNode()
    var title = ASTextNode()
    var subtitle = ASTextNode()

    // MARK: - Init
    init(style: DashboardsNoneNodeStyle) {
        super.init()
        
        self.imageView.image = #imageLiteral(resourceName: "speedometer")
        self.imageView.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.dashboardsNoneNodeTintColor)
        
        self.title.attributedText = NSAttributedString(string: Localizations.dashboard.title, attributes: [NSAttributedStringKey.font: style.dashboardsNoneNodeTitleFont, NSAttributedStringKey.foregroundColor: style.dashboardsNoneNodeTitleColor])
        
        self.subtitle.attributedText = NSAttributedString(string: Localizations.dashboard.addNew, attributes: [NSAttributedStringKey.font: style.dashboardsNoneNodeSubtitleFont, NSAttributedStringKey.foregroundColor: style.dashboardsNoneNodeSubtitleColor])
        
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.imageView.style.preferredSize = CGSize(width: 45.0, height: 45.0)
        
        let subtitleInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
        let subtitleInset = ASInsetLayoutSpec(insets: subtitleInsets, child: self.subtitle)
        
        let text = ASStackLayoutSpec.vertical()
        text.children = [self.title, subtitleInset]
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.alignItems = .center
        cell.spacing = 20.0
        cell.children = [self.imageView, text]
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 40.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
