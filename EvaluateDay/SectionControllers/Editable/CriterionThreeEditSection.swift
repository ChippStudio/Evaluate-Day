//
//  CriterionThreeEditSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 17/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CriterionThreeEditSection: ListSectionController, ASSectionController, EditableSection {
    // MARK: - Variable
    var card: Card!
    
    // MARK: - Actions
    var setTextHandler: ((String, String, String?) -> Void)?
    var setBoolHandler: ((Bool, String, Bool) -> Void)?
    
    // MARK: - Init
    init(card: Card) {
        super.init()
        if let realmCard = Database.manager.data.objects(Card.self).filter("id=%@", card.id).first {
            self.card = realmCard
        } else {
            self.card = card
        }
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return 4
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        
        let style = Themes.manager.cardSettingsStyle
        if index == 0 {
            let title = Localizations.cardSettings.title
            let text = self.card.title
            return {
                let node = CardSettingsTextNode(title: title, text: text, style: style)
                node.topInset = 10.0
                return node
            }
        } else if index == 1 {
            let subtitle = Localizations.cardSettings.subtitle
            let text = self.card.subtitle
            return {
                let node = CardSettingsTextNode(title: subtitle, text: text, style: style)
                node.topInset = 20.0
                return node
            }
        } else if index == 2 {
            let title = Localizations.cardSettings.criterion.feater.title
            let isOn = (self.card.data as! CriterionThreeCard).positive
            return {
                let node = CardSettingsBooleanNode(title: title, isOn: isOn, style: style)
                node.switchAction = { (isOn) in
                    self.setBoolHandler?(isOn, "positive", (self.card.data as! CriterionThreeCard).positive)
                }
                node.topInset = 50.0
                return node
            }
        } else {
            return {
                let node = DescriptionNode(text: Localizations.cardSettings.criterion.feater.description, alignment: .left, style: style)
                node.topInset = 5.0
                return node
            }
        }
    }
    
    func sizeRangeForItem(at index: Int) -> ASSizeRange {
        let width = self.collectionContext!.containerSize.width
        let max = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let min = CGSize(width: width, height: 0)
        return ASSizeRange(min: min, max: max)
    }
    
    override func sizeForItem(at index: Int) -> CGSize {
        return .zero
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return collectionContext!.dequeueReusableCell(of: _ASCollectionViewCell.self, for: self, at: index)
    }
    
    override func didSelectItem(at index: Int) {
        if index == 0 {
            self.setTextHandler?(Localizations.cardSettings.title, "title", self.card.title)
        }
        if index == 1 {
            self.setTextHandler?(Localizations.cardSettings.subtitle, "subtitle", self.card.subtitle)
        }
    }
}
