//
//  CriterionTenMergeSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 11/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import IGListKit
import RealmSwift

class CriterionTenMergeSection: ListSectionController, ASSectionController, MergeSection {
    // MARK: - Variable
    var card: Card!
    
    // MARK: - Handler
    var mergeDone: (() -> Void)?
    
    // MARK: - Private variables
    private var byBase: Bool = true
    private var otherCards: Results<Card>!
    private let nodes: Int = 6
    private var selectedIndex: Int?
    
    // MARK: - Init
    init(card: Card) {
        super.init()
        if let realmCard = Database.manager.data.objects(Card.self).filter("id=%@", card.id).first {
            self.card = realmCard
        } else {
            self.card = card
        }
        
        // Set other cards
        self.otherCards = Database.manager.data.objects(Card.self).filter("id!=%@ AND typeRaw=%@ AND isDeleted=%@", self.card.id, self.card.typeRaw, false)
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return self.nodes + otherCards.count + 2
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        
        let style = Themes.manager.cardMergeStyle
        
        switch index {
        case 0:
            return {
                let node = BigDescriptionNode(text: Localizations.CardMerge.baseCard, alignment: .left, style: style)
                node.topInset = 40.0
                return node
            }
        case 1:
            let title = self.card.title
            let subtitle = self.card.subtitle
            let image = Sources.image(forType: self.card.type)
            return {
                let node = TitleNode(title: title, subtitle: subtitle, image: image)
                node.isAccessibilityElement = true
                node.accessibilityLabel = title
                node.accessibilityValue = subtitle
                return node
            }
        case 2:
            return {
                let node = DescriptionNode(text: Localizations.CardMerge.mergeTypeDescription, alignment: .left)
                node.leftInset = 50.0
                return node
            }
        case 3:
            return {
                let node = SettingsSelectNode(title: Localizations.CardMerge.mergeByBaseCard, subtitle: nil, image: nil, style: style)
                node.select = self.byBase
                node.topInset = 30.0
                node.leftInset = 20.0
                return node
            }
        case 4:
            return {
                let node = SettingsSelectNode(title: Localizations.CardMerge.mergeByDate, subtitle: nil, image: nil, style: style)
                node.select = self.byBase
                node.leftInset = 20.0
                return node
            }
        case 5:
            return {
                let node = BigDescriptionNode(text: Localizations.CardMerge.selectCard, alignment: .left, style: style)
                node.topInset = 50.0
                return node
            }
        case self.nodes + self.otherCards.count:
            return {
                let node = SettingsProButtonNode(title: Localizations.CardMerge.action)
                node.topInset = 50.0
                node.didPressed = { () in
                    if self.selectedIndex == nil {
                        let alert = UIAlertController(title: nil, message: Localizations.CardMerge.mustSelect, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: Localizations.General.ok, style: .default, handler: nil)
                        alert.addAction(okAction)
                        
                        alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
                        alert.view.layoutIfNeeded()
                        self.viewController?.present(alert, animated: true) {
                            alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
                        }
                    } else {
                        // MARK: - Merge Data
                        let otherCard = self.otherCards[self.selectedIndex!]
                        for value in (otherCard.data as! CriterionTenCard).values {
                            if let alreadyIn = (self.card.data as! CriterionTenCard).values.filter("(created >= %@) AND (created <= %@)", value.created.start, value.created.end).first {
                                if !self.byBase {
                                    if alreadyIn.edited < value.edited {
                                        try! Database.manager.data.write {
                                            alreadyIn.value = value.value
                                            alreadyIn.edited = Date()
                                        }
                                    }
                                }
                            } else {
                                try! Database.manager.data.write {
                                    value.owner = self.card.id
                                }
                            }
                        }
                        // Delete other card
                        try! Database.manager.data.write {
                            otherCard.data.deleteValues()
                            otherCard.isDeleted = true
                        }
                        
                        self.mergeDone?()
                    }
                }
                return node
            }
        case self.nodes + self.otherCards.count + 1:
            return {
                let node = DescriptionNode(text: Localizations.CardMerge.disclaimer, alignment: .center)
                return node
            }
        default:
            let newIndex = index - nodes
            let cCard = self.otherCards[newIndex]
            let title = cCard.title
            return {
                let node = SettingsSelectNode(title: title, subtitle: nil, image: nil, style: style)
                node.select = false
                if self.selectedIndex != nil {
                    if newIndex == self.selectedIndex {
                        node.select = true
                    }
                }
                node.leftInset = 20.0
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
        if index == 3 {
            self.byBase = true
            self.reloadData(atIndex: index)
            self.reloadData(atIndex: 4)
        }
        
        if index == 4 {
            self.byBase = false
            self.reloadData(atIndex: index)
            self.reloadData(atIndex: 3)
        }
        
        if index - nodes >= 0 && index - nodes < self.otherCards.count {
            if self.selectedIndex == nil {
                self.reloadData(atIndex: self.nodes + self.otherCards.count)
            }
            self.selectedIndex = index - nodes
            for i in 0..<self.otherCards.count {
                self.reloadData(atIndex: i + nodes)
            }
        }
    }
    
    // MARK: - Private func
    private func reloadData(atIndex index: Int) {
        collectionContext?.performBatch(animated: true, updates: { (batchContext) in
            batchContext.reload(in: self, at: IndexSet(integer: index))
        }, completion: nil)
    }
}
