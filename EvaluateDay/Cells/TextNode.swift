//
//  TextNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 03/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol TextNodeStyle {
    var textNodeFont: UIFont { get }
    var textNodeTextColor: UIColor { get }
    var textNodePlaceholderTextColor: UIColor { get }
}

class TextNode: ASCellNode {
    // MARK: - UI
    var textNode = ASEditableTextNode()
    
    // MARK: - Init
    init(text: String, placeholder: String, height: CGFloat, style: TextNodeStyle) {
        super.init()
        
        self.textNode.style.preferredSize.height = height
        
        // Text node
        self.textNode.textContainerInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 10.0, right: 20.0)
        OperationQueue.main.addOperation {
            self.textNode.textView.keyboardDismissMode = .interactive
            self.textNode.textView.alwaysBounceVertical = true
        }
        self.textNode.typingAttributes = [NSAttributedStringKey.font.rawValue: style.textNodeFont, NSAttributedStringKey.foregroundColor.rawValue: style.textNodeTextColor]
        self.textNode.attributedPlaceholderText = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.font: style.textNodeFont, NSAttributedStringKey.foregroundColor: style.textNodePlaceholderTextColor])
        self.textNode.attributedText = NSAttributedString(string: text, attributes: [NSAttributedStringKey.font: style.textNodeFont, NSAttributedStringKey.foregroundColor: style.textNodeTextColor])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: self.textNode)
        
        return cellInset
    }
}
