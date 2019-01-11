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
    var tableNode: ASTableNode!
    
    // MARK: - Variables
    var card: Card!
    var nodes = [[TextValue]]()

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        self.navigationItem.title = self.card.title
        
        self.groupNodes()
        
        // Set table node
        self.tableNode = ASTableNode(style: .grouped)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.tableNode.view.separatorStyle = .none
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
        self.updateAppearance(animated: false)
    }
    
    override func updateAppearance(animated: Bool) {
        super.updateAppearance(animated: animated)
        
        let duration: TimeInterval = animated ? 0.2 : 0
        UIView.animate(withDuration: duration) {
            
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
        var metadata = [String]()
        metadata.append(DateFormatter.localizedString(from: entry.created, dateStyle: .medium, timeStyle: .short))
        if let loc = entry.location {
            metadata.append(loc.streetString)
        }
        if let w = entry.weather {
            if w.pressure != 0.0 && w.humidity != 0.0 {
                var temperature = "\(String(format: "%.0f", w.temperarure)) ℃"
                //                    var apparentTemperature = "\(String(format: "%.0f", w.apparentTemperature)) ℃"
                if !Database.manager.application.settings.celsius {
                    temperature = "\(String(format: "%.0f", (w.temperarure * (9/5) + 32))) ℉"
                    //                        apparentTemperature = "\(String(format: "%.0f", (w.apparentTemperature * (9/5) + 32))) ℉"
                }
                
                metadata.append(temperature)
            }
        }
        var photo: UIImage?
        if let p = entry.photos.first {
            photo = p.image
        }
        
        return {
            let node = JournalEntryNode(text: text, metadata: metadata, photo: photo)
            return node
        }
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
    
    // MARK: - Private
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
