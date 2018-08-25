//
//  AnalyticsMapNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import MapKit

protocol AnalyticsMapNodeStyle {
    var mapNodeTitleFont: UIFont { get }
    var mapNodeTitleColor: UIColor { get }
    var mapNodeShareTintColor: UIColor { get }
    var mapActionColor: UIColor { get }
    var mapActionHighlightedColor: UIColor { get }
    var mapActionFont: UIFont { get }
}

class AnalyticsMapNode: ASCellNode {

    // MARK: - UI
    var mapView: MKMapView!
    var title = ASTextNode()
    var shareButton = ASButtonNode()
    var mapNode: ASDisplayNode!
    var actionButton: ASButtonNode!
    var actionButtonCover: ASDisplayNode!
    
    // MARK: - Variables
    var topInset: CGFloat = 0.0
    var didLoadMap: (() -> Void)?
    
    // MARK: - Init
    init(title: String, actionTitle: String?, style: AnalyticsMapNodeStyle) {
        super.init()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedStringKey.font: style.mapNodeTitleFont, NSAttributedStringKey.foregroundColor: style.mapNodeTitleColor, NSAttributedStringKey.paragraphStyle: paragraphStyle])
        
        self.shareButton.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        self.shareButton.imageNode.contentMode = .scaleAspectFit
        self.shareButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.mapNodeShareTintColor)
        
        if actionTitle != nil {
            self.actionButton = ASButtonNode()
            self.actionButtonCover = ASDisplayNode()
            
            let actionTitleString = NSAttributedString(string: actionTitle!, attributes: [NSAttributedStringKey.font: style.mapActionFont, NSAttributedStringKey.foregroundColor: style.mapActionColor])
            let actionHighlightedTitleString = NSAttributedString(string: actionTitle!, attributes: [NSAttributedStringKey.font: style.mapActionFont, NSAttributedStringKey.foregroundColor: style.mapActionHighlightedColor])
            
            self.actionButton.setAttributedTitle(actionTitleString, for: .normal)
            self.actionButton.setAttributedTitle(actionHighlightedTitleString, for: .highlighted)
            
            self.actionButtonCover.cornerRadius = 5.0
            self.actionButtonCover.borderColor = style.mapActionColor.cgColor
            self.actionButtonCover.borderWidth = 1.0
        }
        
        self.mapNode = ASDisplayNode(viewBlock: { () -> UIView in
            self.mapView = MKMapView()
            
            self.mapView.isScrollEnabled = false
            self.mapView.isZoomEnabled = false
            self.mapView.isRotateEnabled = false
//            self.mapView.showsUserLocation = true
            
            return self.mapView
        }, didLoad: { (_) in
            self.didLoadMap?()
        })
        
        self.mapNode.clipsToBounds = true
        self.mapNode.cornerRadius = 10.0
        
        // MARK: - Accessibility
        self.title.isAccessibilityElement = false
        self.shareButton.accessibilityLabel = Localizations.calendar.empty.share
        self.shareButton.accessibilityValue = "\(self.title.attributedText!.string), \(Localizations.accessibility.analytics.mapView)"
        
        self.mapNode.isAccessibilityElement = true
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.mapNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 300.0)
        self.shareButton.style.preferredSize = CGSize(width: 50.0, height: 50.0)
        
        self.title.style.flexShrink = 1.0
        
        let titleStack = ASStackLayoutSpec.horizontal()
        titleStack.alignItems = .center
        titleStack.justifyContent = .spaceBetween
        titleStack.style.flexShrink = 1.0
        titleStack.children = [self.title, self.shareButton]
        
        let shareInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        let shareInset = ASInsetLayoutSpec(insets: shareInsets, child: titleStack)
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 20.0
        cell.children = [shareInset, self.mapNode]
        
        if self.actionButton != nil && self.actionButtonCover != nil {
            let actionButtonInsets = UIEdgeInsets(top: 10.0, left: 0.0, bottom: 10.0, right: 0.0)
            let actionButtonInset = ASInsetLayoutSpec(insets: actionButtonInsets, child: self.actionButton!)
            
            let action = ASBackgroundLayoutSpec(child: actionButtonInset, background: self.actionButtonCover!)
            
            let buttonInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
            let buttonInset = ASInsetLayoutSpec(insets: buttonInsets, child: action)
            
            cell.children?.append(buttonInset)
        }
        
        let cellInsets = UIEdgeInsets(top: self.topInset, left: 0.0, bottom: 20.0, right: 0.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
}
