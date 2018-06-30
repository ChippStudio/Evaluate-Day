//
//  AnalyticsExportFileTypeNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 20/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class AnalyticsExportFileTypeNode: ASCellNode {

    // MARK: - UI
    var imageNode = ASImageNode()
    
    // MARK: - Variables
    var colorStyle: AnalyticsExportNodeStyle!
    
    // MARK: - Init
    init(type: ExportType, style: AnalyticsExportNodeStyle) {
        super.init()
        
        self.colorStyle = style
        
        switch type {
        case .csv:
            self.imageNode.image = #imageLiteral(resourceName: "csv")
        case .json:
            self.imageNode.image = #imageLiteral(resourceName: "json")
        case .txt:
            self.imageNode.image = #imageLiteral(resourceName: "txt")
        }
        
        self.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(self.colorStyle.analyticsExportTintColor)
        self.imageNode.contentMode = .scaleAspectFit
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.imageNode.style.preferredSize = CGSize(width: constrainedSize.max.height, height: constrainedSize.max.height)
        
        let imageInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        let imageInset = ASInsetLayoutSpec(insets: imageInsets, child: self.imageNode)
        
        return imageInset
    }
}