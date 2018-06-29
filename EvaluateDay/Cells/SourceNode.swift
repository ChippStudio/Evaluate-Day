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
        
        let textStack = ASStackLayoutSpec.vertical()
        textStack.children = [self.title, self.subtitle]
        textStack.style.flexShrink = 1.0
        
        self.imageNode.style.preferredSize = CGSize(width: 40.0, height: 40.0)
        let cellStack = ASStackLayoutSpec.horizontal()
        cellStack.spacing = 10.0
        cellStack.children = [self.imageNode, textStack]
        cellStack.style.flexShrink = 1.0
        
        let fullCellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let fullCellInset = ASInsetLayoutSpec(insets: fullCellInsets, child: cellStack)
        
        return fullCellInset
    }
    
}
