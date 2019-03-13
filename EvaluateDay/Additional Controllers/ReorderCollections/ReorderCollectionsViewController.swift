//
//  ReorderCollectionsViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 26/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class ReorderCollectionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI
    var closeButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var collections: Results<Dashboard>!
    private let contentCell = "contentCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set close button
        self.closeButton = UIBarButtonItem(image: Images.Media.close.image.resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(self.closeButtonAction(sender:)))
        self.navigationItem.leftBarButtonItem = self.closeButton
        
        // Set collections
        self.setCollections()
        
        // Set table view
        self.tableView.isEditing = Database.manager.application.settings.collectionSortedManually
        self.tableView.allowsSelectionDuringEditing = true
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
            
            // TableView
            self.tableView.backgroundColor = UIColor.background
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        
        return self.collections.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: contentCell, for: indexPath)
            let collection = self.collections[indexPath.row]
            let title: String
            if collection.title.isEmpty {
                title = Localizations.Collection.Edit.titlePlaceholder
            } else {
                title = collection.title
            }
            cell.textLabel?.text = title
            cell.textLabel?.textColor = UIColor.text
            
            cell.imageView?.image = UIImage(named: collection.image)?.resizedImage(newSize: CGSize(width: 30.0, height: 30.0))
            cell.imageView?.layer.cornerRadius = 15.0
            cell.imageView?.layer.masksToBounds = true
            
            cell.backgroundColor = UIColor.background
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: contentCell, for: indexPath)
        cell.textLabel?.textColor = UIColor.text
        cell.imageView?.image = Images.Media.done.image.resizedImage(newSize: CGSize(width: 25.0, height: 25.0)).withRenderingMode(.alwaysTemplate)
        
        let selectedView = UIView()
        selectedView.layer.cornerRadius = 10.0
        selectedView.backgroundColor = UIColor.tint
        
        cell.selectedBackgroundView = selectedView
        cell.selectionStyle = .default
        
        cell.backgroundColor = UIColor.background
        cell.imageView?.tintColor = UIColor.background
        
        cell.imageView?.layer.cornerRadius = 0.0
        cell.imageView?.layer.masksToBounds = false
        
        let settings = Database.manager.application.settings!
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = Localizations.Settings.Sorted.custom
            if settings.collectionSortedManually {
                cell.imageView?.tintColor = UIColor.main
            }
        case 1:
            cell.textLabel?.text = Localizations.Settings.Sorted.Alphabet.ascending
            if settings.collectionSortedAlphabet && settings.collectionAscending {
                cell.imageView?.tintColor = UIColor.main
            }
        case 2:
            cell.textLabel?.text = Localizations.Settings.Sorted.Alphabet.descending
            if settings.collectionSortedAlphabet && !settings.collectionAscending {
                cell.imageView?.tintColor = UIColor.main
            }
        case 3:
            cell.textLabel?.text = Localizations.Settings.Sorted.Date.ascending
            if settings.collectionSortedDate && settings.collectionAscending {
                cell.imageView?.tintColor = UIColor.main
            }
        default:
            cell.textLabel?.text = Localizations.Settings.Sorted.Date.descending
            if settings.collectionSortedDate && !settings.collectionAscending {
                cell.imageView?.tintColor = UIColor.main
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if sourceIndexPath.section == proposedDestinationIndexPath.section {
            return proposedDestinationIndexPath
        }
        
        return sourceIndexPath
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var reordableCollections = [Dashboard]()
        for c in self.collections {
            reordableCollections.append(c)
        }
        
        let tempCollections = reordableCollections[sourceIndexPath.row]
        reordableCollections.remove(at: sourceIndexPath.row)
        reordableCollections.insert(tempCollections, at: destinationIndexPath.row)
        
        try! Database.manager.data.write {
            for (i, c) in reordableCollections.enumerated() {
                c.order = i
                c.edited = Date()
            }
        }
        
        // Analytics
        sendEvent(.reorderCollection, withProperties: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return true
        }
        return false
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            return
        }
        
        let settings = Database.manager.application.settings!
        switch indexPath.row {
        case 0:
            try! Database.manager.app.write {
                settings.collectionSortedManually = true
                settings.collectionAscending = true
                settings.collectionSortedAlphabet = false
                settings.collectionSortedDate = false
            }
        case 1:
            try! Database.manager.app.write {
                settings.collectionSortedManually = false
                settings.collectionAscending = true
                settings.collectionSortedAlphabet = true
                settings.collectionSortedDate = false
            }
        case 2:
            try! Database.manager.app.write {
                settings.collectionSortedManually = false
                settings.collectionAscending = false
                settings.collectionSortedAlphabet = true
                settings.collectionSortedDate = false
            }
        case 3:
            try! Database.manager.app.write {
                settings.collectionSortedManually = false
                settings.collectionAscending = true
                settings.collectionSortedAlphabet = false
                settings.collectionSortedDate = true
            }
        default:
            try! Database.manager.app.write {
                settings.collectionSortedManually = false
                settings.collectionAscending = false
                settings.collectionSortedAlphabet = false
                settings.collectionSortedDate = true
            }
        }
        
        self.tableView.isEditing = Database.manager.application.settings.collectionSortedManually
        self.tableView.reloadSections([0], with: .none)
        self.setCollections()
        
        NotificationCenter.default.post(name: NSNotification.Name.CollectionsSortedDidChange, object: nil)
    }
    
    // MARK: - Actions
    @objc func closeButtonAction(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private Actions
    private func setCollections() {
        self.collections = Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@", false).sorted(byKeyPath: Sources.sortedCollection, ascending: Sources.ascendingCollection)
        self.tableView.reloadSections([1], with: .fade)
    }
}
