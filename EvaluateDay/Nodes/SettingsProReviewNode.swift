//
//  SettingsProReviewNode.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 04/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

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
    init(subscribe: Bool) {
        super.init()
        
        let center = NSMutableParagraphStyle()
        center.alignment = .center
        
        self.proTitle.attributedText = NSAttributedString(string: Localizations.Settings.Pro.Review.title.uppercased(), attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.main, NSAttributedString.Key.paragraphStyle: center])
        
        self.proSubtitle.attributedText = NSAttributedString(string: Localizations.Settings.Pro.Review.subtitle, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.text, NSAttributedString.Key.paragraphStyle: center])
        
        self.emojiLabel.attributedText = NSAttributedString(string: "🇪🇪❤️👇🔓", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 36.0), NSAttributedString.Key.paragraphStyle: center])
        
        self.subscriptionTitle.attributedText = NSAttributedString(string: Localizations.Settings.Pro.Review.Subscription.title.uppercased(), attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body), NSAttributedString.Key.foregroundColor: UIColor.main, NSAttributedString.Key.paragraphStyle: center])
        
        var timeStyle = DateFormatter.Style.none
        if Bundle.main.object(forInfoDictionaryKey: "CSSandbox") as! Bool {
            timeStyle = DateFormatter.Style.medium
        }
        if Store.current.valid != nil {
            self.subscriptionValid.attributedText = NSAttributedString(string: Localizations.Settings.Pro.Review.Subscription.subtitle(DateFormatter.localizedString(from: Store.current.valid!, dateStyle: .medium, timeStyle: timeStyle)), attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title3), NSAttributedString.Key.foregroundColor: UIColor.text, NSAttributedString.Key.paragraphStyle: center])
            if subscribe {
                self.descriptionLabel = ASTextNode()
                self.descriptionLabel.attributedText = NSAttributedString(string: Localizations.Settings.Pro.Review.Subscription.description, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1), NSAttributedString.Key.foregroundColor: UIColor.text, NSAttributedString.Key.paragraphStyle: center])
            }
        } else {
            self.subscriptionValid.attributedText = NSAttributedString(string: Localizations.Settings.Pro.Review.Subscription.subtitle(Localizations.General.lifetime), attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title3), NSAttributedString.Key.foregroundColor: UIColor.text, NSAttributedString.Key.paragraphStyle: center])
        }
        
        self.infoButton.setImage(#imageLiteral(resourceName: "info").resizedImage(newSize: CGSize(width: 20.0, height: 20.0)).withRenderingMode(.alwaysTemplate), for: .normal)
        self.infoButton.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(UIColor.text)
        
        //Accessibility
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraits.button
        
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
