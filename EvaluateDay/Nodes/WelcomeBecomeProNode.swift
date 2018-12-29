//
//  WelcomeBecomeProNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 14/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class WelcomeBecomeProNode: ASCellNode {
    // MARK: - UI
    var cover = ASDisplayNode()
    var titleLabel = ASTextNode()
    var dateLabel = ASTextNode()
    var descriptionLabel = ASTextNode()
    
    // MARK: - Init
    override init() {
        super.init()
        
        self.cover.cornerRadius = 10.0
        self.cover.borderColor = UIColor.gunmetal.cgColor
        self.cover.borderWidth = 1.0
        
        let center = NSMutableParagraphStyle()
        center.alignment = .center
        
        if Store.current.valid != nil {
            self.dateLabel.attributedText = NSAttributedString(string: DateFormatter.localizedString(from: Store.current.valid!, dateStyle: .medium, timeStyle: .none), attributes: [NSAttributedStringKey.font: UIFont.avenirNext(size: 26.0, weight: .bold), NSAttributedStringKey.foregroundColor: UIColor.viridian, NSAttributedStringKey.paragraphStyle: center])
        }
        
        self.titleLabel.attributedText = NSAttributedString(string: Localizations.welcome.cards.pro.title, attributes: [NSAttributedStringKey.font: UIFont.avenirNext(size: 24.0, weight: .bold), NSAttributedStringKey.foregroundColor: UIColor.gunmetal, NSAttributedStringKey.paragraphStyle: center])
        self.descriptionLabel.attributedText = NSAttributedString(string: Localizations.welcome.cards.pro.description, attributes: [NSAttributedStringKey.font: UIFont.avenirNext(size: 18.0, weight: .regular), NSAttributedStringKey.foregroundColor: UIColor.gunmetal, NSAttributedStringKey.paragraphStyle: center])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let cell = ASStackLayoutSpec.vertical()
        cell.spacing = 15.0
        cell.children = [self.titleLabel, self.descriptionLabel, self.dateLabel]
        
        let cellItemsInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        let cellItemsInset = ASInsetLayoutSpec(insets: cellItemsInsets, child: cell)
        
        let center = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: cellItemsInset)
        
        let overlay = ASOverlayLayoutSpec(child: center, overlay: self.cover)
        
        let cellInsets = UIEdgeInsets(top: 40.0, left: 20.0, bottom: 60.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: overlay)
        
        return cellInset
    }
}
