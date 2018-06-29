//
//  SettingsProReviewNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 04/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol SettingsProReviewNodeStyle {
    var proReviewProTitleColor: UIColor { get }
    var proReviewProTitleFont: UIFont { get }
    var proReviewProSubtitleColor: UIColor { get }
    var proReviewProSubtitleFont: UIFont { get }
    var proReviewProEmojiSize: CGFloat { get }
    var proReviewProSubscriptionTitleColor: UIColor { get }
    var proReviewProSubscriptionTitleFont: UIFont { get }
    var proReviewProSubscriptionValidColor: UIColor { get }
    var proReviewProSubscriptionValidFont: UIFont { get }
    var proReviewProDescriptionLabelColor: UIColor { get }
    var proReviewProDescriptionLabelFont: UIFont { get }
}

class SettingsProReviewNode: ASCellNode {

    // MARK: - UI
    var proTitle = ASTextNode()
    var proSubtitle = ASTextNode()
    var emojiLabel = ASTextNode()
    var subscriptionTitle = ASTextNode()
    var subscriptionValid = ASTextNode()
    var descriptionLabel: ASTextNode!
    var infoButton = ASButtonNode()
    
    // MARK: - Init
    init(subscribe: Bool, style: SettingsProReviewNodeStyle) {
        super.init()
        
        let center = NSMutableParagraphStyle()
        center.alignment = .center
        
        self.proTitle.attributedText = NSAttributedString(string: Localizations.settings.pro.review.title.uppercased(), attributes: [NSAttributedStringKey.font: style.proReviewProTitleFont, NSAttributedStringKey.foregroundColor: style.proReviewProTitleColor, NSAttributedStringKey.paragraphStyle: center])
        self.proSubtitle.attributedText = NSAttributedString(string: Localizations.settings.pro.review.subtitle, attributes: [NSAttributedStringKey.font: style.proReviewProSubtitleFont, NSAttributedStringKey.foregroundColor: style.proReviewProSubtitleColor, NSAttributedStringKey.paragraphStyle: center])
        self.emojiLabel.attributedText = NSAttributedString(string: "🇪🇪❤️👇🔓", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: style.proReviewProEmojiSize), NSAttributedStringKey.paragraphStyle: center])
        self.subscriptionTitle.attributedText = NSAttributedString(string: Localizations.settings.pro.review.subscription.title.uppercased(), attributes: [NSAttributedStringKey.font: style.proReviewProSubscriptionTitleFont, NSAttributedStringKey.foregroundColor: style.proReviewProSubscriptionTitleColor, NSAttributedStringKey.paragraphStyle: center])
        
        var timeStyle = DateFormatter.Style.none
        if Bundle.main.object(forInfoDictionaryKey: "CSSandbox") as! Bool {
            timeStyle = DateFormatter.Style.medium
        }
        if Store.current.valid != nil {
            self.subscriptionValid.attributedText = NSAttributedString(string: Localizations.settings.pro.review.subscription.subtitle(value1: DateFormatter.localizedString(from: Store.current.valid!, dateStyle: .medium, timeStyle: timeStyle)), attributes: [NSAttributedStringKey.font: style.proReviewProSubscriptionValidFont, NSAttributedStringKey.foregroundColor: style.proReviewProSubscriptionValidColor, NSAttributedStringKey.paragraphStyle: center])
            if subscribe {
                self.descriptionLabel = ASTextNode()
                self.descriptionLabel.attributedText = NSAttributedString(string: Localizations.settings.pro.review.subscription.description, attributes: [NSAttributedStringKey.font: style.proReviewProDescriptionLabelFont, NSAttributedStringKey.foregroundColor: style.proReviewProDescriptionLabelColor, NSAttributedStringKey.paragraphStyle: center])
            }
        } else {
            self.subscriptionValid.attributedText = NSAttributedString(string: Localizations.settings.pro.review.subscription.subtitle(value1: Localizations.general.lifetime), attributes: [NSAttributedStringKey.font: style.proReviewProSubscriptionValidFont, NSAttributedStringKey.foregroundColor: style.proReviewProSubscriptionValidColor, NSAttributedStringKey.paragraphStyle: center])
        }
        
        self.infoButton.setImage(#imageLiteral(resourceName: "info").resizedImage(newSize: CGSize(width: 20.0, height: 20.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.infoButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.proReviewProSubscriptionValidColor)
        
        self.automaticallyManagesSubnodes = true
    }
    
    // MARK: - Override
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let titles = ASStackLayoutSpec.vertical()
        titles.children = [self.proTitle, self.proSubtitle]
        
        self.infoButton.style.preferredSize = CGSize(width: 30.0, height: 30.0)
        
        self.subscriptionTitle.style.flexGrow = 1.0
        
        let subscriptionTitle = ASStackLayoutSpec.horizontal()
        subscriptionTitle.justifyContent = .end
        subscriptionTitle.alignItems = .center
        subscriptionTitle.children = [self.subscriptionTitle, self.infoButton]
        
        let subscriptions = ASStackLayoutSpec.vertical()
        subscriptions.children = [subscriptionTitle, self.subscriptionValid]
        
        let items = ASStackLayoutSpec.vertical()
        items.spacing = 30.0
        items.children = [titles, self.emojiLabel, subscriptions]
        
        if self.descriptionLabel != nil {
            items.children?.append(self.descriptionLabel)
        }
        
        let cellInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        let cellInset = ASInsetLayoutSpec(insets: cellInsets, child: items)
        
        return cellInset
    }
}
