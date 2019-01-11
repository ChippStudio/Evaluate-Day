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
    case separator
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
        let style = Themes.manager.cardSettingsStyle
        switch nodes[index] {
        case .separator:
            return {
                let separator = SeparatorNode()
                if index != 1 && index != self.nodes.count - 1 {
                    separator.insets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
                }
                return separator
            }
        case .sectionTitle:
            return {
                let node = CardSettingsSectionTitleNode(title: Localizations.CardSettings.dangerZone, style: style)
                node.title.attributedText = NSAttributedString(string: Localizations.CardSettings.dangerZone.uppercased(), attributes: [NSAttributedStringKey.font: style.cardSettingsSectionTitleFont, NSAttributedStringKey.foregroundColor: style.dangerZoneDeleteColor])
                return node
            }
        case .delete:
            return {
                let node = SettingsMoreNode(title: Localizations.General.delete, subtitle: nil, image: #imageLiteral(resourceName: "delete"), style: style, titleAttributes: [NSAttributedStringKey.font: style.dangerZoneFont, NSAttributedStringKey.foregroundColor: style.dangerZoneDeleteColor])
                node.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.dangerZoneDeleteColor)
                return node
            }
        case .merge:
            return {
                let node = SettingsMoreNode(title: Localizations.CardMerge.action, subtitle: nil, image: #imageLiteral(resourceName: "merge"), style: style, titleAttributes: [NSAttributedStringKey.font: style.dangerZoneFont, NSAttributedStringKey.foregroundColor: style.dangerZoneMergeColor])
                node.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.dangerZoneMergeColor)
                return node
            }
        case .archive:
            var archiveString = Localizations.General.archive
            if self.card.archived {
                archiveString = Localizations.General.unarchive
            }
            return {
                let node = SettingsMoreNode(title: archiveString, subtitle: nil, image: #imageLiteral(resourceName: "archive"), style: style, titleAttributes: [NSAttributedStringKey.font: style.dangerZoneFont, NSAttributedStringKey.foregroundColor: style.dangerZoneArchiveColor])
                node.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(style.dangerZoneArchiveColor)
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
        self.nodes.append(.separator)
        if self.card.data as? Mergeable != nil {
            self.nodes.append(.merge)
            self.nodes.append(.separator)
        }
        self.nodes.append(.archive)
        self.nodes.append(.separator)
        self.nodes.append(.delete)
        self.nodes.append(.separator)
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
        
        alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
        alert.view.layoutIfNeeded()
        self.viewController!.present(alert, animated: true) {
            alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
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
        
        alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
        alert.view.layoutIfNeeded()
        self.viewController!.present(alert, animated: true) {
            alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
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
        
        alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
        alert.view.layoutIfNeeded()
        self.viewController!.present(alert, animated: true) {
            alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
        }
    }
}
