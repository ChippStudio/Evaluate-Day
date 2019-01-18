//
//  CardSettingsNotificationSection.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 08/08/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RealmSwift

private enum CardSettingsNotificationNodeType {
    case sectionTitle
    case new
    case notification
    case separator
}

class CardSettingsNotificationSection: ListSectionController, ASSectionController {
    // MARK: - Variables
    let card: Card
    
    // MARK: - Private Variables
    private var notifications: Results<LocalNotification>!
    private var nodes = [(node: CardSettingsNotificationNodeType, notification: LocalNotification?)]()
    
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
        switch nodes[index].node {
        case .new:
            return {
                let node = SettingsMoreNode(title: Localizations.Settings.Notifications.add, subtitle: nil, image: Images.Media.notification.image)
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
                let node = CardSettingsSectionTitleNode(title: Localizations.Settings.Notifications.title)
                return node
            }
        case .notification:
            
            let not = self.notifications.filter("cardID=%@ && id=%@", nodes[index].notification!.cardID!, nodes[index].notification!.id).first!
            let title = not.message
            let timeString = DateFormatter.localizedString(from: not.date, dateStyle: .none, timeStyle: .short)
            let localizedRepeat = not.localizedString
            let cardTitle = self.card.title
            return {
                let node = SettingsNotificationNode(message: title, time: timeString, localizedRepeat: localizedRepeat, card: cardTitle)
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
        if self.nodes[index].node == .new {
            if Permissions.defaults.notificationStatus == .authorized {
                let controller = UIStoryboard(name: Storyboards.settings.rawValue, bundle: nil).instantiateViewController(withIdentifier: "newNotification") as! SettingsNewNotificationViewController
                controller.card = self.card
                if let nav = self.viewController?.parent as? UINavigationController {
                    nav.pushViewController(controller, animated: true)
                }
            } else if Permissions.defaults.notificationStatus == .denied {
                Permissions.defaults.openAppSettings()
            } else {
                Permissions.defaults.notificationAutorize(completion: {
                    let controller = UIStoryboard(name: Storyboards.settings.rawValue, bundle: nil).instantiateViewController(withIdentifier: "newNotification") as! SettingsNewNotificationViewController
                    controller.card = self.card
                    if let nav = self.viewController?.parent as? UINavigationController {
                        nav.pushViewController(controller, animated: true)
                    }
                })
            }
        }
        
        if self.nodes[index].node == .notification {
            let not = self.notifications.filter("cardID=%@ && id=%@", nodes[index].notification!.cardID!, nodes[index].notification!.id).first!
            let controller = UIStoryboard(name: Storyboards.settings.rawValue, bundle: nil).instantiateViewController(withIdentifier: "newNotification") as! SettingsNewNotificationViewController
            controller.notification = not
            controller.card = self.card
            if let nav = self.viewController?.parent as? UINavigationController {
                nav.pushViewController(controller, animated: true)
            }
        }
    }
    
    // MARK: - Private
    private func nodesSetup() {
        
        self.notifications = Database.manager.app.objects(LocalNotification.self).filter("cardID=%@", self.card.id)
        
        self.nodes.removeAll()
        
        self.nodes.append((node: .sectionTitle, notification: nil))
        self.nodes.append((node: .new, notification: nil))
        
        for n in self.notifications {
            if n.cardID != nil {
                self.nodes.append((node: .notification, notification: n))
            }
        }
        
        self.nodes.append((node: .separator, notification: nil))
    }
}
