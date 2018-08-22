//
//  SettingsBooleanNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 11/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol SettingsBooleanNodeStyle {
    var settingsTitleNodeColor: UIColor { get }
    var settingsTitleNodeFont: UIFont { get }
    var settingsBooleanOnTintColor: UIColor { get }
    var settingsBooleanTintColor: UIColor { get }
    var settingsBooleanThumbTintColor: UIColor { get }
    var imageTintColor: UIColor { get }
}

class SettingsBooleanNode: ASCellNode {
    // MARK: - UI
    var title = ASTextNode()
    var imageNode: ASImageNode!
    var switcher: ASDisplayNode!
    var switchButton: UISwitch!
    
    // MARK: - Handler
    var switchDidLoad: ((_ switch: UISwitch) -> Void)?
    
    // MARK: - Init
    init(title: String, image: UIImage?, isOn: Bool, style: SettingsBooleanNodeStyle) {
        super.init()
        
        self.selectionStyle = .none
        
        self.switcher = ASDisplayNode(viewBlock: { () -> UIView in
            self.switchButton = UISwitch()
            self.switchButton.isOn = isOn
            self.switchButton.onTintColor = style.settingsBooleanOnTintColor
            self.switchButton.tintColor = style.settingsBooleanTintColor
            if style.settingsBooleanThumbTintColor != UIColor.clear {
                self.switchButton.thumbTintColor = style.settingsBooleanThumbTintColor
            }
//            switchButton.addTarget(self, action: #selector(self.switchActionFunction(sender:)), for: .valueChanged)
            return self.switchButton
        }, didLoad: { (_) in
            self.switchDidLoad?(self.switchButton)
            self.switchButton.isAccessibilityElement = true
            self.switchButton.accessibilityLabel = title
        })
        self.switcher.backgroundColor = UIColor.clear
        
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: style.settingsTitleNodeFont, NSAttributedStringKey.foregroundColor: style.settingsTitleNodeColor])
        self.title.isAccessibilityElement = false
        
        if image != nil {
            self.imageNode = ASImageNode()
            self.imageNode.image = image
            self.imageNode.isAccessibilityElement = false
            self.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.imageTintColor)
        }
        
        //Accessibility
        self.automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.switcher.style.preferredSize = CGSize(width: 52.0, height: 32.0)
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        self.title.style.flexShrink = 1.0
        
        let cellTitle = ASStackLayoutSpec.horizontal()
        cellTitle.spacing = 10.0
        cellTitle.style.flexShrink = 1.0
        cellTitle.children = [self.title]
        if self.imageNode != nil {
            self.imageNode.style.preferredSize = CGSize(width: 25.0, height: 25.0)
            cellTitle.children?.insert(self.imageNode, at: 0)
        }
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 10.0
        cell.alignItems = .center
        cell.children = [cellTitle, spacer, self.switcher]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
