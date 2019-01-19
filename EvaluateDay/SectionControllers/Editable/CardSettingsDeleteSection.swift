//
//  CardSettingsDeleteSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 08/08/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

private enum CardSettingsDeleteNodeType {
    case sectionTitle
    case delete
    case merge
    case archive
}

class CardSettingsDeleteSection: ListSectionController, ASSectionController {
    // MARK: - Variables
    let card: Card
    
    // MARK: - Private Variables
    private var nodes = [CardSettingsDeleteNodeType]()
    
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
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        switch nodes[index] {
        case .sectionTitle:
            return {
                let node = CardSettingsSectionTitleNode(title: Localizations.CardSettings.dangerZone)
                return node
            }
        case .delete:
            return {
                let node = DangerNode(title: Localizations.General.delete, image: Images.Media.delete.image, color: UIColor.negative)
                return node
            }
        case .merge:
            return {
                let node = DangerNode(title: Localizations.CardMerge.action, image: Images.Media.merge.image, color: UIColor.main)
                return node
            }
        case .archive:
            var archiveString = Localizations.General.archive
            if self.card.archived {
                archiveString = Localizations.General.unarchive
            }
            return {
                let node = DangerNode(title: archiveString, image: Images.Media.archive.image, color: UIColor.main)
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
        if self.nodes[index] == .delete {
            self.deleteCard(index: index)
        } else if self.nodes[index] == .archive {
            if self.card.archived {
                self.unarchiveCard(index: index)
            } else {
                archiveCard(index: index)
            }
        } else if self.nodes[index] == .merge {
            let controller = UIStoryboard(name: Storyboards.cardMerge.rawValue, bundle: nil).instantiateInitialViewController() as! CardMergeViewController
            controller.card = self.card
            if let nav = self.viewController?.parent as? UINavigationController {
                nav.pushViewController(controller, animated: true)
            }
        }
    }
    
    // MARK: - Private
    private func nodesSetup() {
        self.nodes.removeAll()
        
        self.nodes.append(.sectionTitle)
//        self.nodes.append(.separator)
        if self.card.data as? Mergeable != nil {
            self.nodes.append(.merge)
//            self.nodes.append(.separator)
        }
        self.nodes.append(.archive)
//        self.nodes.append(.separator)
        self.nodes.append(.delete)
//        self.nodes.append(.separator)
    }
    
    private func deleteCard(index: Int) {
        var message = Localizations.List.Card.deleteMessage
        if !card.archived {
            message += "\n\n \(Localizations.List.Card.archiveNotDelete) \n\n"
            message += Localizations.List.Card.archiveMessage
        }
        
        let alert = UIAlertController(title: Localizations.General.sureQuestion, message: message, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: Localizations.General.cancel, style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: Localizations.General.delete, style: .destructive) { (_) in
            // Delete card
            sendEvent(.deleteCard, withProperties: ["type": self.card.type.string])
            try! Database.manager.data.write {
                self.card.data.deleteValues()
                self.card.isDeleted = true
            }
            
            Feedback.player.play(sound: .deleteCard, feedbackType: .success)
            
            if let nav = self.viewController?.parent as? UINavigationController {
                nav.popToRootViewController(animated: true)
            }
        }
        
        let archiveAction = UIAlertAction(title: Localizations.General.archive, style: .default) { (_) in
            // Archive card
            sendEvent(.archiveCard, withProperties: ["type": self.card.type.string])
            
            try! Database.manager.data.write {
                self.card.archived = true
                self.card.archivedDate = Date()
                self.card.edited = Date()
            }
            
            self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(self)
            }, completion: nil)
        }
        
        if !card.archived {
            alert.addAction(archiveAction)
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        if self.viewController!.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            if let controller = self.viewController as? CardSettingsViewController {
                let node = controller.collectionNode.nodeForItem(at: IndexPath(row: index, section: self.section))!
                alert.popoverPresentationController?.sourceRect = node.frame
                alert.popoverPresentationController?.sourceView = node.view
            }
        }
        self.viewController!.present(alert, animated: true) {
        }
    }
    
    private func unarchiveCard(index: Int) {
        let alert = UIAlertController(title: Localizations.General.sureQuestion, message: Localizations.List.Card.unarchiveMessage, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: Localizations.General.cancel, style: .cancel, handler: nil)
        let unarchiveAction = UIAlertAction(title: Localizations.General.unarchive, style: .default) { (_) in
            // Unarchive card
            try! Database.manager.data.write {
                self.card.archived = false
                self.card.archivedDate = nil
                self.card.edited = Date()
            }
            sendEvent(.unarchiveCard, withProperties: ["type": self.card.type.string])
            
            self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(self)
            }, completion: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(unarchiveAction)
        
        if self.viewController!.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            if let controller = self.viewController as? CardSettingsViewController {
                let node = controller.collectionNode.nodeForItem(at: IndexPath(row: index, section: self.section))!
                alert.popoverPresentationController?.sourceRect = node.frame
                alert.popoverPresentationController?.sourceView = node.view
            }
        }
        self.viewController!.present(alert, animated: true) {
        }
    }
    
    private func archiveCard(index: Int) {
        let alert = UIAlertController(title: Localizations.General.sureQuestion, message: Localizations.List.Card.archiveMessage, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: Localizations.General.cancel, style: .cancel, handler: nil)
        let archiveAction = UIAlertAction(title: Localizations.General.archive, style: .default) { (_) in
            // Unarchive card
            try! Database.manager.data.write {
                self.card.archived = true
                self.card.archivedDate = Date()
                self.card.edited = Date()
            }
            sendEvent(.archiveCard, withProperties: ["type": self.card.type.string])
            
            self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                batchContext.reload(self)
            }, completion: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(archiveAction)
        
        if self.viewController!.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            if let controller = self.viewController as? CardSettingsViewController {
                let node = controller.collectionNode.nodeForItem(at: IndexPath(row: index, section: self.section))!
                alert.popoverPresentationController?.sourceRect = node.frame
                alert.popoverPresentationController?.sourceView = node.view
            }
        }

        self.viewController!.present(alert, animated: true) {
        }
    }
}
