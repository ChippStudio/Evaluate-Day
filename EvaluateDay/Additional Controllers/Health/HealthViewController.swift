//
//  HealthViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 17/09/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import HealthKit

class HealthViewController: UIViewController, ASTableDelegate, ASTableDataSource {

    // MARK: - UI
    var tableNode: ASTableNode!
    
    // MARK: - Variables
    var sources = [HealthSources]()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar
        self.navigationItem.title = Localizations.cardSettings.health.appleMetrics
        
        // Set health source data
        self.setHealthSourceData()
        
        // Set table node
        self.tableNode = ASTableNode(style: .grouped)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.view.addSubnode(self.tableNode)
        
        // Set UI data
        self.observable()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableNode.frame = self.view.bounds
    }
    
    // MARK: - ASTableDataSource
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return self.sources.count
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.sources[section].sources.count
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let item = self.sources[indexPath.section].sources[indexPath.row]
        let style = Themes.manager.cardSettingsStyle
        return {
            let node = SettingsMoreNode(title: item.localizedString, subtitle: nil, image: nil, style: style)
            return node
        }
    }
    
    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        if let healthCardController = self.navigationController?.viewControllers[self.navigationController!.viewControllers.count - 2] as? CardSettingsViewController {
            if let dataHealth = healthCardController.card.data as? HealthCard {
                let item = self.sources[indexPath.section].sources[indexPath.row]
                if item.objectType == nil {
                    return
                }
                
                HKHealthStore().requestAuthorization(toShare: [item.objectType as! HKSampleType], read: [item.objectType!]) { (_, _) in
                    OperationQueue.main.addOperation {
                        dataHealth.type = item.type.rawValue
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let item = self.sources[section]
        return item.title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        let style = Themes.manager.cardSettingsStyle
        header.textLabel?.textColor = style.tableSectionHeaderColor
        header.textLabel!.font = style.tableSectionHeaderFont
    }

    // MARK: - Private
    private func setHealthSourceData() {
        self.sources.removeAll()
        
        self.sources.append(HealthSources(category: .fitness))
        self.sources.append(HealthSources(category: .body))
        self.sources.append(HealthSources(category: .nutrition))
        self.sources.append(HealthSources(category: .sleep))
        self.sources.append(HealthSources(category: .mindfulness))
    }
    
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.cardSettingsStyle
            
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
        })
    }
}
