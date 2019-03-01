//
//  SettingsPasscodeViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 27/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import LocalAuthentication

class SettingsPasscodeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variable
    var settings = [SettingsSection]()
    
    private let delaySegue = "delaySegue"
    
    private let booleanCell = "booleanCell"
    private let moreCell = "moreCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation item
        self.navigationItem.title = Localizations.Settings.Passcode.title
        
        // Analytics
        sendEvent(.openPasscode, withProperties: nil)
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
            
            // TableView
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
        switch item.action as! PasscodeSettingsAction {
        case .delay:
            self.performSegue(withIdentifier: self.delaySegue, sender: self)
        case .bool:
            print("Ne nado ne chego tut delat")
        }
    }

    // MARK: - Actions
    @objc func booleanAction(sender: UISwitch) {
        if let action = BooleanAction(rawValue: sender.tag) {
            try! Database.manager.app.write {
                switch action {
                case .passcode:
                    if sender.isOn && !Store.current.isPro {
                        let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
                        self.navigationController?.pushViewController(controller, animated: true)
                    } else {
                        let controller = UIStoryboard(name: Storyboards.passcode.rawValue, bundle: nil).instantiateInitialViewController()!
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                case .biometrics:
                    Database.manager.application.settings.passcodeBiometric = sender.isOn
                case .promptBiometrics:
                    Database.manager.application.settings.passcodePromptBiometric = sender.isOn
                }
            }
        }
    }
    
    // MARK: - Private
    private func setSettings() {
        self.settings.removeAll()
        
        var passcodeSection = SettingsSection(items: [])
        
        let pass = Database.manager.application.settings.passcode
        let passcodeItem = SettingItem(title: Localizations.Settings.Passcode.title, type: .boolean, action: PasscodeSettingsAction.bool, image: Images.Media.passcode.image, options: ["isOn": pass, "action": BooleanAction.passcode.rawValue])
        passcodeSection.items.append(passcodeItem)
        
        if pass {
            var requireString = ""
            switch Database.manager.application.settings.passcodeDelay {
            case .immediately:
                requireString = Localizations.Settings.Passcode.Delay.immediately
            case .one:
                requireString = Localizations.Settings.Passcode.Delay._1m
            case .hour:
                requireString = Localizations.Settings.Passcode.Delay._1h
            default:
                requireString = Localizations.Settings.Passcode.Delay.minutes("\(Database.manager.application.settings.passcodeDelay.rawValue)")
            }
            let requireItem = SettingItem(title: Localizations.Settings.Passcode.require, type: .more, action: PasscodeSettingsAction.delay, subtitle: requireString, image: Images.Media.passcode.image)
            passcodeSection.items.append(requireItem)
            
            var error: NSError?
            let context = LAContext()
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                var biometricString: String = ""
                var promptBiometricString: String = ""
                if #available(iOS 11.0, *) {
                    if context.biometryType == .faceID {
                        biometricString = Localizations.Settings.Passcode.FaceID.title
                        promptBiometricString = Localizations.Settings.Passcode.FaceID.prompt
                    } else if context.biometryType == .touchID {
                        biometricString = Localizations.Settings.Passcode.TouchID.title
                        promptBiometricString = Localizations.Settings.Passcode.TouchID.prompt
                    }
                } else {
                    biometricString = Localizations.Settings.Passcode.TouchID.title
                    promptBiometricString = Localizations.Settings.Passcode.TouchID.prompt
                }
                
                let biometricItem = SettingItem(title: biometricString, type: .boolean, action: PasscodeSettingsAction.bool, image: Images.Media.passcode.image, options: ["isOn": Database.manager.application.settings.passcodeBiometric, "action": BooleanAction.biometrics.rawValue])
                let promtBiometricItem = SettingItem(title: promptBiometricString, type: .boolean, action: PasscodeSettingsAction.bool, image: Images.Media.passcode.image, options: ["isOn": Database.manager.application.settings.passcodePromptBiometric, "action": BooleanAction.promptBiometrics.rawValue])
                
                passcodeSection.items.append(biometricItem)
                passcodeSection.items.append(promtBiometricItem)
            }
            
        }
        
        self.settings.append(passcodeSection)
        
        self.tableView.reloadData()
    }
    
    private enum PasscodeSettingsAction: SettingsAction {
        case delay
        case bool
    }
    
    private enum BooleanAction: Int {
        case passcode
        case biometrics
        case promptBiometrics
    }
}
