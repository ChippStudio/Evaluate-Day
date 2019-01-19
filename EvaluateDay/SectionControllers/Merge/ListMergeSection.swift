//
//  ListMergeSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 24/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import IGListKit
import RealmSwift

class ListMergeSection: ListSectionController, ASSectionController, MergeSection {
    // MARK: - Variable
    var card: Card!
    
    // MARK: - Handler
    var mergeDone: (() -> Void)?
    
    // MARK: - Private variables
    private var otherCards: Results<Card>!
    private let nodes: Int = 2
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
        
        switch index {
        case 0:
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
        case 1:
            return {
                let node = BigDescriptionNode(text: Localizations.CardMerge.selectCard, alignment: .left)
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
                        self.viewController?.present(alert, animated: true) {
                        }
                    } else {
                        // MARK: - Merge Data
                        let otherCard = self.otherCards[self.selectedIndex!]
                        try! Database.manager.data.write {
                            for value in (otherCard.data as! ListCard).values {
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
                let node = DescriptionNode(text: Localizations.CardMerge.disclaimer, alignment: .center)
                return node
            }
        default:
            let newIndex = index - nodes
            let cCard = self.otherCards[newIndex]
            let title = cCard.title
            return {
                let node = SettingsSelectNode(title: title, subtitle: nil, image: nil)
                node.select = false
                if self.selectedIndex != nil {
                    if newIndex == self.selectedIndex {
                        node.select = true
                    }
                }
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
