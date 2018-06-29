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
    var checkInDataMapTintColor: UIColor { get }
}

class CheckInDataEvaluateNode: ASCellNode {
    // MARK: - UI
    var street = ASTextNode()
    var otherAddress = ASTextNode()
    var coordinates = ASTextNode()
    var map = ASImageNode()
    
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
        
        // Set button
        self.map.image = #imageLiteral(resourceName: "map").withRenderingMode(.alwaysTemplate)
        self.map.contentMode = .scaleAspectFit
        self.map.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.checkInDataMapTintColor)
        
        // Set button
        if index != nil {
            self.button = ASButtonNode()
            self.button.addTarget(self, action: #selector(self.buttonAction(sendar:)), forControlEvents: .touchUpInside)
        }
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let textStack = ASStackLayoutSpec.vertical()
        textStack.children = [self.street, self.otherAddress, self.coordinates]
        self.map.style.preferredSize = CGSize(width: 20.0, height: 20.0)
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 15.0
        cell.alignItems = .center
        cell.children = [self.map, textStack]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
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
