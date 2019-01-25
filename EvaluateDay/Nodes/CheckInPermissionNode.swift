//
//  CheckInPermissionNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 13/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CheckInPermissionNode: ASCellNode {
    // MARK: - UI
    var descriptionNode = ASTextNode()
    
    var permissionButton = ASButtonNode()
    var permissionCover = ASDisplayNode()
    
    var mapButton = ASButtonNode()
    var mapButtonCover = ASDisplayNode()
    
    var currentDate = ASTextNode()
    
    var cover = ASDisplayNode()
    
    // MARK: - Variable
    var leftInset: CGFloat = 10.0
    
    // MARK: - Init
    init(date: Date) {
        super.init()
        
        self.cover.backgroundColor = UIColor.background
        self.cover.cornerRadius = 10.0
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .left
        
        self.descriptionNode.attributedText = NSAttributedString(string: Localizations.Evaluate.Checkin.Permission.description, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.text, NSAttributedStringKey.paragraphStyle: paragraph])
        
        let buttonTitleString = NSAttributedString(string: Localizations.Evaluate.Checkin.Permission.buttonTitle, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .title3), NSAttributedStringKey.foregroundColor: UIColor.textTint])
        
        self.permissionButton.setAttributedTitle(buttonTitleString, for: .normal)
        
        self.permissionCover.cornerRadius = 20.0
        self.permissionCover.backgroundColor = UIColor.main
        
        let mapTitleString = NSAttributedString(string: Localizations.Evaluate.Checkin.showMap, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .title3), NSAttributedStringKey.foregroundColor: UIColor.textTint])
        
        self.mapButton.setAttributedTitle(mapTitleString, for: .normal)
        
        self.mapButtonCover.cornerRadius = 20.0
        self.mapButtonCover.backgroundColor = UIColor.main
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        
        self.currentDate.attributedText = NSAttributedString(string: formatter.string(from: date), attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.text])
        self.currentDate.isAccessibilityElement = false
        
        // Buttons Action
        self.permissionButton.addTarget(self, action: #selector(self.permissionInitialAction(sender:)), forControlEvents: .touchDown)
        self.permissionButton.addTarget(self, action: #selector(self.permissionEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.permissionButton.addTarget(self, action: #selector(self.permissionEndAction(sender:)), forControlEvents: .touchUpInside)
        self.permissionButton.addTarget(self, action: #selector(self.permissionEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.mapButton.addTarget(self, action: #selector(self.mapInitialAction(sender:)), forControlEvents: .touchDown)
        self.mapButton.addTarget(self, action: #selector(self.mapEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.mapButton.addTarget(self, action: #selector(self.mapEndAction(sender:)), forControlEvents: .touchUpInside)
        self.mapButton.addTarget(self, action: #selector(self.mapEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let permissionButtonInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        let permissionButtonInset = ASInsetLayoutSpec(insets: permissionButtonInsets, child: self.permissionButton)
        
        let permission = ASBackgroundLayoutSpec(child: permissionButtonInset, background: self.permissionCover)
        
        let mapButtonInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        let mapButtonInset = ASInsetLayoutSpec(insets: mapButtonInsets, child: self.mapButton)
        
        let map = ASBackgroundLayoutSpec(child: mapButtonInset, background: self.mapButtonCover)
        
        let buttons = ASStackLayoutSpec.vertical()
        buttons.spacing = 10.0
        buttons.children = [permission, map]
        
        let cellStack = ASStackLayoutSpec.vertical()
        cellStack.spacing = 30.0
        cellStack.children = [self.descriptionNode, buttons]
        
        let content = ASStackLayoutSpec.vertical()
        content.spacing = 10.0
        content.children = [self.currentDate, cellStack]
        
        let contentInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 20, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func permissionInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.permissionCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func permissionEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.permissionCover.backgroundColor = UIColor.main
        }
    }
    
    @objc func mapInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.mapButtonCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func mapEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.mapButtonCover.backgroundColor = UIColor.main
        }
    }
}
