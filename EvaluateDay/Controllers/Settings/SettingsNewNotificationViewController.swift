//
//  SettingsNewNotificationViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 30/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import UserNotifications

class SettingsNewNotificationViewController: UIViewController, ASTableDataSource, ASTableDelegate, TextTopViewControllerDelegate, SelectCardListViewControllerDelegate, TimeBottomViewControllerDelegate {

    // MARK: - UI
    var tableNode: ASTableNode!
    var saveButton: UIBarButtonItem!
    var deleteButton: UIBarButtonItem!
    
    // MARK: - Variable
    var notification = LocalNotification()
    var card: Card!
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        self.navigationItem.title = Localizations.settings.notifications.new.title
        
        if self.notification.realm == nil {
            self.notification.message = Localizations.settings.notifications.new.defaultMessage
            self.saveButton = UIBarButtonItem(title: Localizations.general.save, style: .plain, target: self, action: #selector(saveAction(sender:)))
            self.navigationItem.rightBarButtonItem = self.saveButton
        } else {
            self.deleteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "delete").resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(deleteAction(sender:)))
            self.navigationItem.rightBarButtonItem = self.deleteButton
        }
        
        // Set table node
        self.tableNode = ASTableNode(style: .grouped)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.view.addSubnode(self.tableNode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self.view.traitCollection.userInterfaceIdiom == .pad && self.view.frame.size.width >= maxCollectionWidth {
            self.tableNode.frame = CGRect(x: self.view.frame.size.width / 2 - maxCollectionWidth / 2, y: 0.0, width: maxCollectionWidth, height: self.view.frame.size.height)
        } else {
            self.tableNode.frame = self.view.bounds
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.observable()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Re set all notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for n in Database.manager.application.notifications {
            // Set notifications
            let baseID = n.id
            
            if n.repeatNotification == "1111111" {
                self.setNotification(notification: n, id: baseID, weekday: nil, monthDay: nil)
            } else if n.repeatNotification != "0000000" {
                for (i, d) in n.repeatNotification.enumerated() {
                    if d == "1" {
                        self.setNotification(notification: n, id: baseID + "-\(i)", weekday: i + 1, monthDay: nil)
                    }
                }
            }
        }
    }
    
    private func setNotification(notification: LocalNotification, id: String, weekday: Int?, monthDay: Int?) {
        let content = UNMutableNotificationContent()
        content.body = notification.message
        content.sound = UNNotificationSound(named: "EvaluatePush.wav")
        content.userInfo = ["id": id]
        if notification.cardID != nil {
            content.categoryIdentifier = "EvaluateCategory-ID"
            content.userInfo["cardID"] = notification.cardID!
        }
        
        var dateComponents = DateComponents()
        let nDateComp = Calendar.current.dateComponents([.hour, .minute, .month], from: notification.date)
        dateComponents.hour = nDateComp.hour
        dateComponents.minute = nDateComp.minute
        
        if weekday != nil {
            dateComponents.weekday = weekday
        }
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // MARK: - ASTableDataSource
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let style = Themes.manager.settingsStyle
        let selView = UIView()
        selView.backgroundColor = style.settingsSelectColor
        let separatorInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
    
        var title = ""
        var subtitle = ""
        
        switch indexPath.row {
        case 0:
            title = Localizations.settings.notifications.new.message + ":"
            subtitle = self.notification.message
        case 1:
            title = Localizations.settings.notifications.new.time
            subtitle = DateFormatter.localizedString(from: self.notification.date, dateStyle: .none, timeStyle: .short)
        case 2:
            title = Localizations.settings.notifications.new._repeat.title
            subtitle = self.notification.localizedString
        default:
            title = Localizations.settings.notifications.new.card
            if self.notification.cardID != nil {
                if let card = Database.manager.data.objects(Card.self).filter("id=%@", self.notification.cardID!).first {
                    subtitle = card.title
                } else {
                    subtitle = Localizations.settings.notifications.new.optional
                }
            } else {
                if self.card != nil {
                    subtitle = self.card.title
                } else {
                    subtitle = Localizations.settings.notifications.new.optional
                }
            }
        }
        
        return {
            let node = SettingsMoreNode(title: title, subtitle: subtitle, image: nil, style: style)
            
            node.backgroundColor = style.settingsSectionBackground
            node.selectedBackgroundView = selView
            node.separatorInset = separatorInsets
            
            return node
        }
    }
    
    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let controller = TextTopViewController()
            controller.titleLabel.text = Localizations.settings.notifications.new.message
            if self.notification.message != Localizations.settings.notifications.new.defaultMessage {
                controller.textView.text = self.notification.message
            }
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        case 1:
            let controller = TimeBottomViewController()
            controller.date = self.notification.date
            controller.closeByTap = true
            controller.delegate = self
            self.present(controller, animated: true, completion: nil)
        case 2:
            let controller = UIStoryboard(name: Storyboards.repeatList.rawValue, bundle: nil).instantiateInitialViewController() as! RepeatViewController
            controller.notification = self.notification
            controller.didSetNewRepeatInterval = { () in
                let indexPath = IndexPath(row: 2, section: 0)
                self.tableNode.reloadRows(at: [indexPath], with: .fade)
            }
            self.navigationController?.pushViewController(controller, animated: true)
        default:
            if self.card == nil {
                let controller = UIStoryboard(name: Storyboards.selectCardList.rawValue, bundle: nil).instantiateInitialViewController() as! SelectCardListViewController
                controller.delegate = self
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    // MARK: - TextTopViewControllerDelegate
    func textTopController(controller: TextTopViewController, willCloseWith text: String, forProperty property: String) {
        if text != "" {
            if self.notification.realm == nil {
                self.notification.message = text
            } else {
                try! Database.manager.app.write {
                    self.notification.message = text
                }
            }
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableNode.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - SelectCardListViewControllerDelegate
    func didSelect(cardId id: String) {
        if self.notification.realm == nil {
            self.notification.cardID = id
        } else {
            try! Database.manager.app.write {
                self.notification.cardID = id
            }
        }
        
        let indexPath = IndexPath(row: 3, section: 0)
        self.tableNode.reloadRows(at: [indexPath], with: .fade)
    }
    
    // MARK: - TimeBottomViewControllerDelegate
    func didSelectTime(inDate date: Date) {
        if self.notification.realm == nil {
            self.notification.date = date
        } else {
            try! Database.manager.app.write {
                self.notification.date = date
            }
        }
        
        let indexPath = IndexPath(row: 1, section: 0)
        self.tableNode.reloadRows(at: [indexPath], with: .fade)
    }
    
    // MARK: - Actions
    @objc func saveAction(sender: UIBarButtonItem) {
        try! Database.manager.app.write {
            Database.manager.app.add(self.notification)
            Database.manager.application.notifications.append(self.notification)
        }
        
        sendEvent(.addNewNotification, withProperties: nil)
        self.navigationController?.popViewController(animated: true )
    }
    
    @objc func deleteAction(sender: UIBarButtonItem) {
        if self.notification.repeatNotification == "1111111" {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [self.notification.id])
        } else {
            var ids = [String]()
            for (i, w) in self.notification.repeatNotification.enumerated() {
                if w == "1" {
                    ids.append(self.notification.id + "-\(i)")
                }
            }
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
        }
        
        try! Database.manager.app.write {
            Database.manager.app.delete(self.notification)
        }
        
        sendEvent(.deleteNotification, withProperties: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.settingsStyle
            
            //set NavigationBar
            self.navigationController?.navigationBar.barTintColor = style.barColor
            self.navigationController?.navigationBar.tintColor = style.barTint
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: style.barTint, NSAttributedStringKey.font: style.barTitleFont]
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: style.barTint, NSAttributedStringKey.font: style.barLargeTitleFont]
            }
            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
            
            // Backgrounds
            self.view.backgroundColor = style.background
            self.tableNode.backgroundColor = style.background
            
            // Table node
            self.tableNode.view.separatorColor = style.settingsSeparatorColor
        })
    }
}
