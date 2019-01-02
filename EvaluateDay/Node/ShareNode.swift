//
//  ShareNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 02/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ShareNode: ASCellNode {
    
    // MARK: - UI
    var dashboard = ASImageNode()
    var shareButton = ASButtonNode()
    var shareImage = ASImageNode()
    var shareCover = ASDisplayNode()
    
    // MARK: - Init
    init(dashboardImage: UIImage?) {
        super.init()
        
        self.dashboard.image = dashboardImage
        
        self.shareCover.backgroundColor = UIColor.background
        self.shareCover.cornerRadius = 10.0
        self.shareImage.image = UIImage(named: "share")?.resizedImage(newSize: CGSize(width: 24.0, height: 22.0))
        self.shareImage.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.selected)
        self.shareButton.addTarget(self, action: #selector(self.shareInitialAction(sender:)), forControlEvents: .touchDown)
        self.shareButton.addTarget(self, action: #selector(self.shareEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.shareButton.addTarget(self, action: #selector(self.shareEndAction(sender:)), forControlEvents: .touchUpInside)
        self.shareButton.addTarget(self, action: #selector(self.shareEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let shareImageInsets = UIEdgeInsets(top: 13.0, left: 12.0, bottom: 13.0, right: 12.0)
        let shareImageInset = ASInsetLayoutSpec(insets: shareImageInsets, child: self.shareImage)
        
        let share = ASBackgroundLayoutSpec(child: shareImageInset, background: self.shareCover)
        let shareFull = ASOverlayLayoutSpec(child: share, overlay: self.shareButton)
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.alignItems = .center
        cell.justifyContent = .spaceBetween
        
        self.dashboard.style.preferredSize = CGSize(width: 48.0, height: 48.0)
        self.dashboard.cornerRadius = 48.0/2
        
        cell.children = [self.dashboard, shareFull]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func shareInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.shareCover.backgroundColor = UIColor.tint
        }
    }
    
    @objc func shareEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.shareCover.backgroundColor = UIColor.background
        }
    }
}
