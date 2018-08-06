//
//  CheckInDataEvaluateNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 12/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol CheckInDataEvaluateNodeStyle {
    var checkInDataStreetFont: UIFont { get }
    var checkInDataStreetColor: UIColor { get }
    var checkInDataOtherAddressFont: UIFont { get }
    var checkInDataOtherAddressColor: UIColor { get }
    var checkInDataCoordinatesFont: UIFont { get }
    var checkInDataCoordinatesColor: UIColor { get }
    var checkInDataSeparatorColor: UIColor { get }
}

class CheckInDataEvaluateNode: ASCellNode {
    // MARK: - UI
    var street = ASTextNode()
    var otherAddress = ASTextNode()
    var coordinates = ASTextNode()
    var separator = ASDisplayNode()
    
    private var button: ASButtonNode!
    
    // MARK: - Variables
    var didSelectItem: ((_ index: Int) -> Void)?
    private var index: Int = 0
    
    // MARK: - Init
    init(street: String, otherAddress: String, coordinates: String, index: Int? = nil, style: CheckInDataEvaluateNodeStyle) {
        super.init()
        
        if index != nil {
            self.index = index!
        }
        
        if street.isEmpty && otherAddress.isEmpty {
            self.street.attributedText = NSAttributedString(string: Localizations.evaluate.location.unknown, attributes: [NSAttributedStringKey.font: style.checkInDataStreetFont, NSAttributedStringKey.foregroundColor: style.checkInDataStreetColor])
        } else {
            self.street.attributedText = NSAttributedString(string: street, attributes: [NSAttributedStringKey.font: style.checkInDataStreetFont, NSAttributedStringKey.foregroundColor: style.checkInDataStreetColor])
            self.otherAddress.attributedText = NSAttributedString(string: otherAddress, attributes: [NSAttributedStringKey.font: style.checkInDataOtherAddressFont, NSAttributedStringKey.foregroundColor: style.checkInDataOtherAddressColor])
        }
        
        self.coordinates.attributedText = NSAttributedString(string: coordinates, attributes: [NSAttributedStringKey.font: style.checkInDataCoordinatesFont, NSAttributedStringKey.foregroundColor: style.checkInDataCoordinatesColor])
        
        self.separator.backgroundColor = style.checkInDataSeparatorColor
        
        // Set button
        if index != nil {
            self.button = ASButtonNode()
            self.button.addTarget(self, action: #selector(self.buttonAction(sendar:)), forControlEvents: .touchUpInside)
        }
        
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
        
        self.separator.style.preferredSize = CGSize(width: 200.0, height: 1.0)
        
        let coordinateStack = ASStackLayoutSpec.vertical()
        coordinateStack.alignItems = .end
        coordinateStack.spacing = 5
        coordinateStack.children = [self.coordinates, self.separator]
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 10.0
        cell.children = [address, coordinateStack]
        
        let cellInsets = UIEdgeInsets(top: 30.0, left: 10.0, bottom: 20.0, right: 10.0)
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
}
