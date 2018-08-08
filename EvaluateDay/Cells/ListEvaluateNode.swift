//
//  ListEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol ListEvaluateNodeStyle {
    var listEvaluateViewButtonFont: UIFont { get }
    var listEvaluateViewButtonColor: UIColor { get }
    var listEvaluateViewButtonHighlightedColor: UIColor { get }
    var listEvaluateDayDoneFont: UIFont { get }
    var listEvaluateDayDoneColor: UIColor { get }
    var listEvaluateAllDoneFont: UIFont { get }
    var listEvaluateAllDoneColor: UIColor { get }
    var listEvaluateDateFont: UIFont { get }
    var listEvaluateDateColor: UIColor { get }
    var listEvaluateSeparatorColor: UIColor { get }
}

class ListEvaluateNode: ASCellNode {
    
    // MARK: - UI
    var openListButton = ASButtonNode()
    var openListButtonCover = ASDisplayNode()
    var dayDone = ASTextNode()
    var allDone = ASTextNode()
    var currentDate = ASTextNode()
    var lifetime = ASTextNode()
    var separator = ASDisplayNode()
    
    // MARK: - Init
    init(all: Int, allDone: Int, inDay: Int, date: Date, style: ListEvaluateNodeStyle) {
        super.init()
        
        let openTitle = NSAttributedString(string: Localizations.evaluate.list.open, attributes: [NSAttributedStringKey.font: style.listEvaluateViewButtonFont, NSAttributedStringKey.foregroundColor: style.listEvaluateViewButtonColor])
        let openHighlightedTitle = NSAttributedString(string: Localizations.evaluate.list.open, attributes: [NSAttributedStringKey.font: style.listEvaluateViewButtonFont, NSAttributedStringKey.foregroundColor: style.listEvaluateViewButtonHighlightedColor])
        
        self.openListButton.setAttributedTitle(openTitle, for: .normal)
        self.openListButton.setAttributedTitle(openHighlightedTitle, for: .highlighted)
        
        self.openListButtonCover.cornerRadius = 5.0
        self.openListButtonCover.borderWidth = 1.0
        self.openListButtonCover.borderColor = style.listEvaluateViewButtonColor.cgColor
        
        let allPercent = Double(allDone) / Double(all) * 100.0
        let dayPercent = Double(inDay) / Double(all) * 100.0
        
        let dayString = "\(inDay) / \(all) \n \(String(format: "%.0f", dayPercent)) %"
        let allString = "\(allDone) / \(all) \n \(String(format: "%.0f", allPercent)) %"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        self.dayDone.attributedText = NSAttributedString(string: dayString, attributes: [NSAttributedStringKey.font: style.listEvaluateDayDoneFont, NSAttributedStringKey.foregroundColor: style.listEvaluateDayDoneColor, NSAttributedStringKey.paragraphStyle: paragraph])
        self.allDone.attributedText = NSAttributedString(string: allString, attributes: [NSAttributedStringKey.font: style.listEvaluateAllDoneFont, NSAttributedStringKey.foregroundColor: style.listEvaluateAllDoneColor, NSAttributedStringKey.paragraphStyle: paragraph])
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.currentDate.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: style.listEvaluateDateFont, NSAttributedStringKey.foregroundColor: style.listEvaluateDateColor])
        self.lifetime.attributedText = NSAttributedString(string: Localizations.general.lifetime, attributes: [NSAttributedStringKey.font: style.listEvaluateDateFont, NSAttributedStringKey.foregroundColor: style.listEvaluateDateColor])
        
        self.separator.backgroundColor = style.listEvaluateSeparatorColor
        self.separator.cornerRadius = 2.0
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let currentStack = ASStackLayoutSpec.vertical()
        currentStack.spacing = 5.0
        currentStack.alignItems = .end
        currentStack.children = [self.dayDone, self.currentDate]
        
        let lifetimeStack = ASStackLayoutSpec.vertical()
        lifetimeStack.alignItems = .end
        lifetimeStack.spacing = 5.0
        lifetimeStack.children = [self.allDone, self.lifetime]
        
        self.separator.style.preferredSize = CGSize(width: 4.0, height: 100.0)
        
        let texts = ASStackLayoutSpec.horizontal()
        texts.spacing = 20.0
        texts.flexWrap = .wrap
        texts.alignItems = .end
        texts.children = [currentStack, self.separator, lifetimeStack]
        
        let openButtonInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        let openButtonInset = ASInsetLayoutSpec(insets: openButtonInsets, child: self.openListButton)
        
        let button = ASBackgroundLayoutSpec(child: openButtonInset, background: self.openListButtonCover)
        
        let textsInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 10.0)
        let textsInset = ASInsetLayoutSpec(insets: textsInsets, child: texts)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 20.0
        cell.children = [textsInset, button]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 30.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
