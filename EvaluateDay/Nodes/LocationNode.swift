//
//  LocationNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 14/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class LocationNode: ASCellNode {

    // MARK: - UI
    var street = ASTextNode()
    var otherAddress = ASTextNode()
    var coordinates = ASTextNode()
    var cover = ASDisplayNode()
    
    var button = ASButtonNode()
    
    // MARK: - Init
    init(street: String, otherAddress: String, coordinates: String) {
        super.init()
        
        self.cover.backgroundColor = UIColor.main
        self.cover.cornerRadius = 10.0
        
        if street.isEmpty && otherAddress.isEmpty {
            self.street.attributedText = NSAttributedString(string: Localizations.Evaluate.Location.unknown, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.textTint])
        } else {
            self.street.attributedText = NSAttributedString(string: street, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.textTint])
            self.otherAddress.attributedText = NSAttributedString(string: otherAddress, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.textTint])
        }
        
        self.coordinates.attributedText = NSAttributedString(string: coordinates, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2), NSAttributedString.Key.foregroundColor: UIColor.textTint])
        
        // Set button
        self.button.addTarget(self, action: #selector(self.buttonInitialAction(sender:)), forControlEvents: .touchDown)
        self.button.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.button.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchUpInside)
        self.button.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraits.button
        self.accessibilityLabel = self.street.attributedText!.string
        self.accessibilityValue = self.otherAddress.attributedText!.string
        
        self.isAccessibilityElement = true
        self.accessibilityLabel = "\(street), \(otherAddress)"
        self.accessibilityValue = coordinates
        
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
        content.justifyContent = .center
        content.children = [address, coordinateStack]
        
        let contentInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        let contentInset = ASInsetLayoutSpec(insets: contentInsets, child: content)
        
        let cell = ASBackgroundLayoutSpec(child: contentInset, background: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        let back = ASOverlayLayoutSpec(child: cellInset, overlay: self.button)
        return back
    }
    
    // MARK: - Actions
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
