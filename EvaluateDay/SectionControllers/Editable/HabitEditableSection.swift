//
//  HabitEditableSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import IGListKit

private enum HabitSettingsNodeType {
    case sectionTitle
    case title
    case subtitles
    case separator
    case multipleBool
    case multipleDescription
    case negativeBool
    case negativeDescription
}

class HabitEditableSection: ListSectionController, ASSectionController, EditableSection {
    // MARK: - Variable
    var card: Card!
    
    // MARK: - Actions
    var setTextHandler: ((String, String, String?) -> Void)?
    var setBoolHandler: ((Bool, String, Bool) -> Void)?
    
    // MARK: - Private Variables
    private var nodes = [HabitSettingsNodeType]()
    
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
        self.nodes.append(.multipleBool)
        self.nodes.append(.multipleDescription)
        self.nodes.append(.separator)
        self.nodes.append(.negativeBool)
        self.nodes.append(.negativeDescription)
        self.nodes.append(.separator)
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return self.nodes.count
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        
        switch self.nodes[index] {
        case .sectionTitle:
            return {
                let node = CardSettingsSectionTitleNode(title: Localizations.Settings.General.title)
                return node
            }
        case .title:
            let title = Localizations.CardSettings.title
            let text = self.card.title
            return {
                let node = CardSettingsTextNode(title: title, text: text)
                return node
            }
        case .subtitles:
            let subtitle = Localizations.CardSettings.subtitle
            let text = self.card.subtitle
            return {
                let node = CardSettingsTextNode(title: subtitle, text: text)
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
        case .multipleBool:
            let title = Localizations.CardSettings.Habit.multiple
            let isOn = (self.card.data as! HabitCard).multiple
            return {
                let node = CardSettingsBooleanNode(title: title, isOn: isOn)
                node.switchAction = { (isOn) in
                    self.setBoolHandler?(isOn, "multiple", (self.card.data as! HabitCard).multiple)
                    self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                        batchContext.reload(self)
                    }, completion: nil)
                }
                return node
            }
        case .multipleDescription:
            return {
                let node = DescriptionNode(text: Localizations.CardSettings.Habit.description, alignment: .left)
                return node
            }
        case .negativeBool:
            let title = Localizations.CardSettings.Habit.Negative.title
            let isOn = (self.card.data as! HabitCard).negative
            return {
                let node = CardSettingsBooleanNode(title: title, isOn: isOn)
                node.switchAction = { (isOn) in
                    self.setBoolHandler?(isOn, "negative", (self.card.data as! HabitCard).multiple)
                    self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                        batchContext.reload(self)
                    }, completion: nil)
                }
                return node
            }
        case .negativeDescription:
            return {
                let node = DescriptionNode(text: Localizations.CardSettings.Habit.Negative.description, alignment: .left)
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
            self.setTextHandler?(Localizations.CardSettings.title, "title", self.card.title)
        } else if self.nodes[index] == .subtitles {
            self.setTextHandler?(Localizations.CardSettings.subtitle, "subtitle", self.card.subtitle)
        }
    }
}
