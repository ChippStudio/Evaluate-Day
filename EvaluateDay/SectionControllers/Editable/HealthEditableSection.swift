//
//  HealthEditableSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 14/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import IGListKit

private enum HealthSettingsNodeType {
    case sectionTitle
    case title
    case subtitles
    case goal
    case type
    case separator
}

class HealthEditableSection: ListSectionController, ASSectionController, EditableSection, TextTopViewControllerDelegate {
    // MARK: - Variable
    var card: Card!
    
    // MARK: - Actions
    var setTextHandler: ((String, String, String?) -> Void)?
    var setBoolHandler: ((Bool, String, Bool) -> Void)?
    
    // MARK: - Private Variables
    private var nodes = [HealthSettingsNodeType]()
    
    // MARK: - Init
    init(card: Card) {
        super.init()
        if let realmCard = Database.manager.data.objects(Card.self).filter("id=%@", card.id).first {
            self.card = realmCard
        } else {
            self.card = card
        }
        
        self.nodesSource()
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
        case .goal:
            let goal = (self.card.data as! HealthCard).goal
            return {
                let node = SettingsMoreNode(title: Localizations.CardSettings.Goal.goal, subtitle: "\(goal)", image: nil)
                return node
            }
        case .type:
            let type = (self.card.data as! HealthCard).type
            var typeString = Localizations.General.none
            if !type.isEmpty {
                typeString = NSLocalizedString("health.id.\(type)", comment: "health type")
            }
            return {
                let node = SettingsMoreNode(title: Localizations.CardSettings.Health.metrics, subtitle: typeString, image: nil)
                return node
            }
        }
    }
    
    func sizeRangeForItem(at index: Int) -> ASSizeRange {
        let width: CGFloat = self.collectionContext!.containerSize.width
        
        if  width >= maxCollectionWidth {
            let max = CGSize(width: width * collectionViewWidthDevider, height: CGFloat.greatestFiniteMagnitude)
            let min = CGSize(width: width * collectionViewWidthDevider, height: 0)
            return ASSizeRange(min: min, max: max)
        }
        
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
        } else if self.nodes[index] == .type {
            let healthCard = self.card.data as! HealthCard
            if self.card.realm == nil || healthCard.type.isEmpty {
                let controller = UIStoryboard(name: Storyboards.health.rawValue, bundle: nil).instantiateInitialViewController() as! HealthViewController
                if let nav = self.viewController?.parent as? UINavigationController {
                    nav.pushViewController(controller, animated: true)
                }
            }
        } else if self.nodes[index] == .goal {
            let controller = TextTopViewController()
            controller.onlyNumbers = true
            controller.property = "goal"
            controller.delegate = self
            controller.titleLabel.text = Localizations.CardSettings.Goal.goal
            self.viewController?.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: - TextTopViewControllerDelegate
    func textTopController(controller: TextTopViewController, willCloseWith text: String, forProperty property: String) {
        if let value = Double(text) {
            let healthCard = self.card.data as! HealthCard
            if healthCard.realm != nil {
                try! Database.manager.data.write {
                    healthCard[property] = value
                }
            } else {
                healthCard[property] = value
            }
            
            self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(self)
            }, completion: nil)
        }
    }
    
    // MARK: - Private
    private func nodesSource() {
        self.nodes.removeAll()
        
        self.nodes.append(.sectionTitle)
        self.nodes.append(.separator)
        self.nodes.append(.title)
        self.nodes.append(.separator)
        self.nodes.append(.subtitles)
        self.nodes.append(.separator)
        self.nodes.append(.goal)
        self.nodes.append(.separator)
        self.nodes.append(.type)
        self.nodes.append(.separator)
    }
}
