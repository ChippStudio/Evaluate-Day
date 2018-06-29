//
//  PhrasesViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 19/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RealmSwift

class PhrasesViewController: UIViewController, ASTableDataSource, ASTableDelegate {

    // MARK: - UI
    var tableNode: ASTableNode!
    
    // MARK: - Variables
    var card: Card!
    private var values: Results<TextValue>!
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation item
        self.navigationItem.title = self.card.title
        
        // self values
        self.values = (self.card.data as! PhraseCard).values.sorted(byKeyPath: "created", ascending: false)
        
        // Set table node
        self.tableNode = ASTableNode(style: .plain)
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
        return 1
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.values.count
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let value = self.values[indexPath.row]
        let text = value.text
        let date = value.created
        
        let separatorInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)
        return {
            let node = PhraseListNode(text: text, date: date, style: Themes.manager.analyticalStyle)
            node.selectionStyle = .none
            node.separatorInset = separatorInsets
            return node
        }
    }

    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.analyticalStyle
            
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
