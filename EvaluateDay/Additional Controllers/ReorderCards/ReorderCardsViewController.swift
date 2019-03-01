//
//  ReorderCardsViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 26/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class ReorderCardsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UI
    var closeButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var cards: Results<Card>!
    
    private let contentCell = "contentCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set close button
        self.closeButton = UIBarButtonItem(image: Images.Media.close.image.resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(self.closeButtonAction(sender:)))
        self.navigationItem.leftBarButtonItem = self.closeButton
        
        // Set cards
        self.setCards()
        
        // Set table view
        self.tableView.isEditing = Database.manager.application.settings.cardSortedManually
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
            return 6
        }
        
        return self.cards.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let card = self.cards[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: contentCell, for: indexPath)
            if card.archived {
                cell.textLabel?.text = "🔒 " + card.title
            } else {
                cell.textLabel?.text = card.title
            }
            cell.textLabel?.textColor = UIColor.text
            cell.imageView?.image = Sources.image(forType: card.type).resizedImage(newSize: CGSize(width: 30.0, height: 30.0)).withRenderingMode(.alwaysTemplate)
            cell.imageView?.tintColor = UIColor.main
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
        
        let settings = Database.manager.application.settings!
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = Localizations.Settings.Sorted.showArchived
            if settings.cardIsShowArchived {
                cell.imageView?.tintColor = UIColor.main
            }
        case 1:
            cell.textLabel?.text = Localizations.Settings.Sorted.custom
            if settings.cardSortedManually {
                cell.imageView?.tintColor = UIColor.main
            }
        case 2:
            cell.textLabel?.text = Localizations.Settings.Sorted.Alphabet.ascending
            if settings.cardSortedAlphabet && settings.cardAscending {
                cell.imageView?.tintColor = UIColor.main
            }
        case 3:
            cell.textLabel?.text = Localizations.Settings.Sorted.Alphabet.descending
            if settings.cardSortedAlphabet && !settings.cardAscending {
                cell.imageView?.tintColor = UIColor.main
            }
        case 4:
            cell.textLabel?.text = Localizations.Settings.Sorted.Date.ascending
            if settings.cardSortedDate && settings.cardAscending {
                cell.imageView?.tintColor = UIColor.main
            }
        default:
            cell.textLabel?.text = Localizations.Settings.Sorted.Date.descending
            if settings.cardSortedDate && !settings.cardAscending {
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
        var reordableCards = [Card]()
        for c in self.cards {
            reordableCards.append(c)
        }

        let tempCards = reordableCards[sourceIndexPath.row]
        reordableCards.remove(at: sourceIndexPath.row)
        reordableCards.insert(tempCards, at: destinationIndexPath.row)

        try! Database.manager.data.write {
            for (i, c) in reordableCards.enumerated() {
                c.order = i
                c.edited = Date()
            }
        }
        
        // Analytics
        sendEvent(.reorderCards, withProperties: nil)
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
                settings.cardIsShowArchived = !settings.cardIsShowArchived
            }
        case 1:
            try! Database.manager.app.write {
                settings.cardSortedManually = true
                settings.cardAscending = true
                settings.cardSortedAlphabet = false
                settings.cardSortedDate = false
            }
        case 2:
            try! Database.manager.app.write {
                settings.cardSortedManually = false
                settings.cardAscending = true
                settings.cardSortedAlphabet = true
                settings.cardSortedDate = false
            }
        case 3:
            try! Database.manager.app.write {
                settings.cardSortedManually = false
                settings.cardAscending = false
                settings.cardSortedAlphabet = true
                settings.cardSortedDate = false
            }
        case 4:
            try! Database.manager.app.write {
                settings.cardSortedManually = false
                settings.cardAscending = true
                settings.cardSortedAlphabet = false
                settings.cardSortedDate = true
            }
        default:
            try! Database.manager.app.write {
                settings.cardSortedManually = false
                settings.cardAscending = false
                settings.cardSortedAlphabet = false
                settings.cardSortedDate = true
            }
        }
        
        self.tableView.isEditing = Database.manager.application.settings.cardSortedManually
        self.tableView.reloadSections([0], with: .none)
        self.setCards()
        
        NotificationCenter.default.post(name: NSNotification.Name.CardsSortedDidChange, object: nil)
    }
    
    // MARK: - Actions
    @objc func closeButtonAction(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private
    func setCards() {
        // Set cards
        self.cards = Database.manager.data.objects(Card.self).filter(Sources.predicate).sorted(byKeyPath: Sources.sorted, ascending: Sources.ascending)
        self.tableView.reloadSections([1], with: .fade)
    }
}
