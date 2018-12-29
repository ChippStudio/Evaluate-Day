//
//  UpdateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 26/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol UpdateNodeStyle {
    var updateTitleFont: UIFont { get }
    var updateTitleColor: UIColor { get }
    var updateSubtitleColor: UIColor { get }
    var updateSubtitleFont: UIFont { get }
    var updateButtonBorderColor: UIColor { get }
    var updateButtonFont: UIFont { get }
    var updateButtonColor: UIColor { get }
}

class UpdateNode: ASCellNode {
    
    // MARK: - UI
    var titleNode = ASTextNode()
    var subtitleNode = ASTextNode()
    var updateButton = ASButtonNode()
    
    // MARK: - Init
    init(style: UpdateNodeStyle) {
        super.init()
        
        let center = NSMutableParagraphStyle()
        center.alignment = .left
        
        self.titleNode.attributedText = NSAttributedString(string: Localizations.update.title, attributes: [NSAttributedStringKey.font: style.updateTitleFont, NSAttributedStringKey.foregroundColor: style.updateTitleColor, NSAttributedStringKey.paragraphStyle: center])
        self.subtitleNode.attributedText = NSAttributedString(string: Localizations.update.subtitle, attributes: [NSAttributedStringKey.font: style.updateSubtitleFont, NSAttributedStringKey.foregroundColor: style.updateSubtitleColor, NSAttributedStringKey.paragraphStyle: center])
        
        self.updateButton.borderWidth = 1.0
        self.updateButton.borderColor = style.updateButtonBorderColor.cgColor
        self.updateButton.cornerRadius = 5.0
        
        let buttonTitle = NSAttributedString(string: Localizations.update.button, attributes: [NSAttributedStringKey.font: style.updateButtonFont, NSAttributedStringKey.foregroundColor: style.updateButtonColor, NSAttributedStringKey.paragraphStyle: center])
        self.updateButton.setAttributedTitle(buttonTitle, for: .normal)
        self.updateButton.contentEdgeInsets = UIEdgeInsets(top: 5.0, left: 10.0, bottom: 5.0, right: 10.0)
        self.updateButton.addTarget(self, action: #selector(updateButtonAction(sender:)), forControlEvents: .touchUpInside)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let text = ASStackLayoutSpec.vertical()
        text.children = [self.titleNode, self.subtitleNode]
        
        let textInsets = UIEdgeInsets(top: 15.0, left: 50.0, bottom: 0.0, right: 10.0)
        let textInset = ASInsetLayoutSpec(insets: textInsets, child: text)
        
        let buttonInsets = UIEdgeInsets(top: 15.0, left: 0.0, bottom: 15.0, right: 0.0)
        let buttonInset = ASInsetLayoutSpec(insets: buttonInsets, child: self.updateButton)
        
        let buttonCenter = ASCenterLayoutSpec(centeringOptions: .X, sizingOptions: .minimumX, child: buttonInset)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.children = [textInset, buttonCenter]
        
        return cell
    }
    
    // MARK: - Actions
    @objc func updateButtonAction(sender: ASButtonNode) {
        let url = URL(string: appURLString)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
