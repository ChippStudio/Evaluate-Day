//
//  SettingsPasscodeDelayViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class SettingsPasscodeDelayViewController: UIViewController, ASTableDataSource, ASTableDelegate {

    // MARK: - UI
    var tableNode: ASTableNode!
    
    // MARK: - Variables
    var require = [PasscodeDelay]()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set data
        self.require.append(.immediately)
        self.require.append(.one)
        self.require.append(.three)
        self.require.append(.five)
        self.require.append(.ten)
        self.require.append(.thirty)
        self.require.append(.hour)

        // set table node
        self.tableNode = ASTableNode(style: .grouped)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.view.addSubnode(self.tableNode)
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
        return 1
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.require.count
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let item = self.require[indexPath.row]
        var requireString = ""
        switch item {
        case .immediately:
            requireString = Localizations.Settings.Passcode.Delay.immediately
        case .one:
            requireString = Localizations.Settings.Passcode.Delay._1m
        case .hour:
            requireString = Localizations.Settings.Passcode.Delay._1h
        default:
            requireString = Localizations.Settings.Passcode.Delay.minutes("\(item.rawValue)")
        }
        
        let style = Themes.manager.settingsStyle
        let selView = UIView()
        selView.backgroundColor = style.settingsSelectColor
        let separatorInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
        
        let selected = item == Database.manager.application.settings.passcodeDelay
        
        return {
            let node = SettingsSelectNode(title: requireString, subtitle: nil, image: nil, style: style)
            node.select = selected
            node.backgroundColor = style.settingsSectionBackground
            node.selectedBackgroundView = selView
            node.separatorInset = separatorInsets
            return node
        }
    }

    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        let oldIndexPath = IndexPath(row: self.require.index(of: Database.manager.application.settings.passcodeDelay)!, section: 0)
        let oldNode = self.tableNode.nodeForRow(at: oldIndexPath) as! SettingsSelectNode
        let node = self.tableNode.nodeForRow(at: indexPath) as! SettingsSelectNode
        
        UIView.animate(withDuration: 0.2) {
            oldNode.select = false
            node.select = true
        }
        
        try! Database.manager.app.write {
            Database.manager.application.settings.passcodeDelay = self.require[indexPath.row]
        }
        
        sendEvent(.setPasscodeDelay, withProperties: ["duration": self.require[indexPath.row].rawValue])
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
}
