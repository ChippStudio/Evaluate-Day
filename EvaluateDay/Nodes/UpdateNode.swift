//
//  UpdateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 26/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class UpdateNode: ASCellNode {
    
    // MARK: - UI
    var titleNode = ASTextNode()
    var subtitleNode = ASTextNode()
    
    var updateButton = ASButtonNode()
    var updateButtonCover = ASDisplayNode()
    
    // MARK: - Init
    override init() {
        super.init()
        
        let center = NSMutableParagraphStyle()
        center.alignment = .left
        
        self.titleNode.attributedText = NSAttributedString(string: Localizations.Update.title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title2), NSAttributedString.Key.foregroundColor: UIColor.main, NSAttributedString.Key.paragraphStyle: center])
        self.subtitleNode.attributedText = NSAttributedString(string: Localizations.Update.subtitle, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.main, NSAttributedString.Key.paragraphStyle: center])
        
        self.updateButtonCover.backgroundColor = UIColor.main
        self.updateButtonCover.cornerRadius = 10.0
        
        let buttonTitle = NSAttributedString(string: Localizations.Update.button, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.textTint, NSAttributedString.Key.paragraphStyle: center])
        self.updateButton.setAttributedTitle(buttonTitle, for: .normal)
        self.updateButton.addTarget(self, action: #selector(updateButtonAction(sender:)), forControlEvents: .touchUpInside)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let text = ASStackLayoutSpec.vertical()
        text.spacing = 10.0
        text.children = [self.titleNode, self.subtitleNode]
        
        let textInsets = UIEdgeInsets(top: 25.0, left: 0.0, bottom: 0.0, right: 0.0)
        let textInset = ASInsetLayoutSpec(insets: textInsets, child: text)
        
        let buttonInsets = UIEdgeInsets(top: 15.0, left: 30.0, bottom: 15.0, right: 30.0)
        let buttonInset = ASInsetLayoutSpec(insets: buttonInsets, child: self.updateButton)
        
        let button = ASBackgroundLayoutSpec(child: buttonInset, background: self.updateButtonCover)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 20.0
        cell.children = [textInset, button]
        
        let cellInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func updateButtonAction(sender: ASButtonNode) {
        let url = URL(string: appURLString)!
        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
