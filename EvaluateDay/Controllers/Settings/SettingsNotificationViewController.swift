//
//  SettingsNotificationViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 27/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import UserNotifications

class SettingsNotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var settings = [SettingsSection]()
    
    private let notificationCell = "notificationCell"
    private let moreCell = "moreCell"
    
    private let newNotification = "newNotification"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation item
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.title = Localizations.Settings.Notifications.title
        
        // Analytics
        sendEvent(.openNotification, withProperties: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAppearance(animated: false)
        self.setSettings()
    }
    
    override func updateAppearance(animated: Bool) {
        super.updateAppearance(animated: animated)
        
        let duration: TimeInterval = animated ? 0.2 : 0
        UIView.animate(withDuration: duration) {
            //set NavigationBar
            self.navigationController?.view.backgroundColor = UIColor.background
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = UIColor.main
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            self.tableView.backgroundColor = UIColor.background
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == newNotification {
            if self.tableView.indexPathForSelectedRow != nil {
                if self.tableView.indexPathForSelectedRow!.section != 0 {
                    let controller = segue.destination as! SettingsNewNotificationViewController
                    controller.notification = Database.manager.application.notifications[self.tableView.indexPathForSelectedRow!.row]
                }
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.settings.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings[section].items.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.settings[indexPath.section].items[indexPath.row]
        let selView = UIView()
        selView.backgroundColor = UIColor.tint
        
        switch item.type {
        case .more:
            let cell = tableView.dequeueReusableCell(withIdentifier: moreCell, for: indexPath)
            cell.textLabel?.text = item.title
            cell.detailTextLabel?.text = item.subtitle
            cell.textLabel?.textColor = UIColor.text
            cell.detailTextLabel?.textColor = UIColor.text
            cell.imageView?.image = item.image?.resizedImage(newSize: CGSize(width: 26.0, height: 26.0)).withRenderingMode(.alwaysTemplate)
            cell.imageView?.tintColor = UIColor.main
            cell.selectedBackgroundView = selView
            
            cell.accessoryType = .disclosureIndicator
            if item.options != nil {
                if let disclosure = item.options!["disclosure"] as? Bool {
                    if !disclosure {
                        cell.accessoryType = .none
                    }
                }
            }
            return cell
        case .boolean:
            return UITableViewCell()
        case .notification:
            let cell = tableView.dequeueReusableCell(withIdentifier: notificationCell, for: indexPath)
            cell.textLabel?.text = item.title
            let subtitle = (item.options!["time"] as! String) + " - " + (item.options!["repeat"] as! String) + " " + (item.options!["card"] as! String)
            cell.detailTextLabel?.text = subtitle
            cell.textLabel?.textColor = UIColor.text
            cell.detailTextLabel?.textColor = UIColor.text
            cell.imageView?.image = item.image?.resizedImage(newSize: CGSize(width: 26.0, height: 26.0)).withRenderingMode(.alwaysTemplate)
            cell.imageView?.tintColor = UIColor.main
            cell.selectedBackgroundView = selView
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete {
            return
        }
        
        let not = Database.manager.application.notifications[indexPath.row]
        if not.repeatNotification == "1111111" {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [not.id])
        } else {
            var ids = [String]()
            for (i, w) in not.repeatNotification.enumerated() {
                if w == "1" {
                    ids.append(not.id + "-\(i)")
                }
            }
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
        }
        
        try! Database.manager.app.write {
            Database.manager.application.notifications.remove(at: indexPath.row)
            Database.manager.app.delete(not)
        }
        
        sendEvent(.deleteNotification, withProperties: nil)
        
        self.setSettings()
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.settings[indexPath.section].items[indexPath.row]
        switch item.action as! NotificationSettingsAction {
        case .new:
            if Permissions.defaults.notificationStatus == .authorized {
                self.performSegue(withIdentifier: self.newNotification, sender: self)
            } else if Permissions.defaults.notificationStatus == .denied {
                Permissions.defaults.openAppSettings()
            } else {
                Permissions.defaults.notificationAutorize(completion: {
                    self.performSegue(withIdentifier: self.newNotification, sender: self)
                })
            }
        case .edit:
            self.performSegue(withIdentifier: newNotification, sender: self)
        case .bool: ()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = self.settings[section]
        return item.header
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let item = self.settings[section]
        return item.footer
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = view as? UITableViewHeaderFooterView else { return }
        footer.textLabel?.textColor = UIColor.text
        footer.textLabel!.font = UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.text
        header.textLabel!.font = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    // MARK: - Actions
    @objc func booleanAction(sender: UISwitch) {
        if let action = BooleanAction(rawValue: sender.tag) {
            switch action {
            default: ()
            }
        }
    }
    
    // MARK: - Private
    private func setSettings() {
        self.settings.removeAll()
        
        let addNewItem = SettingItem(title: Localizations.Settings.Notifications.add, type: .more, action: NotificationSettingsAction.new, image: Images.Media.notification.image)
        let addNewSection = SettingsSection(items: [addNewItem])
        self.settings.append(addNewSection)
        
        if Permissions.defaults.notificationStatus == .authorized {
            var notificationsSection = SettingsSection(items: [], header: Localizations.Settings.Notifications.title, footer: nil)
            
            for n in Database.manager.application.notifications {
                var cardTitle = ""
                if n.cardID != nil {
                    if let card = Database.manager.data.objects(Card.self).filter("id=%@", n.cardID!).first {
                        cardTitle = card.title
                    }
                }
                
                let timeString = DateFormatter.localizedString(from: n.date, dateStyle: .none, timeStyle: .short)
                let localizedRepeat = n.localizedString
                
                let item = SettingItem(title: n.message, type: .notification, action: NotificationSettingsAction.edit, subtitle: nil, image: Images.Media.notification.image, options: ["time": timeString, "repeat": localizedRepeat, "card": cardTitle])
                notificationsSection.items.append(item)
            }
            
            if !notificationsSection.items.isEmpty {
                self.settings.append(notificationsSection)
            }
        }
        
        self.tableView.reloadData()
    }
    
    private enum NotificationSettingsAction: SettingsAction {
        case edit
        case new
        case bool
    }
    
    private enum BooleanAction: Int {
        case none
    }
}
