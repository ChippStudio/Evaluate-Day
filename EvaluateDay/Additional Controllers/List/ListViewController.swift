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

class ListViewController: UIViewController, ASTableDataSource, ASTableDelegate, TextTopViewControllerDelegate {

    // MARK: - UI
    var tableNode: ASTableNode!
    var newButton: UIBarButtonItem!
    var editButton: UIBarButtonItem!
    
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
        self.editButton = UIBarButtonItem(title: Localizations.general.edit, style: .plain, target: self, action: #selector(self.editButtonAction(sender:)))
        
        self.navigationItem.rightBarButtonItems = [self.newButton, self.editButton]
        
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
        return 2
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.undone.count
        }

        return self.done.count
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let style = Themes.manager.evaluateStyle
        if indexPath.section == 0 {
            let item = self.undone[indexPath.row]
            let text = item.text
            return {
                let node = ListItemEvaluateNode(text: text, done: false, style: style)
                node.doneDidPressed = { (cellIndexPath) in
                    self.didDonePressed(indexPath: cellIndexPath)
                }
                return node
            }
        }
        
        let item = self.done[indexPath.row]
        let text = item.text
        return {
            let node = ListItemEvaluateNode(text: text, done: true, style: style)
            node.doneDidPressed = { (cellIndexPath) in
                self.didDonePressed(indexPath: cellIndexPath)
            }
            return node
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        
        if let node = self.tableNode.nodeForRow(at: sourceIndexPath) as? ListItemEvaluateNode {
            let style = Themes.manager.evaluateStyle
            if item.done {
                node.doneDot.backgroundColor = style.listItemTintColor
            } else {
                node.doneDot.backgroundColor = UIColor.clear
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
        
        let controller = TextTopViewController()
        controller.property = item.id
        controller.textView.text = item.text
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - TextTopViewControllerDelegate
    func textTopController(controller: TextTopViewController, willCloseWith text: String, forProperty property: String) {
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
    @objc func newItemButtonAction(sender: UIBarButtonItem) {
        let controller = TextTopViewController()
        controller.delegate = self
        controller.property = ""
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func editButtonAction(sender: UIBarButtonItem) {
        if self.tableNode.view.isEditing {
            self.tableNode.view.setEditing(false, animated: true)
            self.editButton.title = Localizations.general.edit
        } else {
            self.tableNode.view.setEditing(true, animated: true)
            self.editButton.title = Localizations.general.done
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
    
    // MARK: - Private
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.evaluateStyle
            
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
            self.tableNode.view.separatorColor = style.tableNodeSeparatorColor
        })
    }
}
