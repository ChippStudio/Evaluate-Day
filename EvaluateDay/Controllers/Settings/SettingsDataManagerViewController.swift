//
//  SettingsDataManagerViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 05/04/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import CloudKit

class SettingsDataManagerViewController: UIViewController, ASTableDataSource, ASTableDelegate {

    // MARK: - UI
    var tableNode: ASTableNode!
    
    // MARK: - Variables
    var settings = [SettingsSection]()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation Item
        self.navigationItem.title = Localizations.Settings.Sync.Data.title
        
        // set table node
        self.tableNode = ASTableNode(style: .grouped)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.view.addSubnode(self.tableNode)
        
        sendEvent(.openDataManager, withProperties: nil)
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
                    switchButton.isEnabled = Store.current.isPro
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
        switch item.action as! DataManagerSettingsAction {
        case .deleteCloud:
            let alert = UIAlertController(title: Localizations.General.sureQuestion, message: Localizations.Settings.Sync.Data.Cloud.deleteDescription, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: Localizations.General.cancel, style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: Localizations.General.delete, style: .destructive) { (_) in
                let container = CKContainer.default()
                container.privateCloudDatabase.fetchAllRecordZones(completionHandler: { (zones, error) in
                    guard let zones = zones, error == nil else {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    let zoneIDs = zones.map { $0.zoneID }
                    let deletionOperation = CKModifyRecordZonesOperation(recordZonesToSave: nil, recordZoneIDsToDelete: zoneIDs)
                    deletionOperation.modifyRecordZonesCompletionBlock = { _, deletedZones, error in
                        guard error == nil else {
                            print(error!.localizedDescription)
                            let alert = UIAlertController(title: Localizations.Messages.Data.Cloud.DeleteAll.error, message: error!.localizedDescription, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: Localizations.General.ok, style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        
                        OperationQueue.main.addOperation {
                            print("Records successfully deleted in this zone.")
                            try! Database.manager.app.write {
                                Database.manager.application.settings.enableSync = false
                            }
                            if let node = self.tableNode.nodeForRow(at: IndexPath(row: 0, section: 0)) as? SettingsBooleanNode {
                                node.switchButton.isEnabled = false
                            }
                            (UIApplication.shared.delegate as! AppDelegate).syncEngine.stopSync()
                            Feedback.player.play(sound: .deleteCard, feedbackType: .success)
                    
                            let alert = UIAlertController(title: Localizations.Messages.Data.Cloud.DeleteAll.title, message: Localizations.Messages.Data.Cloud.DeleteAll.subtitle, preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: Localizations.General.ok, style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        }
                    }
                    
                    sendEvent(.deleteAllCardsInCloud, withProperties: nil)
                    container.privateCloudDatabase.add(deletionOperation)
                })
            }
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
        
            if self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                let node = self.tableNode.nodeForRow(at: indexPath) as! SettingsMoreNode
                alert.popoverPresentationController?.sourceRect = node.title.frame
                alert.popoverPresentationController?.sourceView = node.view
            }
        
            alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
            alert.view.layoutIfNeeded()
            self.present(alert, animated: true) {
                alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
            }
        case .deleteLocal:
            let alert = UIAlertController(title: Localizations.General.sureQuestion, message: Localizations.Settings.Sync.Data.Local.deleteDescription, preferredStyle: .actionSheet)
        
            let cancelAction = UIAlertAction(title: Localizations.General.cancel, style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: Localizations.General.delete, style: .destructive) { (_) in
                let cards = Database.manager.data.objects(Card.self).filter("isDeleted=%@", false)
                for card in cards {
                    sendEvent(.deleteCard, withProperties: ["type": card.type.string])
                    try! Database.manager.data.write {
                        card.data.deleteValues()
                        card.isDeleted = true
                    }
                }
                
                Feedback.player.play(sound: .deleteCard, feedbackType: .success)
                sendEvent(.deleteAllCards, withProperties: nil)
                
                let alert = UIAlertController(title: Localizations.Messages.Data.Local.DeleteAll.title, message: Localizations.Messages.Data.Local.DeleteAll.subtitle, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: Localizations.General.ok, style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
        
            if self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                let node = self.tableNode.nodeForRow(at: indexPath) as! SettingsMoreNode
                alert.popoverPresentationController?.sourceRect = node.title.frame
                alert.popoverPresentationController?.sourceView = node.view
            }
        
            alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
            alert.view.layoutIfNeeded()
            self.present(alert, animated: true) {
                alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
            }
        case .export:
            // Export all data
            let fileName = "data.txt"
            let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
            
            let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
            let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
            let iosVersion = UIDevice.current.systemVersion
            let cards = Database.manager.data.objects(Card.self).filter("isDeleted=%@", false)
            
            var txtText = "Evaluate Day \(build) (\(version)) iOS \(iosVersion)\n"
            
            for card in cards {
                txtText.append("\n\n")
                var archived = ""
                if card.archived {
                    archived = "(\(Localizations.Activity.Analytics.Stat.archived))"
                }
                txtText.append(card.title + archived + "\n")
                let cardText = card.data.textExport()
                txtText.append(cardText)
            }
            
            do {
                try txtText.write(to: path!, atomically: false, encoding: String.Encoding.utf8)
            } catch {
                return
            }
            
            // Open share activity
            let vc = UIActivityViewController(activityItems: [path!], applicationActivities: nil)
            let indexPath = IndexPath(row: 0, section: 2)
            if self.view.traitCollection.userInterfaceIdiom == .pad {
                if let node = self.tableNode.nodeForRow(at: indexPath) {
                    vc.popoverPresentationController?.sourceRect = node.frame
                    vc.popoverPresentationController?.sourceView = node.view
                } else {
                    vc.popoverPresentationController?.sourceRect = self.tableNode.frame
                    vc.popoverPresentationController?.sourceView = self.view
                }
            }
            
            self.present(vc, animated: true, completion: nil)
        case .bool: ()
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
    
    // MARK: - Actions
    @objc func booleanAction(sender: UISwitch) {
        if let action = BooleanAction(rawValue: sender.tag) {
            switch action {
            case .enableSync:
                try! Database.manager.app.write {
                    Database.manager.application.settings.enableSync = sender.isOn
                }
                
                if sender.isOn {
                    (UIApplication.shared.delegate as! AppDelegate).syncEngine.startSync()
                } else {
                    (UIApplication.shared.delegate as! AppDelegate).syncEngine.stopSync()
                }
            }
        }
    }
    
    // MARK: - Private
    private func setSettings() {
        self.settings.removeAll()
        
        // iCloud
        let enableSync = SettingItem(title: Localizations.Settings.Sync.Data.Cloud.enable, type: .boolean, action: DataManagerSettingsAction.bool, options: ["isOn": Database.manager.application.settings.enableSync, "action": BooleanAction.enableSync.rawValue])
        let deleteCloudData = SettingItem(title: Localizations.Settings.Sync.Data.Cloud.delete, type: .more, action: DataManagerSettingsAction.deleteCloud)
        let cloudSection = SettingsSection(items: [enableSync, deleteCloudData], header: Localizations.Settings.Sync.Data.Cloud.header, footer: nil)
        
        // Local
        let deleteLocal = SettingItem(title: Localizations.Settings.Sync.Data.Local.delete, type: .more, action: DataManagerSettingsAction.deleteLocal)
        let localSection = SettingsSection(items: [deleteLocal], header: Localizations.Settings.Sync.Data.Local.header, footer: nil)
        
        // Export
        let exportAll = SettingItem(title: Localizations.Settings.Sync.Data.Export.export, type: .more, action: DataManagerSettingsAction.export)
        let exportSection = SettingsSection(items: [exportAll], header: Localizations.Settings.Sync.Data.Export.header, footer: nil)
        
        // Analytics
        
        self.settings.append(cloudSection)
        self.settings.append(localSection)
        self.settings.append(exportSection)
        
        if self.tableNode != nil {
            self.tableNode.reloadData()
        }
    }
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
            
            // Table node
            if self.tableNode != nil {
                self.tableNode.reloadData()
            }
        })
    }
    
    private enum DataManagerSettingsAction: SettingsAction {
        case deleteCloud
        case deleteLocal
        case export
        case bool
    }
    
    private enum BooleanAction: Int {
        case enableSync
    }
}
