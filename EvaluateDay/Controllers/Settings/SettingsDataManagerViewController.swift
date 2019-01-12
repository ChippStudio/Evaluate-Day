//
//  SettingsDataManagerViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 05/04/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import CloudKit

class SettingsDataManagerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var settings = [SettingsSection]()
    
    private var moreCell = "moreCell"
    private var booleanCell = "booleanCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation Item
        self.navigationItem.title = Localizations.Settings.Sync.Data.title
        
        sendEvent(.openDataManager, withProperties: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setSettings()
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
            
            // tableView
            self.tableView.backgroundColor = UIColor.background
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
                            if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SwitchCell {
                                cell.switchControl.isEnabled = false
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
                let cell = self.tableView.cellForRow(at: indexPath)!
                alert.popoverPresentationController?.sourceRect = cell.textLabel!.frame
                alert.popoverPresentationController?.sourceView = cell
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
                let cell = self.tableView.cellForRow(at: indexPath)!
                alert.popoverPresentationController?.sourceRect = cell.textLabel!.frame
                alert.popoverPresentationController?.sourceView = cell
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
                if let cell = self.tableView.cellForRow(at: indexPath) {
                    vc.popoverPresentationController?.sourceRect = cell.frame
                    vc.popoverPresentationController?.sourceView = cell
                } else {
                    vc.popoverPresentationController?.sourceRect = self.tableView.frame
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
        footer.textLabel?.textColor = UIColor.text
        footer.textLabel?.font = UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.text
        header.textLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
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
        let enableSync = SettingItem(title: Localizations.Settings.Sync.Data.Cloud.enable, type: .boolean, action: DataManagerSettingsAction.bool, image: Images.Media.sync.image, options: ["isOn": Database.manager.application.settings.enableSync, "action": BooleanAction.enableSync.rawValue])
        let deleteCloudData = SettingItem(title: Localizations.Settings.Sync.Data.Cloud.delete, type: .more, action: DataManagerSettingsAction.deleteCloud, image: Images.Media.deleteBoard.image)
        let cloudSection = SettingsSection(items: [enableSync, deleteCloudData], header: Localizations.Settings.Sync.Data.Cloud.header, footer: nil)
        
        // Local
        let deleteLocal = SettingItem(title: Localizations.Settings.Sync.Data.Local.delete, type: .more, action: DataManagerSettingsAction.deleteLocal, image: Images.Media.deleteBoard.image)
        let localSection = SettingsSection(items: [deleteLocal], header: Localizations.Settings.Sync.Data.Local.header, footer: nil)
        
        // Export
        let exportAll = SettingItem(title: Localizations.Settings.Sync.Data.Export.export, type: .more, action: DataManagerSettingsAction.export, image: Images.Media.exportBoard.image)
        let exportSection = SettingsSection(items: [exportAll], header: Localizations.Settings.Sync.Data.Export.header, footer: nil)
        
        self.settings.append(cloudSection)
        self.settings.append(localSection)
        self.settings.append(exportSection)
        
        self.tableView.reloadData()
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
