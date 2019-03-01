//
//  ColorsListViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 01/02/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class ColorsListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI
    var editButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var card: Card!
    var values: Results<TextValue>!
    
    private let colorContent = "colorContent"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.card.title
        
        if !self.card.archived {
            self.editButton = UIBarButtonItem(title: Localizations.General.edit, style: .plain, target: self, action: #selector(self.editButtonAction(sender:)))
            self.navigationItem.rightBarButtonItem = self.editButton
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
            self.tableView.backgroundColor = UIColor.background
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.values.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let value = self.values[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: colorContent, for: indexPath) as! ColorListCell
        cell.colorDot.backgroundColor = value.text.color
        if value.text == "FFFFFF" {
            cell.colorDot.layer.borderColor = UIColor.main.cgColor
        } else {
            cell.colorDot.layer.borderColor = value.text.color.cgColor
        }
        cell.dateLabel.text = DateFormatter.localizedString(from: value.created, dateStyle: .medium, timeStyle: .short)
        
        let selectedView = UIView()
        selectedView.layer.cornerRadius = 10.0
        selectedView.layer.masksToBounds = true
        selectedView.backgroundColor = UIColor.tint
        
        cell.selectedBackgroundView = selectedView
        
        return cell
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
        
        let value = self.values[indexPath.row]
        try! Database.manager.data.write {
            value.isDeleted = true
        }
        
        self.tableView.reloadSections([0], with: .fade)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        self.editButton.title = Localizations.General.done
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        self.editButton.title = Localizations.General.edit
    }
    
    // MARK: - Actions
    @objc private func editButtonAction(sender: UIBarButtonItem) {
        let willEdit = !self.tableView.isEditing
        if willEdit {
            sender.title = Localizations.General.done
        } else {
            sender.title = Localizations.General.edit
        }
        self.tableView.setEditing(willEdit, animated: true)
    }
}
