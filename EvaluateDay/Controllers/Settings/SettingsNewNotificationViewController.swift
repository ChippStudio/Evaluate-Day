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

class SettingsNewNotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TextViewControllerDelegate, SelectCardListViewControllerDelegate, TimeBottomViewControllerDelegate {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    var saveButton: UIBarButtonItem!
    var deleteButton: UIBarButtonItem!
    
    // MARK: - Variable
    var notification = LocalNotification()
    var card: Card!
    
    private let notificationCell = "notificationCell"
    private let moreCell = "moreCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        self.navigationItem.title = Localizations.Settings.Notifications.New.title
        
        if self.notification.realm == nil {
            self.notification.message = Localizations.Settings.Notifications.New.defaultMessage
            self.saveButton = UIBarButtonItem(title: Localizations.General.save, style: .plain, target: self, action: #selector(saveAction(sender:)))
            self.navigationItem.rightBarButtonItem = self.saveButton
        } else {
            self.deleteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "delete").resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(deleteAction(sender:)))
            self.navigationItem.rightBarButtonItem = self.deleteButton
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.barButtonAccessibilityLabel()
        self.updateAppearance(animated: false)
    }
    
    override func updateAppearance(animated: Bool) {
        super.updateAppearance(animated: animated)
        
        let duration: TimeInterval = animated ? 0.2 : 0
        UIView.animate(withDuration: duration) {
            //set NavigationBar
            self.navigationController?.navigationBar.barTintColor = UIColor.background
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = UIColor.main
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
            }
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            
            // tableView
            self.tableView.backgroundColor = UIColor.background
        }
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
        content.sound = UNNotificationSound(named: convertToUNNotificationSoundName("EvaluatePush.wav"))
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
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let selView = UIView()
        selView.layer.cornerRadius = 5.0
        selView.backgroundColor = UIColor.tint

        var title = ""
        var subtitle = ""
        let image = Images.Media.notification.image
        
        switch indexPath.row {
        case 0:
            title = Localizations.Settings.Notifications.New.message + ":"
            subtitle = self.notification.message
        case 1:
            title = Localizations.Settings.Notifications.New.time
            subtitle = DateFormatter.localizedString(from: self.notification.date, dateStyle: .none, timeStyle: .short)
        case 2:
            title = Localizations.Settings.Notifications.New.Repeat.title
            subtitle = self.notification.localizedString
        default:
            title = Localizations.Settings.Notifications.New.card
            if self.notification.cardID != nil {
                if let card = Database.manager.data.objects(Card.self).filter("id=%@", self.notification.cardID!).first {
                    subtitle = card.title
                } else {
                    subtitle = Localizations.Settings.Notifications.New.optional
                }
            } else {
                if self.card != nil {
                    subtitle = self.card.title
                } else {
                    subtitle = Localizations.Settings.Notifications.New.optional
                }
            }
        }
        
        let idetifire = indexPath.row == 0 ? notificationCell : moreCell
        let cell = tableView.dequeueReusableCell(withIdentifier: idetifire, for: indexPath)
        cell.textLabel?.text = title
        cell.detailTextLabel?.text = subtitle
        cell.textLabel?.textColor = UIColor.text
        cell.detailTextLabel?.textColor = UIColor.text
        cell.imageView?.image = image.resizedImage(newSize: CGSize(width: 26.0, height: 26.0)).withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = UIColor.main
        cell.selectedBackgroundView = selView
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let controller = UIStoryboard(name: Storyboards.text.rawValue, bundle: nil).instantiateInitialViewController() as! TextViewController
            controller.titleText = Localizations.Settings.Notifications.New.message
            if self.notification.message != Localizations.Settings.Notifications.New.defaultMessage {
                controller.text = self.notification.message
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
                self.tableView.reloadRows(at: [indexPath], with: .fade)
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
    
    // MARK: - TextViewControllerDelegate
    func textTopController(controller: TextViewController, willCloseWith text: String, forProperty property: String) {
        if text != "" {
            if self.notification.realm == nil {
                self.notification.message = text
            } else {
                try! Database.manager.app.write {
                    self.notification.message = text
                }
            }
            
            self.barButtonAccessibilityLabel()
            
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - SelectCardListViewControllerDelegate
    func didSelect(cardId id: String, in cotroller: SelectCardListViewController) {
        if self.notification.realm == nil {
            self.notification.cardID = id
        } else {
            try! Database.manager.app.write {
                self.notification.cardID = id
            }
        }
        
        self.barButtonAccessibilityLabel()
        
        let indexPath = IndexPath(row: 3, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .fade)
        if let card = Database.manager.data.objects(Card.self).filter("id=%@", id).first {
            sendEvent(.addCardToNotification, withProperties: ["type": card.type.string])
        }
        cotroller.navigationController?.popViewController(animated: true)
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
        
        self.barButtonAccessibilityLabel()
        
        let indexPath = IndexPath(row: 1, section: 0)
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    // MARK: - Actions
    @objc func saveAction(sender: UIBarButtonItem) {
        if self.card != nil {
            self.notification.cardID = self.card.id
        }
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
    private func barButtonAccessibilityLabel() {
        if self.saveButton != nil {
            var cardString = Localizations.General.none
            if notification.cardID != nil {
                if let card = Database.manager.data.objects(Card.self).filter("id=%@", self.notification.cardID!).first {
                    cardString = card.title
                }
            }
            self.saveButton.accessibilityLabel = Localizations.General.save + ", " + Localizations.Accessibility.Notification.description(self.notification.message, self.notification.localizedString, DateFormatter.localizedString(from: self.notification.date, dateStyle: .none, timeStyle: .short), cardString)
        } else if self.deleteButton != nil {
            var cardString = Localizations.General.none
            if notification.cardID != nil {
                if let card = Database.manager.data.objects(Card.self).filter("id=%@", self.notification.cardID!).first {
                    cardString = card.title
                }
            }
            self.deleteButton.accessibilityLabel = Localizations.General.delete + ", " + Localizations.Accessibility.Notification.description(self.notification.message, self.notification.localizedString, DateFormatter.localizedString(from: self.notification.date, dateStyle: .none, timeStyle: .short), cardString)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUNNotificationSoundName(_ input: String) -> UNNotificationSoundName {
	return UNNotificationSoundName(rawValue: input)
}
