//
//  SettingsNotificationViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 27/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import UserNotifications

class SettingsNotificationViewController: UIViewController, ASTableDataSource, ASTableDelegate {

    // MARK: - UI
    var tableNode: ASTableNode!
    
    // MARK: - Variables
    var settings = [SettingsSection]()
    
    private let newNotification = "newNotification"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation item
        self.navigationItem.title = Localizations.settings.notifications.title
        
        // Set table node
        self.tableNode = ASTableNode(style: .grouped)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.view.addSubnode(self.tableNode)
        
        // Analytics
        sendEvent(.openNotification, withProperties: nil)
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
        self.setSettings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setSettings()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == newNotification {
            if self.tableNode.indexPathForSelectedRow != nil {
                if self.tableNode.indexPathForSelectedRow!.section != 0 {
                    let controller = segue.destination as! SettingsNewNotificationViewController
                    controller.notification = Database.manager.application.notifications[self.tableNode.indexPathForSelectedRow!.row]
                }
            }
        }
    }
    
    // MARK: - ASTableDataSource
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return self.settings.count
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.settings[section].items.count
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let style = Themes.manager.settingsStyle
        let item = self.settings[indexPath.section].items[indexPath.row]
        let selView = UIView()
        selView.backgroundColor = style.settingsSelectColor
        let separatorInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
        
        switch item.type {
        case .more:
            return {
                let node = SettingsMoreNode(title: item.title, subtitle: item.subtitle, image: item.image, style: style)
                node.backgroundColor = style.settingsSectionBackground
                node.selectedBackgroundView = selView
                node.separatorInset = separatorInsets
                return node
            }
        case .boolean:
            return {
                let node = SettingsBooleanNode(title: item.title, image: item.image, isOn: item.options!["isOn"] as! Bool, style: style)
                node.switchDidLoad = { (switchButton) in
                    switchButton.tag = (item.options!["action"] as! Int)
                    switchButton.addTarget(self, action: #selector(self.booleanAction(sender:)), for: .valueChanged)
                }
                node.backgroundColor = style.settingsSectionBackground
                node.selectedBackgroundView = selView
                node.separatorInset = separatorInsets
                return node
            }
        case .pro:
            let pro = Database.manager.application.user.pro
            return {
                let node = SettingsProNode(pro: pro, style: style)
                node.backgroundColor = style.settingsSectionBackground
                node.selectedBackgroundView = selView
                node.separatorInset = separatorInsets
                return node
            }
        case .notification:
            return {
                let node = SettingsNotificationNode(message: item.title, time: item.options!["time"] as! String, localizedRepeat: item.options!["repeat"] as! String, card: item.options!["card"] as! String, style: style)
                node.backgroundColor = style.settingsSectionBackground
                node.selectedBackgroundView = selView
                node.separatorInset = separatorInsets
                return node
            }
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

    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
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
        
        tableNode.deselectRow(at: indexPath, animated: true)
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
        let style = Themes.manager.settingsStyle
        footer.textLabel?.textColor = style.tableSectionFooterColor
        footer.textLabel!.font = style.tableSectionFooterFont
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        let style = Themes.manager.settingsStyle
        header.textLabel?.textColor = style.tableSectionHeaderColor
        header.textLabel!.font = style.tableSectionHeaderFont
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
    private func setSettings() {
        self.settings.removeAll()
        
        let addNewItem = SettingItem(title: Localizations.settings.notifications.add, type: .more, action: NotificationSettingsAction.new)
        let addNewSection = SettingsSection(items: [addNewItem])
        self.settings.append(addNewSection)
        
        if Permissions.defaults.notificationStatus == .authorized {
            var notificationsSection = SettingsSection(items: [], header: Localizations.settings.notifications.title, footer: nil)
            
            for n in Database.manager.application.notifications {
                var cardTitle = ""
                if n.cardID != nil {
                    if let card = Database.manager.data.objects(Card.self).filter("id=%@", n.cardID!).first {
                        cardTitle = card.title
                    }
                }
                
                let timeString = DateFormatter.localizedString(from: n.date, dateStyle: .none, timeStyle: .short)
                let localizedRepeat = n.localizedString
                
                let item = SettingItem(title: n.message, type: .notification, action: NotificationSettingsAction.edit, subtitle: nil, image: nil, options: ["time": timeString, "repeat": localizedRepeat, "card": cardTitle])
                notificationsSection.items.append(item)
            }
            
            if !notificationsSection.items.isEmpty {
                self.settings.append(notificationsSection)
            }
        }
        
        if self.tableNode != nil {
            self.tableNode.reloadData()
        }
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
