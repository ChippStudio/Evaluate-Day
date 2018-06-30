//
//  JournalMergeSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 05/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RealmSwift

class JournalMergeSection: ListSectionController, ASSectionController, MergeSection {
    // MARK: - Variable
    var card: Card!
    
    // MARK: - Handler
    var mergeDone: (() -> Void)?
    
    // MARK: - Private variables
    private var otherCards: Results<Card>!
    private let nodes: Int = 3
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
                let node = BigDescriptionNode(text: Localizations.cardMerge.baseCard, alignment: .left, style: style)
                node.topInset = 40.0
                return node
            }
        case 1:
            let title = self.card.title
            let subtitle = self.card.subtitle
            let image = Sources.image(forType: self.card.type)
            return {
                let node = TitleNode(title: title, subtitle: subtitle, image: image, style: style)
                node.shareButton.alpha = 0.0
                node.topInset = 10.0
                return node
            }
        case 2:
            return {
                let node = BigDescriptionNode(text: Localizations.cardMerge.selectCard, alignment: .left, style: style)
                node.topInset = 50.0
                return node
            }
        case self.nodes + self.otherCards.count:
            var full = false
            if self.selectedIndex != nil {
                full = true
            }
            return {
                let node = SettingsProButtonNode(title: Localizations.cardMerge.action, full: full, style: style)
                node.topInset = 30.0
                node.didPressed = { () in
                    if self.selectedIndex == nil {
                        let alert = UIAlertController(title: nil, message: Localizations.cardMerge.mustSelect, preferredStyle: .alert)
                        let okAction = UIAlertAction(title: Localizations.general.ok, style: .default, handler: nil)
                        alert.addAction(okAction)
                        
                        alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
                        alert.view.layoutIfNeeded()
                        self.viewController?.present(alert, animated: true) {
                            alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
                        }
                    } else {
                        // MARK: - Merge Data
                        let otherCard = self.otherCards[self.selectedIndex!]
                        try! Database.manager.data.write {
                            for value in (otherCard.data as! JournalCard).values {
                                value.owner = self.card.id
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
                let node = DescriptionNode(text: Localizations.cardMerge.disclaimer, alignment: .center, style: style)
                return node
            }
        default:
            let newIndex = index - nodes
            let cCard = self.otherCards[newIndex]
            let title = cCard.title
            return {
                let node = SettingsSelectNode(title: title, subtitle: nil, image: nil, style: style)
                node.selectImage.alpha = 0.0
                if self.selectedIndex != nil {
                    if newIndex == self.selectedIndex {
                        node.selectImage.alpha = 1.0
                    }
                }
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