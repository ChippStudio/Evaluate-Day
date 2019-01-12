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

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate, MFMailComposeViewControllerDelegate {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    var footerView = SettingsFooterView()
    
    // MARK: - Variables
    var settings = [SettingsSection]()
    
    // MARK: - Cells
    private var moreCell = "moreCell"
    private var booleanCell = "booleanCell"
    
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
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.title = Localizations.Settings.title
        self.navigationController?.navigationBar.accessibilityIdentifier = "settingsNavigationBar"
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        // Set table view
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.tableFooterView = self.footerView
        self.tableView.accessibilityIdentifier = "settingsTableView"
        
        if self.popoverPresentationController != nil {
            self.preferredContentSize = CGSize(width: 360.0, height: 600.0)
        }
        
        self.setSettings()
        
        // Analytics
        sendEvent(.openSettings, withProperties: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAppearance(animated: false)
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
            
            // TableView
            self.tableView.backgroundColor = UIColor.background
            
            self.footerView.backgroundColor = UIColor.background
            self.footerView.appIcon.tintColor = UIColor.main
            self.footerView.appTitle.textColor = UIColor.text
            self.footerView.appVersion.textColor = UIColor.text
            self.footerView.appTitle.font = UIFont.preferredFont(forTextStyle: .title2)
            self.footerView.appVersion.font = UIFont.preferredFont(forTextStyle: .body)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
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
        selView.layer.cornerRadius = 5.0
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
            return cell
        case .boolean:
            let cell = tableView.dequeueReusableCell(withIdentifier: booleanCell, for: indexPath) as! SwitchCell
            cell.switchControl.isOn = item.options!["isOn"] as! Bool
            cell.switchControl.tag = (item.options!["action"] as! Int)
            cell.switchControl.addTarget(self, action: #selector(self.booleanAction(sender:)), for: .valueChanged)
            cell.switchControl.onTintColor = UIColor.positive
            cell.selectionStyle = .none
            cell.iconImage.image = item.image?.resizedImage(newSize: CGSize(width: 26.0, height: 26.0)).withRenderingMode(.alwaysTemplate)
            cell.iconImage.tintColor = UIColor.main
            cell.titleLabel.text = item.title
            cell.titleLabel.textColor = UIColor.text
            return cell
        case .notification:
            return UITableViewCell()
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        header.textLabel?.textColor = UIColor.text
        header.textLabel!.font = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    // MARK: - SFSafariViewControllerDelegate
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        
    }
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Swift.Error?) {
        
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
            mailView.setSubject(Localizations.Settings.Support.Mail.subject)
            var pro = 0
            if Database.manager.application.user.pro {
                pro = 1
            }
            let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String + "(\(pro))"
            let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
            let iosVersion = UIDevice.current.systemVersion
            mailView.setMessageBody(Localizations.Settings.Support.Mail.body(build, version, iosVersion), isHTML: false)
            mailView.setToRecipients([feedbackMail])
            self.present(mailView, animated: true, completion: {
            })
        } else {
            let alert = UIAlertController(title: Localizations.Settings.Support.MailError.title, message: Localizations.Settings.Support.MailError.message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: Localizations.General.ok, style: .default, handler: nil)
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
        self.present(safari, animated: true, completion: nil)
    }
    
    func openWelcome() {
        let controller = UIStoryboard(name: Storyboards.onboarding.rawValue, bundle: nil).instantiateViewController(withIdentifier: "slidesViewController")
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Private
    private func setSettings() {
        self.settings.removeAll()
        
        // SYNC
        var syncString = Localizations.Settings.Sync.never
        if Database.manager.application.sync.lastSyncDate != nil {
            syncString = DateFormatter.localizedString(from: Database.manager.application.sync.lastSyncDate!, dateStyle: .short, timeStyle: .short)
        }
        let lastSyncItem = SettingItem(title: Localizations.Settings.Sync.last, type: .more, action: MainSettingsAction.sync, subtitle: syncString, image: #imageLiteral(resourceName: "sync"))
        let syncDataManage = SettingItem(title: Localizations.Settings.Sync.Data.title, type: .more, action: MainSettingsAction.syncData, image: #imageLiteral(resourceName: "data"))
        let syncSection = SettingsSection(items: [lastSyncItem, syncDataManage], header: Localizations.Settings.Sync.title, footer: nil)
        self.settings.append(syncSection)
        
        // Themes
        let themesItem = SettingItem(title: Localizations.Settings.Themes.Select.theme, type: .more, action: MainSettingsAction.themes, image: #imageLiteral(resourceName: "themes"))
        let selectIcon = SettingItem(title: Localizations.Settings.Themes.Select.icon, type: .more, action: MainSettingsAction.icons, image: #imageLiteral(resourceName: "app"))
        var items = [themesItem]
        if #available(iOS 10.3, *) {
            if UIApplication.shared.supportsAlternateIcons {
                items.append(selectIcon)
            }
        }
        let themeSection = SettingsSection(items: items, header: Localizations.Settings.Themes.title, footer: nil)
        self.settings.append(themeSection)
        
        // General
        let notificationItem = SettingItem(title: Localizations.Settings.Notifications.title, type: .more, action: MainSettingsAction.notification, subtitle: "\(Database.manager.application.notifications.count)", image: #imageLiteral(resourceName: "notification"))
        let weekItem = SettingItem(title: Localizations.Settings.General.week, type: .more, action: MainSettingsAction.week, subtitle: nil, image: #imageLiteral(resourceName: "week"))
        let photoItem = SettingItem(title: Localizations.Settings.General.photos, type: .boolean, action: MainSettingsAction.bool, image: #imageLiteral(resourceName: "cameraRoll"), options: ["isOn": Database.manager.application.settings.cameraRoll, "action": BooleanAction.photo.rawValue])
        let celsiousItem = SettingItem(title: Localizations.Settings.General.celsius, type: .boolean, action: MainSettingsAction.bool, image: #imageLiteral(resourceName: "celsius"), options: ["isOn": Database.manager.application.settings.celsius, "action": BooleanAction.celcius.rawValue])
        let soundItem = SettingItem(title: Localizations.Settings.General.sounds, type: .boolean, action: MainSettingsAction.bool, image: #imageLiteral(resourceName: "sound"), options: ["isOn": Database.manager.application.settings.sound, "action": BooleanAction.sound.rawValue])
        let passcodeItem = SettingItem(title: Localizations.Settings.Passcode.title, type: .more, action: MainSettingsAction.passcode, subtitle: nil, image: #imageLiteral(resourceName: "passcode"), options: nil)
        let generalSection = SettingsSection(items: [notificationItem, passcodeItem, weekItem, photoItem, celsiousItem, soundItem], header: Localizations.Settings.General.title, footer: nil)
        self.settings.append(generalSection)
        
        // Support
        let faqItem = SettingItem(title: Localizations.Settings.Support.faq, type: .more, action: MainSettingsAction.faq, subtitle: nil, image: #imageLiteral(resourceName: "faq"), options: nil)
        let supportItem = SettingItem(title: Localizations.Settings.Support.title, type: .more, action: MainSettingsAction.support, subtitle: nil, image: #imageLiteral(resourceName: "support"), options: nil)
        let supportSection = SettingsSection(items: [faqItem, supportItem], header: Localizations.Settings.Support.title, footer: nil)
        self.settings.append(supportSection)
        
        // About
        let aboutItem = SettingItem(title: Localizations.Settings.About.title, type: .more, action: MainSettingsAction.about, subtitle: nil, image: #imageLiteral(resourceName: "app"), options: nil)
        let rateItem = SettingItem(title: Localizations.Settings.About.rate, type: .more, action: MainSettingsAction.rate, subtitle: "⭐️⭐️⭐️⭐️⭐️", image: #imageLiteral(resourceName: "appStore"), options: nil)
        let welcomeItem = SettingItem(title: Localizations.Settings.About.welcome, type: .more, action: MainSettingsAction.welcome, subtitle: nil, image: #imageLiteral(resourceName: "cards"), options: nil)
        let evaluateDaySection = SettingsSection(items: [aboutItem, rateItem, welcomeItem], header: Localizations.General.evaluateday, footer: nil)
        self.settings.append(evaluateDaySection)
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
