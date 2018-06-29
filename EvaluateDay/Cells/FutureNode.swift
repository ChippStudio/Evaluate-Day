//
//  FutureNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 15/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol FutureNodeStyle {
    var presentFutureQuoteFont: UIFont { get }
    var presentFutureQuoteColor: UIColor { get }
    var presentFutureAuthorFont: UIFont { get }
    var presentFutureAuthorColor: UIColor { get }
    var presentFutureShareFont: UIFont { get }
    var presentFutureShareTintColor: UIColor { get }
    var presentFutureShareTintHighlightedColor: UIColor { get }
    var presentFutureShareBackgroundColor: UIColor { get }
}

class FutureNode: ASCellNode {
    // MARK: - UI
    var quote = ASTextNode()
    var author = ASTextNode()
    var shareCover = ASDisplayNode()
    var shareButton = ASButtonNode()
    
    // MARK: - Init
    init(style: FutureNodeStyle) {
        super.init()
        
        self.quote.attributedText = NSAttributedString(string: Localizations.calendar.empty.futureQuote.text, attributes: [NSAttributedStringKey.font: style.presentFutureQuoteFont, NSAttributedStringKey.foregroundColor: style.presentFutureQuoteColor])
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .right
        
        self.author.attributedText = NSAttributedString(string: Localizations.calendar.empty.futureQuote.author, attributes: [NSAttributedStringKey.font: style.presentFutureAuthorFont, NSAttributedStringKey.foregroundColor: style.presentFutureAuthorColor, NSAttributedStringKey.paragraphStyle: paragraph])
        
        self.shareButton.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        self.shareButton.setAttributedTitle(NSAttributedString(string: Localizations.calendar.empty.share, attributes: [NSAttributedStringKey.font: style.presentFutureShareFont, NSAttributedStringKey.foregroundColor: style.presentFutureShareTintColor]), for: .normal)
        self.shareButton.setAttributedTitle(NSAttributedString(string: Localizations.calendar.empty.share, attributes: [NSAttributedStringKey.font: style.presentFutureShareFont, NSAttributedStringKey.foregroundColor: style.presentFutureShareTintHighlightedColor]), for: .highlighted)
        
        self.shareButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.presentFutureShareTintColor)
        
        self.shareCover.backgroundColor = style.presentFutureShareBackgroundColor
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let text = ASStackLayoutSpec.vertical()
        text.spacing = 10.0
        text.children = [self.quote, self.author]
        
        let buttonInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        let buttonInset = ASInsetLayoutSpec(insets: buttonInsets, child: self.shareButton)
        
        let button = ASBackgroundLayoutSpec(child: buttonInset, background: self.shareCover)
        
        let fullButton = ASStackLayoutSpec.vertical()
        fullButton.alignItems = .center
        fullButton.children = [button]
        
        self.shareCover.cornerRadius = 10.0
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 40.0
        cell.children = [text, fullButton]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
