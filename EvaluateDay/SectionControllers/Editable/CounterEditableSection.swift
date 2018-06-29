//
//  CounterEditableSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 19/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import IGListKit

class CounterEditableSection: ListSectionController, ASSectionController, EditableSection, TextTopViewControllerDelegate {
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
        if (self.card.data as! CounterCard).isSum {
            return 5
        }
        
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
            let step = (self.card.data as! CounterCard).step
            return {
                let node = SettingsMoreNode(title: Localizations.cardSettings.counter.step, subtitle: String(format: "%.2f", step), image: nil, style: style)
                node.topInset = 50.0
                return node
            }
        } else if index == 3 {
            let title = Localizations.cardSettings.counter.sum.title
            let isOn = (self.card.data as! CounterCard).isSum
            return {
                let node = CardSettingsBooleanNode(title: title, isOn: isOn, style: style)
                node.switchAction = { (isOn) in
                    self.setBoolHandler?(isOn, "isSum", (self.card.data as! CounterCard).isSum)
                    self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                        batchContext.reload(self)
                    }, completion: nil)
                }
                node.topInset = 50.0
                return node
            }
        } else {
            let start = (self.card.data as! CounterCard).startValue
            return {
                let node = SettingsMoreNode(title: Localizations.cardSettings.counter.start, subtitle: String(format: "%.2f", start), image: nil, style: style)
                node.topInset = 50.0
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
        
        if index == 2 {
            // Step value set
            let controller = TextTopViewController()
            controller.onlyNumbers = true
            controller.property = "step"
            controller.delegate = self
            controller.titleLabel.text = Localizations.cardSettings.counter.step
            self.viewController?.present(controller, animated: true, completion: nil)
        }
        
        if index == 4 {
            // Start value
            let controller = TextTopViewController()
            controller.onlyNumbers = true
            controller.property = "startValue"
            controller.delegate = self
            controller.titleLabel.text = Localizations.cardSettings.counter.start
            self.viewController?.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: - TextTopViewControllerDelegate
    func textTopController(controller: TextTopViewController, willCloseWith text: String, forProperty property: String) {
        if let value = Double(text) {
            let counterCard = self.card.data as! CounterCard
            if counterCard.realm != nil {
                try! Database.manager.data.write {
                    counterCard[property] = value
                }
            } else {
                counterCard[property] = value
            }
            
            self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(self)
            }, completion: nil)
        }
    }
}
