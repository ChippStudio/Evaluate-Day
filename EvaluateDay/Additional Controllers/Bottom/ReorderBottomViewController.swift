//
//  ReorderBottomViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 07/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import RealmSwift

class ReorderBottomViewController: BottomViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI
    var tableView: UITableView!
    
    // MARK: - Variables
    var cards: Results<Card>!
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Table view
        let tableFrame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
        self.tableView = UITableView(frame: tableFrame, style: .plain)
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "reorderCell")
        self.tableView.backgroundColor = UIColor.background
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.contentInset = UIEdgeInsets(top: 30.0, left: 0.0, bottom: 20.0, right: 0.0)
        self.tableView.separatorStyle = .none
        self.tableView.isEditing = true
        self.tableView.showsVerticalScrollIndicator = false
        
        self.contentView.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            if UIApplication.shared.keyWindow!.rootViewController!.view.traitCollection.horizontalSizeClass == .compact {
                make.trailing.equalToSuperview()
                make.leading.equalToSuperview()
            } else {
                make.centerX.equalToSuperview()
                make.width.equalTo(350.0)
            }
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.centerY)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cards.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reorderCell", for: indexPath)
        cell.imageView?.image = Sources.image(forType: cards[indexPath.row].type).resizedImage(newSize: CGSize(width: 25.0, height: 25.0))
        cell.imageView?.contentMode = .scaleAspectFit
        cell.backgroundColor = UIColor.background
        cell.textLabel?.text = self.cards[indexPath.row].title
        cell.textLabel?.textColor = UIColor.main
        cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
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
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50.0
//    }
}
