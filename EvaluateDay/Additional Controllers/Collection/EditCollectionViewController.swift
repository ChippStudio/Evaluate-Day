//
//  CollectionViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 16/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class EditCollectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EditCollectionImagesViewControllerDelegate, SelectCardListViewControllerDelegate {
    
    // MARK: - UI
    var deleteBarButton: UIBarButtonItem!
    var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var topImage: UIImageView!
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectImageButton: UIButton!
    
    // MARK: - Variables
    var collection: Dashboard!
    
    // MARK: - Private Variables
    private var cards: Results<Card>!
    private var tempCards = [Card]()
    
    private let titleCell = "titleCell"
    private let cardCell = "cardCell"
    private let addCardCell = "addCardCell"

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.collection == nil {
            self.collection = Dashboard()
        }
        
        // Navigation item
        self.navigationItem.title = Localizations.Collection.Edit.title
        
        // Set delete or save bar button
        if self.collection.realm != nil {
            self.deleteBarButton = UIBarButtonItem(image: Images.Media.delete.image.resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(self.deleteButtonAction(sender:)))
            self.deleteBarButton.accessibilityLabel = Localizations.General.delete
            self.navigationItem.rightBarButtonItem = self.deleteBarButton
        } else {
            self.saveBarButton = UIBarButtonItem(title: Localizations.General.save, style: .plain, target: self, action: #selector(self.saveButtonAction(sender:)))
            self.navigationItem.rightBarButtonItem = self.saveBarButton
        }
        
        // Set data
        self.cards = Database.manager.data.objects(Card.self).filter("dashboard=%@ AND isDeleted=%@", self.collection.id, false).sorted(byKeyPath: "order")
        
        self.topLabel.text = Localizations.Collection.Edit.image
        self.topLabel.textColor = UIColor.text
        
        self.selectImageButton.accessibilityLabel = Localizations.Accessibility.Collection.editImage
        
        // Keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(sender:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set data
        self.topImage.image = UIImage(named: self.collection.image)
        self.topImage.layer.cornerRadius = 10.0
        self.topImage.layer.masksToBounds = true
        
        // Update appereance
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selectImage" {
            let controller = segue.destination as! EditCollectionImagesViewController
            controller.delegate = self
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        if section == 1 {
            return 1
        }
        
        if self.collection.realm == nil {
            return self.tempCards.count
        }
        
        return self.cards.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: titleCell, for: indexPath) as! TextFieldTableViewCell
            cell.textField.attributedPlaceholder = NSAttributedString(string: Localizations.Collection.Edit.titlePlaceholder, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .title2), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            cell.textField.text = self.collection.title
            cell.textField.textColor = UIColor.main
            cell.textField.tintColor = UIColor.textTint
            cell.textField.addTarget(self, action: #selector(self.changeTitleAction(sender:)), for: .editingChanged)
            cell.selectionStyle = .none
            return cell
        }
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: addCardCell, for: indexPath)
            cell.textLabel?.text = Localizations.Collection.Edit.AddCard.title
            cell.textLabel?.textColor = UIColor.text
            
            let selectedView = UIView()
            selectedView.backgroundColor = UIColor.tint
            
            cell.selectedBackgroundView = selectedView
            
            return cell
        }
        
        let card = self.collection.realm == nil ? self.tempCards[indexPath.row] : self.cards[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cardCell, for: indexPath)
        
        cell.imageView?.image = Sources.image(forType: card.type).resizedImage(newSize: CGSize(width: 26.0, height: 26.0)).withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = UIColor.main
        
        cell.textLabel?.text = card.title
        cell.detailTextLabel?.text = card.subtitle
        
        cell.textLabel?.textColor = UIColor.text
        cell.detailTextLabel?.textColor = UIColor.text
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.tint
        
        cell.selectedBackgroundView = selectedView
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let controller = UIStoryboard(name: Storyboards.selectCardList.rawValue, bundle: nil).instantiateInitialViewController() as! SelectCardListViewController
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.section == 2 {
            // Sure questens
            let action = UIAlertController(title: Localizations.General.sureQuestion, message: Localizations.Collection.Edit.DeleteCard.message, preferredStyle: .actionSheet)
            let deleteAction = UIAlertAction(title: Localizations.General.delete, style: .destructive) { (_) in
                if self.collection.realm == nil {
                    self.tempCards.remove(at: indexPath.row)
                } else {
                    try! Database.manager.data.write {
                        self.cards[indexPath.row].dashboard = nil
                    }
                }
                
                self.tableView.reloadSections([2], with: .automatic)
            }
            let cancelAction = UIAlertAction(title: Localizations.General.cancel, style: .cancel, handler: nil)
            
            action.addAction(deleteAction)
            action.addAction(cancelAction)
            
            if self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                let cell = self.tableView.cellForRow(at: indexPath)!
                action.popoverPresentationController?.sourceRect = cell.frame
                action.popoverPresentationController?.sourceView = self.view
            }
            
            self.present(action, animated: true, completion: nil)

        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return Localizations.Collection.selectTitle
        } else if section == 2 {
            return Localizations.Collection.allcards
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 2 {
            if self.collection.realm != nil {
                if self.cards.count == 0 {
                    return nil
                }
            } else {
                if self.tempCards.count == 0 {
                    return nil
                }
            }
            
            return Localizations.Collection.Edit.DeleteCard.footer
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let footer = view as? UITableViewHeaderFooterView else { return }
        footer.textLabel?.textColor = UIColor.text
        footer.textLabel!.font = UIFont.preferredFont(forTextStyle: .footnote)
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor.text
        header.textLabel!.font = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    // MARK: - EditCollectionImagesViewControllerDelegate
    func didSelectImageBy(name: String, in controller: EditCollectionImagesViewController) {
        if self.collection.realm == nil {
            self.collection.image = name
        } else {
            try! Database.manager.data.write {
                self.collection.image = name
            }
        }
        
        controller.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - SelectCardListViewControllerDelegate
    func didSelect(cardId id: String, in cotroller: SelectCardListViewController) {
        if let card = Database.manager.data.objects(Card.self).filter("id=%@", id).first {
            if card.dashboard == nil {
                if self.collection.realm == nil {
                    self.tempCards.append(card)
                } else {
                    try! Database.manager.data.write {
                        card.dashboard = self.collection.id
                    }
                }
    
                self.tableView.reloadSections([2], with: .automatic)
                cotroller.navigationController?.popViewController(animated: true)
            } else {
                cotroller.navigationController?.popViewController(animated: true)
                
                let alert = UIAlertController(title: Localizations.General.sureQuestion, message: Localizations.Collection.Edit.AddCard.message, preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: Localizations.General.cancel, style: .cancel, handler: nil)
                let addAction = UIAlertAction(title: Localizations.Collection.Edit.AddCard.title, style: .default) { (_) in
                    if self.collection.realm == nil {
                        self.tempCards.append(card)
                    } else {
                        try! Database.manager.data.write {
                            card.dashboard = self.collection.id
                        }
                    }
                    
                    self.tableView.reloadSections([2], with: .automatic)
                }
                
                alert.addAction(addAction)
                alert.addAction(cancelAction)
                
                if self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                    let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 1))!
                    alert.popoverPresentationController?.sourceRect = cell.frame
                    alert.popoverPresentationController?.sourceView = self.view
                }
                
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Action
    @objc func changeTitleAction(sender: UITextField) {
        if self.collection.realm == nil {
            self.collection.title = sender.text!
        }
    
        try! Database.manager.data.write {
            self.collection.title = sender.text!
        }
    }
    @objc func deleteButtonAction(sender: UIBarButtonItem) {
        
        // Sure questens
        let action = UIAlertController(title: Localizations.General.sureQuestion, message: Localizations.Collection.deleteMessage, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: Localizations.General.delete, style: .destructive) { (_) in
            // Clear all cards
            for card in self.cards {
                try! Database.manager.data.write {
                    card.dashboard = nil
                }
            }
            
            try! Database.manager.data.write {
                self.collection.isDeleted = true
            }
            
            sendEvent(Analytics.deleteCollection, withProperties: nil)
            
            self.universalSplitController?.popSideViewController()
        }
        let cancelAction = UIAlertAction(title: Localizations.General.cancel, style: .cancel, handler: nil)
        
        action.addAction(deleteAction)
        action.addAction(cancelAction)
        
        if self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            action.popoverPresentationController?.barButtonItem = self.deleteBarButton
            action.popoverPresentationController?.sourceView = self.view
        }
        
        self.present(action, animated: true, completion: nil)
    }
    
    @objc func saveButtonAction(sender: UIBarButtonItem) {
        // Save collection
        try! Database.manager.data.write {
            Database.manager.data.add(self.collection)
        }
        
        // Save cards
        for card in self.tempCards {
            try! Database.manager.data.write {
                card.dashboard = self.collection.id
            }
        }
        
        sendEvent(Analytics.addNewCollection, withProperties: nil)
        
        self.universalSplitController?.popSideViewController()
    }
    
    // MARK: - Keyboard actions
    @objc func keyboardWillShow(sender: Notification) {
        let height = (sender.userInfo![UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size.height
        
        self.tableView.contentInset.bottom = height
    }
    
    @objc func keyboardDidHide(sender: Notification) {
        
        self.tableView.contentInset.bottom = 0
    }
}
