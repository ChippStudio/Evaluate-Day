//
//  DateButtonsNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 30/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class DateButtonsNode: ASCellNode {

    // MARK: - UI
    var todayText = ASTextNode()
    var todayCover = ASDisplayNode()
    var todayButton = ASButtonNode()
    
    var arrowImage = ASImageNode()
    var arrowCover = ASDisplayNode()
    var arrowButton = ASButtonNode()
    
    // MARK: - Variable
    var date: Date! {
        didSet {
            var alpha: CGFloat = 1.0
            self.todayCover.isAccessibilityElement = true
            if date.isToday {
                alpha = 0.0
                self.todayCover.isAccessibilityElement = false
            }
            UIView.animate(withDuration: 0.2) {
                self.todayCover.alpha = alpha
                self.todayText.alpha = alpha
                self.todayButton.alpha = alpha
            }
        }
    }
    
    // MARK: - Init
    init(date: Date) {
        super.init()
        
        self.todayText.attributedText = NSAttributedString(string: Localizations.General.today, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedStringKey.foregroundColor: UIColor.textTint])
        self.todayCover.backgroundColor = UIColor.main
        self.todayCover.cornerRadius = 15.0
        self.todayButton.addTarget(self, action: #selector(self.todayInitialAction(sender:)), forControlEvents: .touchDown)
        self.todayButton.addTarget(self, action: #selector(self.todayEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.todayButton.addTarget(self, action: #selector(self.todayEndAction(sender:)), forControlEvents: .touchUpInside)
        self.todayButton.addTarget(self, action: #selector(self.todayEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.arrowImage.image = UIImage(named: "down")?.resizedImage(newSize: CGSize(width: 22.0, height: 12.0))
        self.arrowImage.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.textTint)
        self.arrowImage.contentMode = .scaleAspectFit
        
        self.arrowCover.backgroundColor = UIColor.main
        self.arrowCover.cornerRadius = 15.0
        self.arrowButton.addTarget(self, action: #selector(self.arrowInitialAction(sender:)), forControlEvents: .touchDown)
        self.arrowButton.addTarget(self, action: #selector(self.arrowEndAction(sender:)), forControlEvents: .touchUpOutside)
        self.arrowButton.addTarget(self, action: #selector(self.arrowEndAction(sender:)), forControlEvents: .touchUpInside)
        self.arrowButton.addTarget(self, action: #selector(self.arrowEndAction(sender:)), forControlEvents: .touchCancel)
        
        self.todayCover.isAccessibilityElement = true
        self.todayCover.accessibilityTraits = UIAccessibilityTraitButton
        self.todayCover.accessibilityLabel = Localizations.General.today
        
        self.arrowCover.isAccessibilityElement = true
        self.arrowCover.accessibilityTraits = UIAccessibilityTraitButton
        self.arrowCover.accessibilityLabel = Localizations.Accessibility.date
        
        self.todayText.isAccessibilityElement = false
        self.arrowButton.isAccessibilityElement = false
        self.todayButton.isAccessibilityElement = false
        
        self.date = date
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let todayTextInsets = UIEdgeInsets(top: 6.0, left: 20.0, bottom: 6.0, right: 20.0)
        let todayTextInset = ASInsetLayoutSpec(insets: todayTextInsets, child: self.todayText)
        let today = ASBackgroundLayoutSpec(child: todayTextInset, background: self.todayCover)
        let todayFull = ASOverlayLayoutSpec(child: today, overlay: self.todayButton)
        
        self.arrowImage.style.preferredSize = CGSize(width: 24.0, height: 24.0)
        let arrowImageInsets = UIEdgeInsets(top: 5.0, left: 15.0, bottom: 5.0, right: 15.0)
        let arrowImageInset = ASInsetLayoutSpec(insets: arrowImageInsets, child: self.arrowImage)
        let arrow = ASBackgroundLayoutSpec(child: arrowImageInset, background: self.arrowCover)
        let arrowFull = ASOverlayLayoutSpec(child: arrow, overlay: self.arrowButton)
        
        let cell = ASStackLayoutSpec.horizontal()
        cell.spacing = 10.0
        cell.alignItems = .center
        cell.justifyContent = .end
        cell.children = [todayFull, arrowFull]
        
        let cellInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 20.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: cell)
        
        return cellInset
    }
    
    // MARK: - Actions
    @objc func todayInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.todayCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func todayEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.todayCover.backgroundColor = UIColor.main
        }
    }
    
    @objc func arrowInitialAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.arrowCover.backgroundColor = UIColor.selected
        }
    }
    
    @objc func arrowEndAction(sender: ASButtonNode) {
        UIView.animate(withDuration: 0.2) {
            self.arrowCover.backgroundColor = UIColor.main
        }
    }
}
