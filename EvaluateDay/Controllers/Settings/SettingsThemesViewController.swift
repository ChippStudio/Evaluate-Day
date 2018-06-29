//
//  SettingsThemesViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 27/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class SettingsThemesViewController: UIViewController, ASTableDataSource, ASTableDelegate {

    // MARK: - UI
    var tableNode: ASTableNode!
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation Item
        self.navigationItem.title = Localizations.settings.themes.select.theme
        
        // set table node
        self.tableNode = ASTableNode(style: .grouped)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.tableNode.view.separatorStyle = .none
        self.view.addSubnode(self.tableNode)
        
        // Analytics
        sendEvent(.openThemes, withProperties: nil)
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
    
    // MARK: - ASTableDataSource
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if #available(iOS 10.3, *) {
                if UIApplication.shared.supportsAlternateIcons {
                    return 1
                }
                return 0
            } else {
                // Fallback on earlier versions
                return 0
            }
            
        }
        
        return Themes.manager.all.count
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let style = Themes.manager.settingsStyle
        let selView = UIView()
        selView.backgroundColor = style.settingsSelectColor
        if indexPath.section == 0 {
            return {
                let node = SettingsBooleanNode(title: Localizations.settings.themes.iconChange, image: nil, isOn: Database.manager.application.settings.changeAppIcon, style: style)
                node.switchDidLoad = { (switchButton) in
                    switchButton.addTarget(self, action: #selector(self.booleanAction(sender:)), for: .valueChanged)
                }
                node.backgroundColor = style.settingsSectionBackground
                return node
            }
        }
        
        let item = Themes.manager.all[indexPath.row]
        return {
            let node = ThemeImageNode(image: item.previewImage)
            node.backgroundColor = style.settingsSectionBackground
            node.selectionStyle = .none
            return node
        }
    }
    
    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        
        if Themes.manager.current == Themes.manager.all[indexPath.row].type {
            return
        }
        
        let newType = Themes.manager.all[indexPath.row].type
        
        if !Store.current.isPro && newType != .light {
            let controler = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
            self.navigationController!.pushViewController(controler, animated: true)
            return
        }
        
        Themes.manager.current = newType
        if Database.manager.application.settings.changeAppIcon {
            if #available(iOS 10.3, *) {
                UIApplication.shared.setAlternateIconName(Themes.manager.all[indexPath.row].iconName, completionHandler: nil)
            }
        }
        
        sendEvent(.selectTheme, withProperties: ["theme": newType.string])
    }
    
    // MARK: - Action
    @objc func booleanAction(sender: UISwitch) {
        if !sender.isOn && Themes.manager.current != Themes.manager.all.first?.type {
            if #available(iOS 10.3, *) {
                UIApplication.shared.setAlternateIconName(nil, completionHandler: nil)
            }
        } else if sender.isOn {
            if let iconName = Themes.manager.currentTheme?.iconName {
                if #available(iOS 10.3, *) {
                    UIApplication.shared.setAlternateIconName(iconName, completionHandler: nil)
                }
            }
        }
        
        try! Database.manager.app.write {
            Database.manager.application.settings.changeAppIcon = sender.isOn
        }
        
        sendEvent(.setThemeIcon, withProperties: ["value": sender.isOn])
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
            if self.tableNode != nil {
                self.tableNode.reloadData()
            }
        })
    }
}
