//
//  CardSettingsCollectionSections.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RealmSwift

private enum CardSettingsCollectionNodeType {
    case sectionTitle
    case new
    case delete
    case collection
    case separator
}

class CardSettingsCollectionSections: ListSectionController, ASSectionController, CollectionsListViewControllerDelegate {
    // MARK: - Variables
    let card: Card
    
    // MARK: - Private Variables
    private var notifications: Results<LocalNotification>!
    private var nodes = [CardSettingsCollectionNodeType]()
    
    // MARK: - Init
    init(card: Card) {
        
        self.card = card
        
        super.init()
        
        self.nodesSetup()
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return nodes.count
    }
    
    func nodeForItem(at index: Int) -> ASCellNode {
        return ASCellNode()
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        switch nodes[index] {
        case .delete:
            return {
                let node = DangerNode(title: Localizations.General.delete, image: Images.Media.delete.image, color: UIColor.negative)
                return node
            }
        case .new:
            return {
                let node = SettingsMoreNode(title: Localizations.Collection.Empty.cardSetting, subtitle: nil, image: Images.Media.collections.image)
                return node
            }
        case .collection:
            let collection = Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@ AND id=%@", false, self.card.dashboard!).first!
            
            let image = UIImage(named: collection.image)
            let title = collection.title
            return {
                let node = CardSettingsCollectionNode(title: title, image: image)
                return node
            }
        case .separator:
            return {
                let separator = SeparatorNode()
                separator.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
                return separator
            }
        case .sectionTitle:
            return {
                let node = CardSettingsSectionTitleNode(title: Localizations.Collection.Edit.title)
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
        let item = self.nodes[index]
        if item == .collection || item == .new {
            if let nav = self.viewController?.navigationController {
                let controller = UIStoryboard(name: Storyboards.collectionsList.rawValue, bundle: nil).instantiateInitialViewController() as! CollectionsListViewController
                controller.delegate = self
                nav.pushViewController(controller, animated: true)
            }
        }
        
        if item == .delete {
            if self.card.realm == nil {
                self.card.dashboard = nil
            } else {
                try! Database.manager.data.write {
                    self.card.dashboard = nil
                }
            }
            
            self.nodesSetup()
            self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(self)
            }, completion: nil)
        }
    }
    
    // MARK: - CollectionsListViewControllerDelegate
    func collectionList(controller: CollectionsListViewController, didSelectCollection collectionId: String) {
        if self.card.realm == nil {
            self.card.dashboard = collectionId
        } else {
            try! Database.manager.data.write {
                self.card.dashboard = collectionId
            }
        }
        
        controller.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private
    private func nodesSetup() {
        self.nodes.removeAll()
        
        self.nodes.append(.sectionTitle)
        if self.card.dashboard != nil {
            if Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@ AND id=%@", false, self.card.dashboard!).first != nil {
                self.nodes.append(.collection)
                self.nodes.append(.delete)
            } else {
                self.nodes.append(.new)
            }
        } else {
            self.nodes.append(.new)
        }
        self.nodes.append(.separator)
    }
}
