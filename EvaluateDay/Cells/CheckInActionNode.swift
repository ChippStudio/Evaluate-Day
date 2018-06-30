//
//  CheckInActionNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 13/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol CheckInActionNodeStyle {
    var checkInActionMapButtonFont: UIFont { get }
    var checkInActionMapButtonColor: UIColor { get }
    var checkInActionMapButtonHighlightColor: UIColor { get }
    var checkInActionCheckInButtonFont: UIFont { get }
    var checkInActionCheckInButtonColor: UIColor { get }
    var checkInActionCheckInButtonHighlightColor: UIColor { get }
    var checkInActionSeparatorColor: UIColor { get }
}

class CheckInActionNode: ASCellNode {
    // MARK: - UI
    var mapButton = ASButtonNode()
    var checkInButton = ASButtonNode()
    var separatorNode = ASDisplayNode()
    
    // MARK: - Init
    init(style: CheckInActionNodeStyle) {
        super.init()
        
        let checkInTitleString = NSAttributedString(string: Localizations.evaluate.checkin.quickCheckin, attributes: [NSAttributedStringKey.font: style.checkInActionCheckInButtonFont, NSAttributedStringKey.foregroundColor: style.checkInActionCheckInButtonColor])
        let checkInTitleHighligtedString = NSAttributedString(string: Localizations.evaluate.checkin.quickCheckin, attributes: [NSAttributedStringKey.font: style.checkInActionCheckInButtonFont, NSAttributedStringKey.foregroundColor: style.checkInActionCheckInButtonHighlightColor])
        
        let mapTitleString = NSAttributedString(string: Localizations.evaluate.checkin.showMap, attributes: [NSAttributedStringKey.font: style.checkInActionMapButtonFont, NSAttributedStringKey.foregroundColor: style.checkInActionMapButtonColor])
        let mapTitleHighligtedString = NSAttributedString(string: Localizations.evaluate.checkin.showMap, attributes: [NSAttributedStringKey.font: style.checkInActionMapButtonFont, NSAttributedStringKey.foregroundColor: style.checkInActionMapButtonHighlightColor])
        
        self.checkInButton.setAttributedTitle(checkInTitleString, for: .normal)
        self.checkInButton.setAttributedTitle(checkInTitleHighligtedString, for: .highlighted)
        
        self.mapButton.setAttributedTitle(mapTitleString, for: .normal)
        self.mapButton.setAttributedTitle(mapTitleHighligtedString, for: .highlighted)
        
        self.separatorNode.backgroundColor = style.checkInActionSeparatorColor
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        self.separatorNode.style.preferredSize.width = 1.0
        
        let separatorInsets = UIEdgeInsets(top: -10.0, left: 0.0, bottom: -10.0, right: 0.0)
        let separatorInset = ASInsetLayoutSpec(insets: separatorInsets, child: self.separatorNode)
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.justifyContent = .spaceAround
        cell.children = [self.checkInButton, separatorInset, self.mapButton]
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 50.0, bottom: 20.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}