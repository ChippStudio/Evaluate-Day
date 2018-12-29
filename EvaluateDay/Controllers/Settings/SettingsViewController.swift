//
//  SettingsViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import SafariServices
import MessageUI

class SettingsViewController: UIViewController, ASTableDataSource, ASTableDelegate, SFSafariViewControllerDelegate, MFMailComposeViewControllerDelegate {

    // MARK: - UI
    var tableNode: ASTableNode!
    var footerView = SettingsFooterView()
    
    // MARK: - Variables
    var settings = [SettingsSection]()
    
    // MARK: - Segues
    private let userSegue = "userSegue"
    private let themesSegue = "themesSegue"
    private let iconsSegue = "iconsSegue"
    private let notificationSegue = "notificationSegue"
    private let passcodeSegue = "passcodeSegue"
    private let weekSegue = "weekSegue"
    private let aboutSegue = "aboutSegue"
    private let dataManagerSegue = "dataManagerSegue"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        self.navigationItem.title = Localizations.settings.title
        self.navigationController?.navigationBar.accessibilityIdentifier = "settingsNavigationBar"
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        // Set table node
        self.tableNode = ASTableNode(style: .grouped)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.tableNode.accessibilityIdentifier = "settingsTableView"
        self.tableNode.shouldGroupAccessibilityChildren = true
        self.tableNode.view.separatorStyle = .none
        self.view.addSubnode(self.tableNode)
        
        self.tableNode.view.tableFooterView = self.footerView
        self.tableNode.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 70.0, right: 0.0)
        
        if self.popoverPresentationController != nil {
            self.preferredContentSize = CGSize(width: 360.0, height: 600.0)
        }
        
        self.setSettings()
        self.observable()
        
        // Analytics
        sendEvent(.openSettings, withProperties: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableNode.frame = self.view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setSettings()
//        self.observable()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
                return ASCellNode()
            }
        }
    }

    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        let item = self.settings[indexPath.section].items[indexPath.row]
        switch item.action as! MainSettingsAction {
        case .pro:
            self.proAction()
        case .themes:
            self.openController(id: self.themesSegue)
        case .icons:
            self.openController(id: self.iconsSegue)
        case .notification:
            self.openController(id: self.notificationSegue)
        case .sync:
            (UIApplication.shared.delegate as! AppDelegate).syncEngine.startSync()
        case .syncData:
            self.openController(id: self.dataManagerSegue )
        case .about:
            self.openController(id: self.aboutSegue)
        case .week:
            self.openController(id: self.weekSegue)
        case .faq:
            sendEvent(.openFAQ, withProperties: nil)
            self.openURL("http://evaluateday.com")
        case .support:
            sendEvent(.openSupport, withProperties: nil)
            self.openSupport()
        case .passcode:
            self.openController(id: self.passcodeSegue)
        case .bool:
            print("Ne nado ne chego tut delat")
        case .rate:
            sendEvent(.touchRateInAppStore, withProperties: nil)
            let url = URL(string: appURLString)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        case .welcome:
            sendEvent(.openWelcomeCards, withProperties: nil)
            self.openWelcome()
        }
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
    
    // MARK: - SFSafariViewControllerDelegate
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        UIApplication.shared.statusBarStyle = Themes.manager.settingsStyle.statusBarStyle
    }
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Swift.Error?) {
        UIApplication.shared.statusBarStyle = Themes.manager.settingsStyle.statusBarStyle
        if error != nil {
            print(error!.localizedDescription)
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
    @objc func booleanAction(sender: UISwitch) {
        if let action = BooleanAction(rawValue: sender.tag) {
            try! Database.manager.app.write {
                switch action {
                    case .celcius:
                        Database.manager.application.settings.celsius = sender.isOn
                        sendEvent(.setCelsius, withProperties: ["value": sender.isOn])
                    case .sound:
                        Database.manager.application.settings.sound = sender.isOn
                        sendEvent(.setSounds, withProperties: ["value": sender.isOn])
                    case .photo:
                        Database.manager.application.settings.cameraRoll = sender.isOn
                        sendEvent(.setCameraRoll, withProperties: ["value": sender.isOn])
                }
            }
            
        }
    }
    
    func proAction() {
        let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
        self.openController(controller: controller)
    }
    
    func openSupport() {
        if MFMailComposeViewController.canSendMail() {
            let mailView = MFMailComposeViewController()
            mailView.mailComposeDelegate = self
            mailView.navigationBar.tintColor = Themes.manager.settingsStyle.safariTintColor
            mailView.setSubject(Localizations.settings.support.mail.subject)
            var pro = 0
            if Database.manager.application.user.pro {
                pro = 1
            }
            let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String + "(\(pro))"
            let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
            let iosVersion = UIDevice.current.systemVersion
            mailView.setMessageBody(Localizations.settings.support.mail.body(value1: build, version, iosVersion), isHTML: false)
            mailView.setToRecipients([feedbackMail])
            self.present(mailView, animated: true, completion: {
                UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
            })
        } else {
            let alert = UIAlertController(title: Localizations.settings.support.mailError.title, message: Localizations.settings.support.mailError.message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: Localizations.general.ok, style: .default, handler: nil)
            alert.addAction(okAction)
            
            alert.view.tintColor = Themes.manager.settingsStyle.safariTintColor
            alert.view.layoutIfNeeded()
            self.present(alert, animated: true) {
                alert.view.tintColor = Themes.manager.settingsStyle.safariTintColor
            }
        }
    }
    
    func openURL(_ url: String) {
        let safari = SFSafariViewController(url: URL(string: url)!)
        safari.preferredControlTintColor = Themes.manager.settingsStyle.safariTintColor
        safari.delegate = self
        UIApplication.shared.statusBarStyle = .default
        self.present(safari, animated: true, completion: nil)
    }
    
    func openWelcome() {
        let controller = UIStoryboard(name: Storyboards.onboarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: "slidesViewController")
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Private
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            
            UIView.animate(withDuration: 0.2, animations: {
                let style = Themes.manager.settingsStyle
                
                //set NavigationBar
                self.navigationController?.view.backgroundColor = style.background
                self.navigationController?.navigationBar.barTintColor = style.barColor
                self.navigationController?.navigationBar.isTranslucent = false
                self.navigationController?.navigationBar.shadowImage = UIImage()
                self.navigationController?.navigationBar.tintColor = style.barTint
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
                
                self.footerView.backgroundColor = style.background
                self.footerView.appIcon.tintColor = style.footerTintColor
                self.footerView.appTitle.textColor = style.footerTintColor
                self.footerView.appVersion.textColor = style.footerTintColor
                self.footerView.appTitle.font = style.footerTitleFont
                self.footerView.appVersion.font = style.footerVersionFont
            })
            
            self.tableNode.reloadData()
        })
    }
    
    private func setSettings() {
        self.settings.removeAll()
        
        // PRO
        let proItem = SettingItem(title: "pro", type: .pro, action: MainSettingsAction.pro, options: ["isPro": true])
        let proSection = SettingsSection(items: [proItem])
        self.settings.append(proSection)
        
        // SYNC
        var syncString = Localizations.settings.sync.never
        if Database.manager.application.sync.lastSyncDate != nil {
            syncString = DateFormatter.localizedString(from: Database.manager.application.sync.lastSyncDate!, dateStyle: .short, timeStyle: .short)
        }
        let lastSyncItem = SettingItem(title: Localizations.settings.sync.last, type: .more, action: MainSettingsAction.sync, subtitle: syncString, image: #imageLiteral(resourceName: "sync"))
        let syncDataManage = SettingItem(title: Localizations.settings.sync.data.title, type: .more, action: MainSettingsAction.syncData, image: #imageLiteral(resourceName: "data"))
        let syncSection = SettingsSection(items: [lastSyncItem, syncDataManage], header: Localizations.settings.sync.title, footer: nil)
        self.settings.append(syncSection)
        
        // Themes
        let themesItem = SettingItem(title: Localizations.settings.themes.select.theme, type: .more, action: MainSettingsAction.themes, image: #imageLiteral(resourceName: "themes"))
        let selectIcon = SettingItem(title: Localizations.settings.themes.select.icon, type: .more, action: MainSettingsAction.icons, image: #imageLiteral(resourceName: "app"))
        var items = [themesItem]
        if #available(iOS 10.3, *) {
            if UIApplication.shared.supportsAlternateIcons {
                items.append(selectIcon)
            }
        }
        let themeSection = SettingsSection(items: items, header: Localizations.settings.themes.title, footer: nil)
        self.settings.append(themeSection)
        
        // General
        let notificationItem = SettingItem(title: Localizations.settings.notifications.title, type: .more, action: MainSettingsAction.notification, subtitle: "\(Database.manager.application.notifications.count)", image: #imageLiteral(resourceName: "notification"))
        let weekItem = SettingItem(title: Localizations.settings.general.week, type: .more, action: MainSettingsAction.week, subtitle: nil, image: #imageLiteral(resourceName: "week"))
        let photoItem = SettingItem(title: Localizations.settings.general.photos, type: .boolean, action: MainSettingsAction.bool, image: #imageLiteral(resourceName: "cameraRoll"), options: ["isOn": Database.manager.application.settings.cameraRoll, "action": BooleanAction.photo.rawValue])
        let celsiousItem = SettingItem(title: Localizations.settings.general.celsius, type: .boolean, action: MainSettingsAction.bool, image: #imageLiteral(resourceName: "celsius"), options: ["isOn": Database.manager.application.settings.celsius, "action": BooleanAction.celcius.rawValue])
        let soundItem = SettingItem(title: Localizations.settings.general.sounds, type: .boolean, action: MainSettingsAction.bool, image: #imageLiteral(resourceName: "sound"), options: ["isOn": Database.manager.application.settings.sound, "action": BooleanAction.sound.rawValue])
        let passcodeItem = SettingItem(title: Localizations.settings.passcode.title, type: .more, action: MainSettingsAction.passcode, subtitle: nil, image: #imageLiteral(resourceName: "passcode"), options: nil)
        let generalSection = SettingsSection(items: [notificationItem, passcodeItem, weekItem, photoItem, celsiousItem, soundItem], header: Localizations.settings.general.title, footer: nil)
        self.settings.append(generalSection)
        
        // Support
        let faqItem = SettingItem(title: Localizations.settings.support.faq, type: .more, action: MainSettingsAction.faq, subtitle: nil, image: #imageLiteral(resourceName: "faq"), options: nil)
        let supportItem = SettingItem(title: Localizations.settings.support.title, type: .more, action: MainSettingsAction.support, subtitle: nil, image: #imageLiteral(resourceName: "support"), options: nil)
        let supportSection = SettingsSection(items: [faqItem, supportItem], header: Localizations.settings.support.title, footer: nil)
        self.settings.append(supportSection)
        
        // About
        let aboutItem = SettingItem(title: Localizations.settings.about.title, type: .more, action: MainSettingsAction.about, subtitle: nil, image: #imageLiteral(resourceName: "app"), options: nil)
        let rateItem = SettingItem(title: Localizations.settings.about.rate, type: .more, action: MainSettingsAction.rate, subtitle: "⭐️⭐️⭐️⭐️⭐️", image: #imageLiteral(resourceName: "appStore"), options: nil)
        let welcomeItem = SettingItem(title: Localizations.settings.about.welcome, type: .more, action: MainSettingsAction.welcome, subtitle: nil, image: #imageLiteral(resourceName: "cards"), options: nil)
        let evaluateDaySection = SettingsSection(items: [aboutItem, rateItem, welcomeItem], header: Localizations.general.evaluateday, footer: nil)
        self.settings.append(evaluateDaySection)
        
        OperationQueue.main.addOperation {
            if self.tableNode != nil {
                self.tableNode.reloadData()
            }
        }
    }
    
    private func openController(id: String) {
        self.performSegue(withIdentifier: id, sender: self)
    }
    
    private func openController(controller: UIViewController) {
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private enum MainSettingsAction: SettingsAction {
        case pro
        case week
        case themes
        case icons
        case notification
        case passcode
        case sync
        case syncData
        case about
        case faq
        case support
        case bool
        case rate
        case welcome
    }
    
    private enum BooleanAction: Int {
        case photo
        case celcius
        case sound
    }
}
