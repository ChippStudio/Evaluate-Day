//
//  EntriesListViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 06/02/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class EntriesListViewController: UIViewController, ASTableDataSource, ASTableDelegate {
    
    // MARK: - UI
    var editButton: UIBarButtonItem!
    var tableNode: ASTableNode!
    
    // MARK: - Variables
    var card: Card!
    var nodes = [[TextValue]]()

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationItem.title = self.card.title
        
        self.groupNodes()
        
        // Set table node
        self.tableNode = ASTableNode(style: .grouped)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.view.addSubnode(self.tableNode)
        
        if !self.card.archived {
            self.editButton = UIBarButtonItem(title: Localizations.General.edit, style: .plain, target: self, action: #selector(self.editButtonAction(sender:)))
            self.navigationItem.rightBarButtonItem = self.editButton
        }
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
            self.tableNode.backgroundColor = UIColor.background
            
            // Table node
//            self.tableNode.view.separatorColor = style.tableNodeSeparatorColor
        }
    }
    
    // MARK: - ASTableDataSource
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return self.nodes.count
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.nodes[section].count
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let entry = self.nodes[indexPath.section][indexPath.row]
        let text = entry.text
        let date = entry.created
        var weatherImage: UIImage?
        var locationText = ""
        var weatherText = ""
        if let loc = entry.location {
            locationText.append(loc.streetString)
            locationText.append(", \(loc.cityString)")
        }
        if let w = entry.weather {
            weatherImage = UIImage(named: w.icon)
            var temperature = "\(String(format: "%.0f", w.temperarure)) ℃"
            if !Database.manager.application.settings.celsius {
                temperature = "\(String(format: "%.0f", (w.temperarure * (9/5) + 32))) ℉"
            }
            weatherText = temperature
        }
        var photos = [UIImage?]()
        for p in entry.photos {
            photos.append(p.image)
        }
        if photos.isEmpty {
            photos.append(nil)
        }
        let selView = UIView()
        selView.backgroundColor = UIColor.tint
        selView.layer.cornerRadius = 5.0

        return {
            let node = JournalEntryNode(preview: text, images: photos, date: date, weatherImage: weatherImage, weatherText: weatherText, locationText: locationText)
            node.selectedBackgroundView = selView
            return node
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.card.archived {
            return false
        }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle != .delete {
            return
        }
        
        let value = self.nodes[indexPath.section][indexPath.row]
        try! Database.manager.data.write {
            value.isDeleted = true
        }
        self.nodes[indexPath.section].remove(at: indexPath.row)
        self.tableNode.reloadSections([indexPath.section], with: .fade)
    }

    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        
        let entry = self.nodes[indexPath.section][indexPath.row]
        let controller = UIStoryboard(name: Storyboards.entry.rawValue, bundle: nil).instantiateInitialViewController() as! EntryViewController
        controller.card = self.card
        controller.textValue = entry
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let value = self.nodes[section].first!
        return DateFormatter.localizedString(from: value.created, dateStyle: .medium, timeStyle: .none)
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.text
        header.textLabel!.font = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.editButton.title = Localizations.General.done
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath) {
        self.editButton.title = Localizations.General.edit
    }
    
    // MARK: - Private
    @objc private func editButtonAction(sender: UIBarButtonItem) {
        let willEdit = !self.tableNode.view.isEditing
        if willEdit {
            sender.title = Localizations.General.done
        } else {
            sender.title = Localizations.General.edit
        }
        self.tableNode.view.setEditing(willEdit, animated: true)
    }
    
    private func groupNodes() {
        let entries = (self.card.data as! JournalCard).values.sorted(byKeyPath: "created", ascending: false)
        var currentDate: Date = Date()
        var data = [TextValue]()
        if let e = entries.first {
            currentDate = e.created
        }
        for (i, entry) in entries.enumerated() {
            if currentDate.start.days(to: entry.created.start) == 0 {
                data.append(entry)
            } else {
                self.nodes.append(data)
                data.removeAll()
                data.append(entry)
                currentDate = entry.created
            }
            
            if i == entries.count - 1 {
                self.nodes.append(data)
            }
        }
    }
}
