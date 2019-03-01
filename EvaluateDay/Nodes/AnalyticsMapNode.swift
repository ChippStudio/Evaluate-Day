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
    init(title: String, actionTitle: String?) {
        super.init()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        self.title.attributedText = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline), NSAttributedString.Key.foregroundColor: UIColor.text, NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        self.shareButton.setImage(#imageLiteral(resourceName: "share"), for: .normal)
        self.shareButton.imageNode.contentMode = .scaleAspectFit
        self.shareButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.main)
        
        if actionTitle != nil {
            self.actionButton = ASButtonNode()
            self.actionButtonCover = ASDisplayNode()
            
            let actionTitleString = NSAttributedString(string: actionTitle!, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.textTint])
            
            self.actionButton.setAttributedTitle(actionTitleString, for: .normal)
            
            self.actionButtonCover.backgroundColor = UIColor.main
            self.actionButtonCover.cornerRadius = 10.0
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
        self.shareButton.accessibilityLabel = Localizations.Calendar.Empty.share
        self.shareButton.accessibilityValue = "\(self.title.attributedText!.string), \(Localizations.Accessibility.Analytics.mapView)"
        
        self.mapNode.isAccessibilityElement = true
        
        self.actionButton.addTarget(self, action: #selector(self.buttonInitialAction(sender:)), forControlEvents: .touchDown)
        self.actionButton.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.actionButton.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchUpInside)
        self.actionButton.addTarget(self, action: #selector(self.buttonEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        self.mapNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 20, height: 300.0)
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
        cell.spacing = 10.0
        cell.children = [shareInset, self.mapNode]
        
        if self.actionButton != nil && self.actionButtonCover != nil {
            let actionButtonInsets = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
            let actionButtonInset = ASInsetLayoutSpec(insets: actionButtonInsets, child: self.actionButton!)
            
            let action = ASBackgroundLayoutSpec(child: actionButtonInset, background: self.actionButtonCover!)
            
            let buttonInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
            let buttonInset = ASInsetLayoutSpec(insets: buttonInsets, child: action)
            
            cell.children?.append(buttonInset)
        }
        
        let cellInsets = UIEdgeInsets(top: self.topInset, left: 10.0, bottom: 20.0, right: 10.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func buttonInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.actionButtonCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func buttonEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.actionButtonCover.backgroundColor = UIColor.main
        }
    }
}
