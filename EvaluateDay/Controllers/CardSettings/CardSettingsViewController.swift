//
//  CardSettingsViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit
import AsyncDisplayKit
import RealmSwift

class CardSettingsViewController: UIViewController, ListAdapterDataSource, TextTopViewControllerDelegate {
    // MARK: - UI
    var collectionNode: ASCollectionNode!
    var saveButton: UIBarButtonItem!
    
    // MARK: - Variable
    var card: Card!
    var adapter: ListAdapter!
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Collection view
        self.collectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionNode.view.alwaysBounceVertical = true
        self.collectionNode.contentInset.top += 40.0
        self.view.addSubnode(self.collectionNode)
        
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        self.adapter.setASDKCollectionNode(self.collectionNode)
        adapter.dataSource = self
        adapter.performUpdates(animated: true, completion: nil)
        
        // Bar buttons
        if self.card.realm == nil {
            self.saveButton = UIBarButtonItem(title: Localizations.general.save, style: .plain, target: self, action: #selector(saveButtonAction(sender:)))
            self.navigationItem.rightBarButtonItem = self.saveButton
        }
        
        // MARK: - Navigation Item
        self.navigationItem.title = Localizations.settings.title + ": " + Sources.title(forType: self.card.type)
        
        self.observable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self.view.traitCollection.userInterfaceIdiom == .pad && self.view.frame.size.width >= maxCollectionWidth {
            self.collectionNode.frame = CGRect(x: self.view.frame.size.width / 2 - maxCollectionWidth / 2, y: 0.0, width: maxCollectionWidth, height: self.view.frame.size.height)
        } else {
            self.collectionNode.frame = self.view.bounds
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - ListAdapterDataSource
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        let crd = DiffCard(card: self.card)
        return [crd]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        if let object = object as? DiffCard {
            if object.data == nil {
                return ListSectionController()
            }
            
            if let editObject = object.data as? Editable {
                let controller = editObject.sectionController
                if var cntr = controller as? EditableSection {
                    cntr.setTextHandler = { (description, property, oldText) in
                        let textController = TextTopViewController()
                        textController.titleLabel.text = description.uppercased()
                        textController.property = property
                        textController.textView.text = oldText
                        textController.delegate = self
                        self.present(textController, animated: true, completion: nil)
                    }
                    cntr.setBoolHandler = { (isOn, property, oldIsOn) in
                        if self.card.realm != nil {
                            try! Database.manager.data.write {
                                (self.card.data as! Object)[property] = isOn
                                self.card.edited = Date()
                            }
                        } else {
                            (self.card.data as! Object)[property] = isOn
                        }
                    }
                }
                return controller
            }
        }
        
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    // MARK: - TextTopViewControllerDelegate
    func textTopController(controller: TextTopViewController, willCloseWith text: String, forProperty property: String) {
        if self.card.realm != nil {
            try! Database.manager.data.write {
                self.card[property] = text
                self.card.edited = Date()
            }
        } else {
            self.card[property] = text
        }
        self.adapter.performUpdates(animated: true, completion: nil)
    }
    
    // MARK: - Actions
    @objc func saveButtonAction(sender: UIBarButtonItem) {
        if !(self.card.data as! Editable).canSave {
            self.card.title = Localizations.cardSettings.untitle(value1: Sources.title(forType: self.card.type))
        }
        
        try! Database.manager.data.write {
            Database.manager.data.add(self.card)
        }
        
        Feedback.player.play(sound: .saveNewCard, feedbackType: .success)
        
        // Analytics
        sendEvent(.addNewCard, withProperties: ["type": self.card.type.string])
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Private
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.cardSettingsStyle
            
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
            self.collectionNode.backgroundColor = style.background
            
            // Collection View
            self.collectionNode.reloadData()
        })
    }
}
