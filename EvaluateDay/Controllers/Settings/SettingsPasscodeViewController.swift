//
//  SettingsPasscodeViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 27/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import LocalAuthentication

class SettingsPasscodeViewController: UIViewController, ASTableDataSource, ASTableDelegate {

    // MARK: - UI
    var tableNode: ASTableNode!
    
    // MARK: - Variable
    var settings = [SettingsSection]()
    
    private let delaySegue = "delaySegue"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation item
        self.navigationItem.title = Localizations.Settings.Passcode.title
        
        // Set table node
        self.tableNode = ASTableNode(style: .grouped)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.view.addSubnode(self.tableNode)
        
        // Analytics
        sendEvent(.openPasscode, withProperties: nil)
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
        
        var passcodeSection = SettingsSection(items: [])
        
        let pass = Database.manager.application.settings.passcode
        let passcodeItem = SettingItem(title: Localizations.Settings.Passcode.title, type: .boolean, action: PasscodeSettingsAction.bool, options: ["isOn": pass, "action": BooleanAction.passcode.rawValue])
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
            let requireItem = SettingItem(title: Localizations.Settings.Passcode.require, type: .more, action: PasscodeSettingsAction.delay, subtitle: requireString)
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
                
                let biometricItem = SettingItem(title: biometricString, type: .boolean, action: PasscodeSettingsAction.bool, options: ["isOn": Database.manager.application.settings.passcodeBiometric, "action": BooleanAction.biometrics.rawValue])
                let promtBiometricItem = SettingItem(title: promptBiometricString, type: .boolean, action: PasscodeSettingsAction.bool, options: ["isOn": Database.manager.application.settings.passcodePromptBiometric, "action": BooleanAction.promptBiometrics.rawValue])
                
                passcodeSection.items.append(biometricItem)
                passcodeSection.items.append(promtBiometricItem)
            }
            
        }
        
        self.settings.append(passcodeSection)
        
        if self.tableNode != nil {
            self.tableNode.reloadData()
        }
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
