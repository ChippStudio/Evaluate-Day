//
//  CheckInDataEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CheckInDataEvaluateNode: ASCellNode {
    // MARK: - UI
    var street = ASTextNode()
    var otherAddress = ASTextNode()
    var coordinates = ASTextNode()
    var cover = ASDisplayNode()
    
    private var button: ASButtonNode!
    
    // MARK: - Variables
    var didSelectItem: ((_ index: Int) -> Void)?
    private var index: Int = 0
    var leftInset: CGFloat = 10.0
    
    // MARK: - Init
    init(street: String, otherAddress: String, coordinates: String, index: Int? = nil) {
        super.init()
        
        self.cover.backgroundColor = UIColor.main
        self.cover.cornerRadius = 10.0
        
        if index != nil {
            self.index = index!
        }
        
        if street.isEmpty && otherAddress.isEmpty {
            self.street.attributedText = NSAttributedString(string: Localizations.Evaluate.Location.unknown, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedStringKey.foregroundColor: UIColor.tint])
        } else {
            self.street.attributedText = NSAttributedString(string: street, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedStringKey.foregroundColor: UIColor.tint])
            self.otherAddress.attributedText = NSAttributedString(string: otherAddress, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.tint])
        }
        
        self.coordinates.attributedText = NSAttributedString(string: coordinates, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2), NSAttributedStringKey.foregroundColor: UIColor.tint])
        
        // Set button
        if index != nil {
            self.button = ASButtonNode()
            self.button.addTarget(self, action: #selector(self.buttonAction(sendar:)), forControlEvents: .touchUpInside)
            
            self.button.addTarget(self, action: #selector(self.buttonInitialAction(sender:)), forControlEvents: .touchDown)
            self.button.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchUpOutside)
            self.button.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchUpInside)
            self.button.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchCancel)
        }
        
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraitButton
        self.accessibilityLabel = self.street.attributedText!.string
        self.accessibilityValue = self.otherAddress.attributedText!.string
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let otherAdsressInsets = UIEdgeInsets(top: 0.0, left: 30.0, bottom: 0.0, right: 10.0)
        let otherAddressInset = ASInsetLayoutSpec(insets: otherAdsressInsets, child: self.otherAddress)
        self.otherAddress.style.flexShrink = 1.0
        
        let address = ASStackLayoutSpec.vertical()
        address.spacing = -5
        address.children = [self.street, otherAddressInset]
        
        let coordinateStack = ASStackLayoutSpec.vertical()
        coordinateStack.alignItems = .end
        coordinateStack.spacing = 5
        coordinateStack.children = [self.coordinates]
        
        let content = ASStackLayoutSpec.vertical()
        content.spacing = 10.0
        content.children = [address, coordinateStack]
        
        let contentInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 20, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        if self.button != nil {
            let back = ASOverlayLayoutSpec(child: cellInset, overlay: self.button)
            return back
        }
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc private func buttonAction(sendar: ASButtonNode) {
        self.didSelectItem?(self.index)
    }
    
    @objc func buttonInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func buttonEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.cover.backgroundColor = UIColor.main
        }
    }
}
