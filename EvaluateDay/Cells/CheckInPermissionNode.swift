//
//  CheckInPermissionNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 13/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol CheckInPermissionNodeStyle {
    var checkInPermissionDescriptionFont: UIFont { get }
    var checkInPermissionDescriptionColor: UIColor { get }
    var checkInPermissionButtonFont: UIFont { get }
    var checkInPermissionButtonColor: UIColor { get }
    var checkInPermissionButtonHighlightColor: UIColor { get }
    var checkInPermissionDateFont: UIFont { get }
    var checkInPermissionDateColor: UIColor { get }
}

class CheckInPermissionNode: ASCellNode {
    // MARK: - UI
    var descriptionNode = ASTextNode()
    var permissionButton = ASButtonNode()
    var permissionCover = ASDisplayNode()
    var mapButton = ASButtonNode()
    var mapButtonCover = ASDisplayNode()
    var currentDate = ASTextNode()
    
    // MARK: - Variable
    var leftInset: CGFloat = 10.0
    
    // MARK: - Init
    init(date: Date, style: CheckInPermissionNodeStyle) {
        super.init()
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        self.descriptionNode.attributedText = NSAttributedString(string: Localizations.evaluate.checkin.permission.description, attributes: [NSAttributedStringKey.font: style.checkInPermissionDescriptionFont, NSAttributedStringKey.foregroundColor: style.checkInPermissionDescriptionColor, NSAttributedStringKey.paragraphStyle: paragraph])
        
        let buttonTitleString = NSAttributedString(string: Localizations.evaluate.checkin.permission.buttonTitle, attributes: [NSAttributedStringKey.font: style.checkInPermissionButtonFont, NSAttributedStringKey.foregroundColor: style.checkInPermissionButtonColor])
        let buttonHighlightedTitleString = NSAttributedString(string: Localizations.evaluate.checkin.permission.buttonTitle, attributes: [NSAttributedStringKey.font: style.checkInPermissionButtonFont, NSAttributedStringKey.foregroundColor: style.checkInPermissionButtonHighlightColor])
        
        self.permissionButton.setAttributedTitle(buttonTitleString, for: .normal)
        self.permissionButton.setAttributedTitle(buttonHighlightedTitleString, for: .highlighted)
        
        self.permissionCover.cornerRadius = 5.0
        self.permissionCover.borderColor = style.checkInPermissionButtonColor.cgColor
        self.permissionCover.borderWidth = 1.0
        
        let mapTitleString = NSAttributedString(string: Localizations.evaluate.checkin.showMap, attributes: [NSAttributedStringKey.font: style.checkInPermissionButtonFont, NSAttributedStringKey.foregroundColor: style.checkInPermissionButtonColor])
        let mapHighlightedTitleString = NSAttributedString(string: Localizations.evaluate.checkin.showMap, attributes: [NSAttributedStringKey.font: style.checkInPermissionButtonFont, NSAttributedStringKey.foregroundColor: style.checkInPermissionButtonHighlightColor])
        
        self.mapButton.setAttributedTitle(mapTitleString, for: .normal)
        self.mapButton.setAttributedTitle(mapHighlightedTitleString, for: .highlighted)
        
        self.mapButtonCover.cornerRadius = 5.0
        self.mapButtonCover.borderColor = style.checkInPermissionButtonColor.cgColor
        self.mapButtonCover.borderWidth = 1.0
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.currentDate.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: style.checkInPermissionDateFont, NSAttributedStringKey.foregroundColor: style.checkInPermissionDateColor])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let buttonInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        let buttonInset = ASInsetLayoutSpec(insets: buttonInsets, child: self.permissionButton)
        
        let permission = ASBackgroundLayoutSpec(child: buttonInset, background: self.permissionCover)
        
        let mapButtonInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        let mapButtonInset = ASInsetLayoutSpec(insets: mapButtonInsets, child: self.mapButton)
        
        let map = ASBackgroundLayoutSpec(child: mapButtonInset, background: self.mapButtonCover)
        
        let cellStack = ASStackLayoutSpec.vertical()
        cellStack.spacing = 10.0
        cellStack.children = [self.descriptionNode, permission, map]
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 10.0
        cell.children = [self.currentDate, cellStack]
        
        let cellInsets = UIEdgeInsets(top: 30.0, left: self.leftInset, bottom: 30.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
