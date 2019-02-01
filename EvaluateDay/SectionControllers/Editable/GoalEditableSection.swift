//
//  GoalEditableSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 26/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import IGListKit

private enum GoalSettingsNodeType {
    case sectionTitle
    case title
    case subtitles
    case separator
    case measurement
    case goal
    case step
    case total
    case initial
}

class GoalEditableSection: ListSectionController, ASSectionController, EditableSection, TextTopViewControllerDelegate {
    // MARK: - Variable
    var card: Card!
    
    // MARK: - Actions
    var setTextHandler: ((String, String, String?) -> Void)?
    var setBoolHandler: ((Bool, String, Bool) -> Void)?
    
    // MARK: - Private Variables
    private var nodes = [GoalSettingsNodeType]()
    
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
        case .measurement:
            let subtitle = Localizations.CardSettings.Counter.measurement
            let counterCard = self.card.data as! GoalCard
            let text = counterCard.measurement
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
            let step = (self.card.data as! GoalCard).goalValue
            return {
                let node = SettingsMoreNode(title: Localizations.CardSettings.Goal.goal, subtitle: String(format: "%.2f", step), image: nil)
                return node
            }
        case .step:
            let step = (self.card.data as! GoalCard).step
            return {
                let node = SettingsMoreNode(title: Localizations.CardSettings.Counter.step, subtitle: String(format: "%.2f", step), image: nil)
                return node
            }
        case .total:
            let title = Localizations.CardSettings.Counter.Sum.title
            let isOn = (self.card.data as! GoalCard).isSum
            return {
                let node = CardSettingsBooleanNode(title: title, isOn: isOn)
                node.switchAction = { (isOn) in
                    self.setBoolHandler?(isOn, "isSum", (self.card.data as! GoalCard).isSum)
                    self.nodesSource()
                    self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                        batchContext.reload(self)
                    }, completion: nil)
                }
                return node
            }
        case .initial:
            let start = (self.card.data as! GoalCard).startValue
            return {
                let node = SettingsMoreNode(title: Localizations.CardSettings.Counter.start, subtitle: String(format: "%.2f", start), image: nil)
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
        } else if self.nodes[index] == .measurement {
            let goalCard = self.card.data as! GoalCard
            let text = goalCard.measurement
            let controller = TextTopViewController()
            controller.property = "measurement"
            controller.delegate = self
            controller.titleLabel.text = Localizations.CardSettings.Counter.measurement
            controller.textView.text = text
            self.viewController?.present(controller, animated: true, completion: nil)
        } else if self.nodes[index] == .goal {
            // Goal value set
            let controller = TextTopViewController()
            controller.onlyNumbers = true
            controller.property = "goalValue"
            controller.delegate = self
            controller.titleLabel.text = Localizations.CardSettings.Goal.goal
            self.viewController?.present(controller, animated: true, completion: nil)
        } else if self.nodes[index] == .step {
            // Step value set
            let controller = TextTopViewController()
            controller.onlyNumbers = true
            controller.property = "step"
            controller.delegate = self
            controller.titleLabel.text = Localizations.CardSettings.Counter.step
            self.viewController?.present(controller, animated: true, completion: nil)
        } else if self.nodes[index] == .initial {
            // Start value
            let controller = TextTopViewController()
            controller.onlyNumbers = true
            controller.property = "startValue"
            controller.delegate = self
            controller.titleLabel.text = Localizations.CardSettings.Counter.start
            self.viewController?.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: - TextTopViewControllerDelegate
    func textTopController(controller: TextTopViewController, willCloseWith text: String, forProperty property: String) {
        if property == "measurement" {
            let goalCard = self.card.data as! GoalCard
            if goalCard.realm != nil {
                try! Database.manager.data.write {
                    goalCard[property] = text
                }
            } else {
                goalCard[property] = text
            }
            
            self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(self)
            }, completion: nil)
            
            return
        }
        if let value = Double(text) {
            let goalCard = self.card.data as! GoalCard
            if goalCard.realm != nil {
                try! Database.manager.data.write {
                    goalCard[property] = value
                }
            } else {
                goalCard[property] = value
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
        self.nodes.append(.title)
        self.nodes.append(.subtitles)
        self.nodes.append(.measurement)
        self.nodes.append(.goal)
        self.nodes.append(.step)
        self.nodes.append(.total)
        if (self.card.data as! GoalCard).isSum {
            self.nodes.append(.initial)
        }
        self.nodes.append(.separator)
    }
}
