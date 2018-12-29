//
//  DashboardsViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 04/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

private enum DashboardSettingsNodeType {
    case title
    case icons
}
class DashboardsViewController: UIViewController, ASTableDataSource, ASTableDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - UI
    var tableNode: ASTableNode!
    var saveButton: UIBarButtonItem!
    var deleteButton: UIBarButtonItem!
    
    // MARK: - Variables
    var dashboard: Dashboard!
    private var nodes = [(title: String, nodes: [DashboardSettingsNodeType])]()

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Localizations.collection.title
        
        if self.dashboard.realm == nil {
            self.saveButton = UIBarButtonItem(title: Localizations.general.save, style: .plain, target: self, action: #selector(saveButtonAction(sender:)))
            self.navigationItem.rightBarButtonItem = self.saveButton
        } else {
            self.navigationItem.title! += " (\(self.dashboard.title))"
            
            self.deleteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "delete").resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(deleteButtonAction(sender:)))
            self.deleteButton.accessibilityLabel = Localizations.general.delete
            self.navigationItem.rightBarButtonItem = deleteButton
        }
        
        self.tableNode = ASTableNode(style: .grouped)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.view.addSubnode(self.tableNode)
        
        self.nodes.append((title: Localizations.collection.selectTitle, nodes: [.title]))
        self.nodes.append((title: Localizations.collection.icons, nodes: [DashboardSettingsNodeType.icons]))
        
        self.observable()
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
    
    // MARK: - ASTableDataSource
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return self.nodes.count
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.nodes[section].nodes.count
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let type = self.nodes[indexPath.section].nodes[indexPath.row]
        switch type {
        case .icons:
            return {
                let node = DashboardsNode(cellSize: CGSize(width: 80.0, height: 80.0))
                node.cellHeight = 80.0 * 3 + 20.0
                node.collectionDidLoad = { () in
                    node.collectionView.dataSource = self
                    node.collectionView.delegate = self
                }
                
                return node
            }
        case .title:
            return {
                let node = DashboardTitleNode(style: Themes.manager.dashboardSettingsStyle)
                node.selectionStyle = .none
                node.textFieldDidLoad = { () in
                    node.textField.text = self.dashboard.title
                }
                node.button.addTarget(self, action: #selector(self.saveTitleAction(sender:)), forControlEvents: .touchUpInside)
                return node
            }
        }
    }

    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = self.nodes[section].title
        return item
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        let style = Themes.manager.settingsStyle
        header.textLabel?.textColor = style.tableSectionHeaderColor
        header.textLabel!.font = style.tableSectionHeaderFont
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dashboardIcon", for: indexPath) as! DashboardIconCell
        let icon = "dashboard-\(indexPath.row)"
        cell.isAccessibilityElement = true
        cell.accessibilityTraits = UIAccessibilityTraitButton
        cell.accessibilityValue = icon
        if self.dashboard.image == icon {
            cell.imageView.image = UIImage(named: icon)
            cell.accessibilityTraits |= UIAccessibilityTraitSelected
        } else {
            cell.imageView.image = UIImage(named: icon)?.noir
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let icon = "dashboard-\(indexPath.row)"
        if self.dashboard.realm == nil {
            self.dashboard.image = icon
        } else {
            try! Database.manager.data.write {
                self.dashboard.image = icon
            }
        }
        collectionView.reloadData()
    }
    
    // MARK: - Actions
    @objc func saveButtonAction(sender: UIBarButtonItem) {
        self.dashboard.order = Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@", false).count
        try! Database.manager.data.write {
            Database.manager.data.add(self.dashboard)
        }
        
        sendEvent(.newDashboard, withProperties: nil)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteButtonAction(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: Localizations.general.sureQuestion, message: Localizations.collection.deleteMessage, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: Localizations.general.cancel, style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: Localizations.general.delete, style: .destructive) { (_) in
            
            let cards = Database.manager.data.objects(Card.self).filter("dashboard=%@", self.dashboard.id)
            for card in cards {
                try! Database.manager.data.write {
                    card.dashboard = nil
                }
            }
            
            // Delete Dashboard
            try! Database.manager.data.write {
                self.dashboard.isDeleted = true
            }
            
            Feedback.player.play(sound: .deleteCard, feedbackType: .success)
            sendEvent(.deleteDashboard, withProperties: nil)
            
            if let nav = self.parent as? UINavigationController {
                nav.popViewController(animated: true)
            }
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        if self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            alert.popoverPresentationController?.barButtonItem = self.deleteButton
            alert.popoverPresentationController?.sourceView = self.view
        }
        
        alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
        alert.view.layoutIfNeeded()
        self.present(alert, animated: true) {
            alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
        }
    }
    
    @objc func saveTitleAction(sender: ASButtonNode) {
        if let cell = self.tableNode.nodeForRow(at: IndexPath(row: 0, section: 0)) as? DashboardTitleNode {
            cell.textField.resignFirstResponder()
            
            if self.dashboard.realm == nil {
                self.dashboard.title = cell.textField.text!
            } else {
                try! Database.manager.data.write {
                    self.dashboard.title = cell.textField.text!
                }
            }
        }
    }
    
    // MARK: - Private
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.dashboardSettingsStyle
            
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
            self.tableNode.view.separatorColor = style.tableSeparatorColor
        })
    }
}
