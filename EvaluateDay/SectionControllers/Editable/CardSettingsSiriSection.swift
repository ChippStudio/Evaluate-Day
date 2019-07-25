//
//  CardSettingsSiriSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/07/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Intents
import IntentsUI

@available(iOS 12.0, *)
class CardSettingsSiriSection: ListSectionController, ASSectionController, INUIAddVoiceShortcutViewControllerDelegate, INUIEditVoiceShortcutViewControllerDelegate {
    // MARK: - Variables
    let card: Card
    
    // MARK: - Private Variables
    private var cardShortcuts = [Shortcut]()
    
    // MARK: - Init
    init(card: Card) {
        
        self.card = card
        
        super.init()
        
        self.setShortcuts()
    }
    
    // MARK: - Override
    override func numberOfItems() -> Int {
        return self.cardShortcuts.count + 2
    }
    
    func nodeForItem(at index: Int) -> ASCellNode {
        return ASCellNode()
    }
    
    func nodeBlockForItem(at index: Int) -> ASCellNodeBlock {
        if index == 0 {
            return {
                let node = CardSettingsSectionTitleNode(title: Localizations.Siri.Settings.sectionTitle)
                return node
            }
        }
        
        if index == self.cardShortcuts.count + 1 {
            return {
                let separator = SeparatorNode()
                separator.insets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0)
                return separator
            }
        }
        
        let item = self.cardShortcuts[index - 1]
        if item.voiceShortcuts != nil {
            return {
                let node = CardSettingsEditSiriNode(title: item.voiceShortcuts!.shortcut.userActivity!.title!, phrase: item.voiceShortcuts!.invocationPhrase)
                return node
            }
        } else {
            return {
                let node = CardSettingsSiriAddNode(title: item.suggestion!.title!)
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
        let item = self.cardShortcuts[index - 1]
        if item.voiceShortcuts != nil {
            let controller = INUIEditVoiceShortcutViewController(voiceShortcut: item.voiceShortcuts!)
            controller.delegate = self
            self.viewController?.present(controller, animated: true, completion: nil)
        } else {
            let controller = INUIAddVoiceShortcutViewController(shortcut: INShortcut(userActivity: item.suggestion!))
            controller.delegate = self
            self.viewController?.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: - INUIAddVoiceShortcutViewControllerDelegate
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        self.setShortcuts()
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - INUIEditVoiceShortcutViewControllerDelegate
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        self.setShortcuts()
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        self.setShortcuts()
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private
    private func setShortcuts() {
        INVoiceShortcutCenter.shared.getAllVoiceShortcuts { (shortcuts, error) in
            
            OperationQueue.main.addOperation {
                if shortcuts == nil {
                    return
                }
                
                self.cardShortcuts.removeAll()
                
                if let suggestions = self.card.data.suggestions {
                    for suggest in suggestions {
                        var voiceShortcut: INVoiceShortcut?
                        for vs in shortcuts! {
                            if let voiceActivity = vs.shortcut.userActivity {
                                if voiceActivity.activityType == suggest.activityType {
                                    if voiceActivity.userInfo?["card"] as? String == suggest.userInfo?["card"] as? String {
                                        voiceShortcut = vs
                                    }
                                }
                            }
                        }
                        if voiceShortcut != nil {
                            self.cardShortcuts.append(Shortcut(voiceShortcuts: voiceShortcut, suggestion: nil))
                        } else {
                            self.cardShortcuts.append(Shortcut(voiceShortcuts: nil, suggestion: suggest))
                        }
                    }
                    
                    self.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                        batchContext.reload(self)
                    }, completion: nil)
                }
            }
        }
    }
    
    private struct Shortcut {
        var voiceShortcuts: INVoiceShortcut?
        var suggestion: NSUserActivity?
    }
}
