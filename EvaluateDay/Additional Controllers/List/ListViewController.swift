//
//  ListViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 25/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift
import AsyncDisplayKit

class ListViewController: UIViewController, ASTableDataSource, ASTableDelegate, TextViewControllerDelegate {

    // MARK: - UI
    var tableNode: ASTableNode!
    var newButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    var closeButton: UIBarButtonItem!
    
    // MARK: - Variables
    var card: Card!
    var date: Date!
    
    private var done: Results<MarkValue>!
    private var undone: Results<MarkValue>!
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set results
        self.done = Database.manager.data.objects(MarkValue.self).filter("owner=%@ AND done=%@ AND isDeleted=%@", self.card.id, true, false).sorted(byKeyPath: "order")
        self.undone = Database.manager.data.objects(MarkValue.self).filter("owner=%@ AND done=%@ AND isDeleted=%@", self.card.id, false, false).sorted(byKeyPath: "order")
        
        // Set navigation item
        self.navigationItem.title = self.card.title
        
        // bar buttons
        self.newButton = UIBarButtonItem(image: #imageLiteral(resourceName: "new").resizedImage(newSize: CGSize(width: 25.0, height: 25.0)), style: .plain, target: self, action: #selector(self.newItemButtonAction(sender:)))
        self.editButton = UIBarButtonItem(title: Localizations.General.edit, style: .plain, target: self, action: #selector(self.editButtonAction(sender:)))
        
        self.navigationItem.rightBarButtonItems = [self.newButton, self.editButton]
        
        // Close button
        if self.navigationController?.viewControllers.first is ListViewController {
            self.closeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close").resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(closeButtonAction(sender:)))
            self.navigationItem.leftBarButtonItem = closeButton
        }
        
        // Set table node
        self.tableNode = ASTableNode(style: .grouped)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.view.addSubnode(self.tableNode)
        
        // Accessibility
        self.newButton.accessibilityLabel = Localizations.Accessibility.Evaluate.List.addNew
        self.editButton.accessibilityLabel = Localizations.Accessibility.Evaluate.List.editList
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
            
            // TableView
            self.tableNode.backgroundColor = UIColor.background
        }
    }
    
    // MARK: - ASTableDataSource
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.undone.count
        }

        return self.done.count
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let selView = UIView()
        selView.backgroundColor = UIColor.tint
        selView.layer.cornerRadius = 5.0
        
        if indexPath.section == 0 {
            let item = self.undone[indexPath.row]
            let text = item.text
            
            return {
                let node = ListItemEvaluateNode(text: text, done: false)
                node.selectedBackgroundView = selView
                node.doneDidPressed = { (cellIndexPath) in
                    //Feedback
                    Feedback.player.play(sound: nil, hapticFeedback: false, impact: true, feedbackType: nil)
                    self.didDonePressed(indexPath: cellIndexPath)
                }
                return node
            }
        }
        
        let item = self.done[indexPath.row]
        let text = item.text
        return {
            let node = ListItemEvaluateNode(text: text, done: true)
            node.selectedBackgroundView = selView
            node.doneDidPressed = { (cellIndexPath) in
                self.didDonePressed(indexPath: cellIndexPath)
            }
            return node
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item: MarkValue
            if indexPath.section == 0 {
                item = self.undone[indexPath.row]
            } else {
                item = self.done[indexPath.row]
            }
            
            try! Database.manager.data.write {
                item.isDeleted = true
            }
            
            self.tableNode.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item: MarkValue
        if sourceIndexPath.section == 0 {
            item = self.undone[sourceIndexPath.row]
        } else {
            item = self.done[sourceIndexPath.row]
        }
        
        if destinationIndexPath.section == 0 {
            try! Database.manager.data.write {
                item.done = false
                item.order = destinationIndexPath.row
            }
        } else {
            try! Database.manager.data.write {
                item.done = true
                item.doneDate = self.date
            }
        }
    }
    
    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        let item: MarkValue
        if indexPath.section == 0 {
            item = self.undone[indexPath.row]
        } else {
            item = self.done[indexPath.row]
        }
        
        let controller = UIStoryboard(name: Storyboards.text.rawValue, bundle: nil).instantiateInitialViewController() as! TextViewController
        controller.property = item.id
        controller.text = item.text
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - TextViewControllerDelegate
    func textTopController(controller: TextViewController, willCloseWith text: String, forProperty property: String) {
        if property == "" {
            let newValue = MarkValue()
            newValue.owner = self.card.id
            newValue.text = text
            newValue.order = Database.manager.data.objects(MarkValue.self).filter("owner=%@ AND isDeleted=%@", self.card.id, false).count
            
            try! Database.manager.data.write {
                Database.manager.data.add(newValue)
            }
        } else {
            if let item = Database.manager.data.objects(MarkValue.self).filter("id=%@", property).first {
                try! Database.manager.data.write {
                    item.text = text
                }
            }
        }
        
        self.tableNode.reloadData()
    }
    
    // MARK: - Actions
    @objc func closeButtonAction(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func newItemButtonAction(sender: UIBarButtonItem) {
        let controller = UIStoryboard(name: Storyboards.text.rawValue, bundle: nil).instantiateInitialViewController() as! TextViewController
        controller.delegate = self
        controller.property = ""
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func editButtonAction(sender: UIBarButtonItem) {
        if self.tableNode.view.isEditing {
            self.tableNode.view.setEditing(false, animated: true)
            self.editButton.title = Localizations.General.edit
        } else {
            self.tableNode.view.setEditing(true, animated: true)
            self.editButton.title = Localizations.General.done
        }
    }
    
    func didDonePressed(indexPath: IndexPath) {
        if indexPath.section == 0 {
            let item = self.undone[indexPath.row]
            try! Database.manager.data.write {
                item.done = true
                item.doneDate = self.date
            }
        } else {
            let item = self.done[indexPath.row]
            try! Database.manager.data.write {
                item.done = false
                item.order = self.undone.count
            }
        }
        
        self.tableNode.reloadData()
    }
}
