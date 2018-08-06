//
//  SourceNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol SourceNodeStyle {
    var sourceTitleColor: UIColor { get }
    var sourceSubtitleColor: UIColor { get }
    var sourceTitleFont: UIFont { get }
    var sourceSubtitleFont: UIFont { get }
    var sourceUntouchableColor: UIColor { get }
}

class SourceNode: ASCellNode {
    
    // MARK: - UI
    var imageNode = ASImageNode()
    var title = ASTextNode()
    var subtitle = ASTextNode()
    
    // MARK: - Init
    init(title: String, subtitle: String, image: UIImage, untouchble: Bool, style: SourceNodeStyle) {
        super.init()
        
        var sourceTitleColor = style.sourceTitleColor
        var sourceSubtitleColor = style.sourceSubtitleColor
        
        if untouchble {
            self.selectionStyle = .none
            sourceSubtitleColor = style.sourceUntouchableColor
            sourceTitleColor = style.sourceUntouchableColor
        }
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: style.sourceTitleFont, NSAttributedStringKey.foregroundColor: sourceTitleColor])
        self.subtitle.attributedText = NSAttributedString(string: subtitle, attributes: [NSAttributedStringKey.font: style.sourceSubtitleFont, NSAttributedStringKey.foregroundColor: sourceSubtitleColor])
        self.imageNode.image = image
        self.imageNode.contentMode = .scaleAspectFit
        
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let titleStack = ASStackLayoutSpec.horizontal()
        titleStack.spacing = -10
        titleStack.alignItems = .center
        titleStack.style.flexShrink = 1.0
        titleStack.children = [self.imageNode, self.title]
        
        self.imageNode.style.preferredSize = CGSize(width: 60.0, height: 60.0)
        
        let subtitleInsets = UIEdgeInsets(top: -15.0, left: 40.0, bottom: 20.0, right: 10.0)
        let subtitleInset = ASInsetLayoutSpec(insets: subtitleInsets, child: self.subtitle)
        
        let cellStack = ASStackLayoutSpec.vertical()
        cellStack.children = [titleStack, subtitleInset]
        cellStack.style.flexShrink = 1.0
        
        let fullCellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let fullCellInset = ASInsetLayoutSpec(insets: fullCellInsets, child: cellStack)
        
        return fullCellInset
    }
    
}
