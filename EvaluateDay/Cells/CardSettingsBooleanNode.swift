//
//  CardSettingsBooleanNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 03/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol CardSettingsBooleanNodeStyle {
    var settingsBooleanTitle: UIColor { get }
    var settingsBooleanTitleFont: UIFont { get }
    var settingsBooleanOnTintColor: UIColor { get }
    var settingsBooleanTintColor: UIColor { get }
    var settingsBooleanThumbTintColor: UIColor { get }
}
class CardSettingsBooleanNode: ASCellNode {
    
    // MARK: - UI
    var title = ASTextNode()
    var switcher: ASDisplayNode!
    
    // MARK: - Variable
    var topInset: CGFloat = 10.0
    
    // MARK: - Handler
    var switchAction: ((_ isOn: Bool) -> Void)?
    
    // MARK: - Init
    init(title: String, isOn: Bool, style: CardSettingsBooleanNodeStyle) {
        super.init()
        
        self.switcher = ASDisplayNode(viewBlock: { () -> UIView in
            let switchButton = UISwitch()
            switchButton.isOn = isOn
            switchButton.onTintColor = style.settingsBooleanOnTintColor
            switchButton.tintColor = style.settingsBooleanTintColor
            if style.settingsBooleanThumbTintColor != UIColor.clear {
                switchButton.thumbTintColor = style.settingsBooleanThumbTintColor
            }
            switchButton.addTarget(self, action: #selector(self.switchActionFunction(sender:)), for: .valueChanged)
            switchButton.isAccessibilityElement = true
            switchButton.accessibilityLabel = title
            return switchButton
        })
        self.switcher.backgroundColor = UIColor.clear
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: style.settingsBooleanTitleFont, NSAttributedStringKey.foregroundColor: style.settingsBooleanTitle])
        
        //Accessibility
        self.title.isAccessibilityElement = false
        
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.switcher.style.preferredSize = CGSize(width: 52.0, height: 32.0)
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        self.title.style.flexShrink = 1.0
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 5.0
        cell.alignItems = .center
        cell.children = [self.title, spacer, self.switcher]
        
        let cellInsets = UIEdgeInsets(top: self.topInset, left: 20.0, bottom: 10.0, right: 15.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc private func switchActionFunction(sender: UISwitch) {
        self.switchAction?(sender.isOn)
    }
}
