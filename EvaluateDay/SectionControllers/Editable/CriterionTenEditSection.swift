//
//  CriterionTenEditSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 11/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit
import AsyncDisplayKit

private enum CriterionTenSettingsNodeType {
    case sectionTitle
    case title
    case subtitles
    case separator
    case positiveBool
    case positiveDescription
}

class CriterionTenEditSection: ListSectionController, ASSectionController, EditableSection {
    // MARK: - Variable
    var card: Card!
    
    // MARK: - Actions
    var setTextHandler: ((String, String, String?) -> Void)?
    var setBoolHandler: ((Bool, String, Bool) -> Void)?
    
    // MARK: - Private Variables
    private var nodes = [CriterionTenSettingsNodeType]()
    
    // MARK: - Init
    init(card: Card) {
        super.init()
        if let realmCard = Database.manager.data.objects(Card.self).filter("id=%@", card.id).first {
            self.card = realmCard
        } else {
            self.card = card
        }
        
        self.nodes.append(.sectionTitle)
        self.nodes.append(.separator)
        self.nodes.append(.title)
        self.nodes.append(.separator)
        self.nodes.append(.subtitles)
        self.nodes.append(.separator)
        self.nodes.append(.positiveBool)
        self.nodes.append(.positiveDescription)
        self.nodes.append(.separator)
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return self.nodes.count
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        
        let style = Themes.manager.cardSettingsStyle
        switch self.nodes[index] {
        case .sectionTitle:
            return {
                let node = CardSettingsSectionTitleNode(title: Localizations.settings.general.title, style: style)
                return node
            }
        case .title:
            let title = Localizations.cardSettings.title
            let text = self.card.title
            return {
                let node = CardSettingsTextNode(title: title, text: text, style: style)
                return node
            }
        case .subtitles:
            let subtitle = Localizations.cardSettings.subtitle
            let text = self.card.subtitle
            return {
                let node = CardSettingsTextNode(title: subtitle, text: text, style: style)
                return node
            }
        case .separator:
            return {
                let separator = SeparatorNode()
                if index != 1 && index != self.nodes.count - 1 {
                    separator.insets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
                }
                return separator
            }
        case .positiveBool:
            let title = Localizations.cardSettings.criterion.feater.title
            let isOn = (self.card.data as! CriterionTenCard).positive
            return {
                let node = CardSettingsBooleanNode(title: title, isOn: isOn, style: style)
                node.switchAction = { (isOn) in
                    self.setBoolHandler?(isOn, "positive", (self.card.data as! CriterionTenCard).positive)
                }
                return node
            }
        case .positiveDescription:
            return {
                let node = DescriptionNode(text: Localizations.cardSettings.criterion.feater.description, alignment: .left, style: style)
                node.topInset = 10.0
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
        if self.nodes[index] == .title {
            self.setTextHandler?(Localizations.cardSettings.title, "title", self.card.title)
        }
        if self.nodes[index] == .subtitles {
            self.setTextHandler?(Localizations.cardSettings.subtitle, "subtitle", self.card.subtitle)
        }
    }
}
