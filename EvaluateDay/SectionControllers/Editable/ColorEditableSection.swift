//
//  ColorEditableSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 31/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import IGListKit

private enum ColorSettingsNodeType {
    case sectionTitle
    case title
    case subtitles
    case separator
}

class ColorEditableSection: ListSectionController, ASSectionController, EditableSection {
    // MARK: - Variable
    var card: Card!
    
    // MARK: - Actions
    var setTextHandler: ((String, String, String?) -> Void)?
    var setBoolHandler: ((Bool, String, Bool) -> Void)?
    
    // MARK: - Private Variables
    private var nodes = [ColorSettingsNodeType]()
    
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
                let separator = SeparatorNode(style: style)
                if index != 1 && index != self.nodes.count - 1 {
                    separator.leftInset = 20.0
                }
                return separator
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
        } else if self.nodes[index] == .subtitles {
            self.setTextHandler?(Localizations.cardSettings.subtitle, "subtitle", self.card.subtitle)
        }
    }
}
