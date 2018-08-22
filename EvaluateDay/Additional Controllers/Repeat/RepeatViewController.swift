//
//  RepeatViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 30/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class RepeatViewController: UIViewController, ASTableDataSource, ASTableDelegate {

    // MARK: - UI
    var tableNode: ASTableNode!
    
    // MARK: - Variable
    var didSetNewRepeatInterval: (() -> Void)?
    var notification: LocalNotification! {
        didSet {
            self.weekdays.removeAll()
            for w in notification.repeatNotification {
                if w == "1" {
                    self.weekdays.append(true)
                } else {
                    self.weekdays.append(false)
                }
            }
        }
    }
    private var weekdays = [Bool]()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = Localizations.settings.notifications.new._repeat.title

        // Set table node
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
        
        self.tableNode.frame = self.view.bounds
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.observable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        var weekdaysMask = ""
        for w in self.weekdays {
            if w {
                weekdaysMask += "1"
            } else {
                weekdaysMask += "0"
            }
        }
        
        if self.notification.realm == nil {
            self.notification.repeatNotification = weekdaysMask
        } else {
            try! Database.manager.app.write {
                self.notification.repeatNotification = weekdaysMask
            }
        }
        
        self.didSetNewRepeatInterval?()
    }
    
    // MARK: - ASTableDataSource
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        
        return 7
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let style = Themes.manager.settingsStyle
        let selView = UIView()
        selView.backgroundColor = style.settingsSelectColor
        let separatorInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
        var title = ""
        var isSelected = false
        if indexPath.section == 0 {
            title = Locale.current.calendar.standaloneWeekdaySymbols[indexPath.row]
            isSelected = self.weekdays[indexPath.row]
        }
        
        return {
            let node = SettingsSelectNode(title: title, subtitle: nil, image: nil, style: style)
            node.select = isSelected
            node.backgroundColor = style.settingsSectionBackground
            node.selectedBackgroundView = selView
            node.separatorInset = separatorInsets
            
            return node
        }
    }
    
    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let temp = self.weekdays[indexPath.row]
            self.weekdays.remove(at: indexPath.row)
            self.weekdays.insert(!temp, at: indexPath.row)
        }
        
        self.tableNode.reloadSections([0], with: .fade)
        
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
            
            // Table node
            self.tableNode.reloadData()
        })
    }
}
