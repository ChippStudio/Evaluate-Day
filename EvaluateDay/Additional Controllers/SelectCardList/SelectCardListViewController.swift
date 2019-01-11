//
//  SelectCardListViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 30/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RealmSwift

@objc protocol SelectCardListViewControllerDelegate {
    @objc func  didSelect(cardId id: String)
}
class SelectCardListViewController: UIViewController, ASTableDataSource, ASTableDelegate {

    // MARK: - UI
    var tableNode: ASTableNode!
    
    // MARK: - Variable
    var cards: Results<Card>!
    weak var delegate: SelectCardListViewControllerDelegate?
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation item
        self.navigationItem.title = Localizations.Settings.Notifications.New.selectCard
        
        // set cards
        self.cards = Database.manager.data.objects(Card.self).sorted(byKeyPath: "order")
        
        // set table node
        self.tableNode = ASTableNode(style: .plain)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
//        self.tableNode.view.separatorStyle = .none
        self.view.addSubnode(self.tableNode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.tableNode.frame = self.view.bounds
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
        return self.cards.count
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let title = self.cards[indexPath.row].title
        let subtitle = self.cards[indexPath.row].subtitle
        let image = Sources.image(forType: self.cards[indexPath.row].type)
        let type = Sources.title(forType: self.cards[indexPath.row].type)
        
        let selView = UIView()
        selView.backgroundColor = Themes.manager.settingsStyle.settingsSelectColor
        
        return {
            let node = TitleNode(title: title, subtitle: subtitle, image: image)
            node.backgroundColor = Themes.manager.settingsStyle.settingsSectionBackground
            node.selectedBackgroundView = selView
            
            node.isAccessibilityElement = true
            node.accessibilityTraits = UIAccessibilityTraitButton
            node.accessibilityLabel = "\(title), \(type)"
            node.accessibilityValue = subtitle
            
            return node
        }
    }
    
    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        self.delegate?.didSelect(cardId: self.cards[indexPath.row].id)
        sendEvent(.addCardToNotification, withProperties: ["type": self.cards[indexPath.row].type.string])
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Private
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.settingsStyle
            
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
            self.tableNode.view.separatorColor = style.settingsSeparatorColor
            
            // Table node
            self.tableNode.reloadData()
        })
    }

}
