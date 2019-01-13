//
//  NewCardViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class NewCardViewController: UIViewController, ASTableDelegate, ASTableDataSource {

    // MARK: - UI
    var tableNode: ASTableNode!
    var closeButton: UIBarButtonItem!
    
    // MARK: - Variables
    let sources = Sources()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        // Navigation bar
        self.navigationItem.title = Localizations.New.Controller.title
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        // Set table node
        self.tableNode = ASTableNode(style: .plain)
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        self.tableNode.accessibilityIdentifier = "cardsTypeList"
        self.tableNode.view.separatorStyle = .none
        self.tableNode.view.showsVerticalScrollIndicator = false
        
        self.view.addSubnode(self.tableNode)
        
        if self.navigationController!.viewControllers.count == 1 {
            self.closeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "close").resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(self.closeButtonAction(sender:)))
            self.navigationItem.leftBarButtonItem = closeButton
        }
        
        // Analytics
        sendEvent(.openNewCardSelector, withProperties: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.observable()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if self.view.traitCollection.userInterfaceIdiom == .pad && self.view.frame.size.width >= maxCollectionWidth {
            self.tableNode.frame = CGRect(x: self.view.frame.size.width / 2 - maxCollectionWidth / 2, y: 0.0, width: maxCollectionWidth, height: self.view.frame.size.height)
        } else {
            self.tableNode.frame = self.view.bounds
        }
    }
    
    // MARK: - ASTableDataSource
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if Database.manager.application.user.pro {
                return 0
            }
            
            return 2
        }
        
        return self.sources.cards.count
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return {
                    let node = SettingsProNode()
                    return node
                }
            }
            
            return {
                let node = DescriptionNode(text: Localizations.New.Cards.Limit.message(cardsLimit), alignment: .right, style: Themes.manager.settingsStyle)
                node.topInset = 10.0
                return node
            }
        }
        
        let source = self.sources.cards[indexPath.row]
        var untouch = false
        
        if Database.manager.data.objects(Card.self).filter("isDeleted=%@", false).count >= cardsLimit && !Store.current.isPro {
            untouch = true
        }
        
        return {
            let node = SourceNode(title: source.title, subtitle: source.subtitle, image: source.image, untouchble: untouch, style: Themes.manager.newCardStyle)
            return node
        }
    }
    
    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
            self.navigationController?.pushViewController(controller, animated: true)
            return
        }
        
        if tableNode.nodeForRow(at: indexPath)!.selectionStyle == .none {
            return
        }
        
        let source = self.sources.cards[indexPath.row]
        let newCard = Card()
        newCard.type = source.type
        newCard.order = Database.manager.data.objects(Card.self).count
        if newCard.data as? Editable != nil {
            let controller = UIStoryboard(name: Storyboards.cardSettings.rawValue, bundle: nil).instantiateInitialViewController() as! CardSettingsViewController
            controller.card = newCard
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: - Actions
    @objc func closeButtonAction(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Private
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.newCardStyle
            
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
            self.tableNode.reloadData()
        })
    }
}
