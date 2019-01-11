//
//  CheckInActionNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 13/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CheckInActionNode: ASCellNode {
    // MARK: - UI
    var mapButton = ASButtonNode()
    var mapButtonCover = ASDisplayNode()
    
    var checkInButton = ASButtonNode()
    var checkInButtonCover = ASDisplayNode()
    
    var separatorNode = ASDisplayNode()
    var currentDate = ASTextNode()
    
    var cover = ASDisplayNode()
    
    // MARK: - Init
    init(date: Date) {
        super.init()
        
        self.cover.backgroundColor = UIColor.background
        self.cover.cornerRadius = 10.0
        
        self.mapButtonCover.backgroundColor = UIColor.tint
        self.mapButtonCover.cornerRadius = 20.0
        
        self.checkInButtonCover.backgroundColor = UIColor.tint
        self.checkInButtonCover.cornerRadius = 20.0
        
        let checkInTitleString = NSAttributedString(string: Localizations.Evaluate.Checkin.quickCheckin, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .title3), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        let mapTitleString = NSAttributedString(string: Localizations.Evaluate.Checkin.showMap, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .title3), NSAttributedStringKey.foregroundColor: UIColor.text])
        
        self.checkInButton.setAttributedTitle(checkInTitleString, for: .normal)
        
        self.mapButton.setAttributedTitle(mapTitleString, for: .normal)
        
        self.separatorNode.backgroundColor = UIColor.main
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.currentDate.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.text])
        self.currentDate.isAccessibilityElement = false
        
        // Buttons Action
        self.checkInButton.addTarget(self, action: #selector(self.checkInInitialAction(sender:)), forControlEvents: .touchDown)
        self.checkInButton.addTarget(self, action: #selector(self.checkInEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.checkInButton.addTarget(self, action: #selector(self.checkInEndAction(sender:)), forControlEvents: .touchUpInside)
        self.checkInButton.addTarget(self, action: #selector(self.checkInEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.mapButton.addTarget(self, action: #selector(self.mapInitialAction(sender:)), forControlEvents: .touchDown)
        self.mapButton.addTarget(self, action: #selector(self.mapEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.mapButton.addTarget(self, action: #selector(self.mapEndAction(sender:)), forControlEvents: .touchUpInside)
        self.mapButton.addTarget(self, action: #selector(self.mapEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.separatorNode.style.preferredSize = CGSize(width: 200.0, height: 1.0)
        
        let checkInButtonInsets = UIEdgeInsets(top: 8.0, left: 15.0, bottom: 8.0, right: 15.0)
        let checkInButtonInset = ASInsetLayoutSpec(insets: checkInButtonInsets, child: self.checkInButton)
        let fullCheckInButton = ASBackgroundLayoutSpec(child: checkInButtonInset, background: self.checkInButtonCover)
        
        let checkInStack = ASStackLayoutSpec.horizontal()
        checkInStack.children = [fullCheckInButton]
        
        let separatorStack = ASStackLayoutSpec.horizontal()
        separatorStack.justifyContent = .center
        separatorStack.children = [self.separatorNode]
        
        let mapButtonInsets = UIEdgeInsets(top: 8.0, left: 15.0, bottom: 8.0, right: 15.0)
        let mapButtonInset = ASInsetLayoutSpec(insets: mapButtonInsets, child: self.mapButton)
        let fullMapButton = ASBackgroundLayoutSpec(child: mapButtonInset, background: self.mapButtonCover)
        
        let mapButtonStack = ASStackLayoutSpec.horizontal()
        mapButtonStack.justifyContent = .end
        mapButtonStack.children = [fullMapButton]
        
        let buttons = ASStackLayoutSpec.vertical()
        buttons.spacing = 15.0
        buttons.children = [checkInStack, separatorStack, mapButtonStack]
        
        let content = ASStackLayoutSpec.vertical()
        content.spacing = 25.0
        content.children = [self.currentDate, buttons]
        
        let contentInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 20.0, right: 10.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func checkInInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.checkInButtonCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func checkInEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.checkInButtonCover.backgroundColor = UIColor.tint
        }
    }
    
    @objc func mapInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.mapButtonCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func mapEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.mapButtonCover.backgroundColor = UIColor.tint
        }
    }
}
