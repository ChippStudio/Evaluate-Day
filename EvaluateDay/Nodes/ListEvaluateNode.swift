//
//  ListEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ListEvaluateNode: ASCellNode {
    
    // MARK: - UI
    var openListButton = ASButtonNode()
    var openListButtonCover = ASDisplayNode()
    var dayDone = ASTextNode()
    var allDone = ASTextNode()
    var currentDate = ASTextNode()
    var lifetime = ASTextNode()
    var separator = ASDisplayNode()
    
    private var accessibilityNode = ASDisplayNode()
    
    // MARK: - Init
    init(all: Int, allDone: Int, inDay: Int, date: Date) {
        super.init()
        
        let openTitle = NSAttributedString(string: Localizations.Evaluate.List.open, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.textTint])
        
        self.openListButton.setAttributedTitle(openTitle, for: .normal)
        
        self.openListButtonCover.cornerRadius = 10.0
        self.openListButtonCover.backgroundColor = UIColor.main
        
        let allPercent = Double(allDone) / Double(all) * 100.0
        let dayPercent = Double(inDay) / Double(all) * 100.0
        
        let dayString = "\(inDay) / \(all) \n \(String(format: "%.0f", dayPercent)) %"
        let allString = "\(allDone) / \(all) \n \(String(format: "%.0f", allPercent)) %"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        self.dayDone.attributedText = NSAttributedString(string: dayString, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30.0, weight: .medium), NSAttributedStringKey.foregroundColor: UIColor.text, NSAttributedStringKey.paragraphStyle: paragraph])
        self.allDone.attributedText = NSAttributedString(string: allString, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 30.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.text, NSAttributedStringKey.paragraphStyle: paragraph])
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.currentDate.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.text])
        self.lifetime.attributedText = NSAttributedString(string: Localizations.General.lifetime, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        self.separator.backgroundColor = UIColor.main
        self.separator.cornerRadius = 2.0
        
        // Accessibility
        self.dayDone.isAccessibilityElement = false
        self.allDone.isAccessibilityElement = false
        self.currentDate.isAccessibilityElement = false
        self.lifetime.isAccessibilityElement = false
        
        self.accessibilityNode.isAccessibilityElement = true
        self.accessibilityNode.accessibilityLabel = Localizations.Accessibility.Evaluate.List.allDone(formatter.string(from: date), "\(inDay)", "\(all)", "\(dayPercent)", "\(allDone)", "\(all)", "\(allPercent)")
        
        self.openListButton.addTarget(self, action: #selector(self.openInitialAction(sender:)), forControlEvents: .touchDown)
        self.openListButton.addTarget(self, action: #selector(self.openEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.openListButton.addTarget(self, action: #selector(self.openEndAction(sender:)), forControlEvents: .touchUpInside)
        self.openListButton.addTarget(self, action: #selector(self.openEndAction(sender:)), forControlEvents: .touchCancel)
        
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
        
        let openButtonInsets = UIEdgeInsets(top: 15.0, left: 0.0, bottom: 15.0, right: 0.0)
        let openButtonInset = ASInsetLayoutSpec(insets: openButtonInsets, child: self.openListButton)
        
        let button = ASBackgroundLayoutSpec(child: openButtonInset, background: self.openListButtonCover)
        
        let textsInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 10.0)
        let textsInset = ASInsetLayoutSpec(insets: textsInsets, child: texts)
        
        let textsInsetAccessibility = ASBackgroundLayoutSpec(child: textsInset, background: self.accessibilityNode)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 20.0
        cell.children = [textsInsetAccessibility, button]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func openInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.openListButtonCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func openEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.openListButtonCover.backgroundColor = UIColor.main
        }
    }
}
