//
//  WelcomeLastSlideNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 14/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
protocol WelcomeLastSlideNodeStyle {
    var welcomeLastTitleColor: UIColor { get }
    var welcomeLastTitleFont: UIFont { get }
    var welcomeLastSubtitleColor: UIColor { get }
    var welcomeLastSubtitleFont: UIFont { get }
}

class WelcomeLastSlideNode: ASCellNode {
    // MARK: - UI
    var title = ASTextNode()
    var subtitle = ASTextNode()
    
    // MARK: - Init
    init(isFirst: Bool, style: WelcomeLastSlideNodeStyle) {
        super.init()
        
        let center = NSMutableParagraphStyle()
        center.alignment = .center
        
        var titleString = Localizations.Welcome.Cards.Last.title
        var subtitleString = Localizations.Welcome.Cards.Last.description
        
        if isFirst {
            titleString = Localizations.Welcome.Cards.Last.More.title
            subtitleString = Localizations.Welcome.Cards.Last.More.description
        }
        
        self.title.attributedText = NSAttributedString(string: titleString, attributes: [NSAttributedStringKey.font: style.welcomeLastTitleFont, NSAttributedStringKey.foregroundColor: style.welcomeLastTitleColor, NSAttributedStringKey.paragraphStyle: center])
        self.subtitle.attributedText = NSAttributedString(string: subtitleString, attributes: [NSAttributedStringKey.font: style.welcomeLastSubtitleFont, NSAttributedStringKey.foregroundColor: style.welcomeLastSubtitleColor, NSAttributedStringKey.paragraphStyle: center])
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let text = ASStackLayoutSpec.vertical()
        text.children = [self.title, self.subtitle]
        
        let center = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: text)
        return center
    }
}
