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
    
    // MARK: - Private
    private var notificationObject: CardSettingsNotificationObject!
    
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
            self.saveButton = UIBarButtonItem(title: Localizations.General.save, style: .plain, target: self, action: #selector(saveButtonAction(sender:)))
            self.navigationItem.rightBarButtonItem = self.saveButton
        }
        
        // MARK: - Navigation Item
        self.navigationItem.title = Localizations.Settings.title + ": " + Sources.title(forType: self.card.type)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAppearance(animated: false)
        self.adapter.performUpdates(animated: true, completion: nil)
    }
    
    override func updateAppearance(animated: Bool) {
        super.updateAppearance(animated: animated)
        
        let duration: TimeInterval = animated ? 0.2 : 0
        UIView.animate(withDuration: duration) {
            //set NavigationBar
            self.navigationController?.navigationBar.barTintColor = UIColor.background
            self.navigationController?.navigationBar.tintColor = UIColor.main
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            self.collectionNode.backgroundColor = UIColor.background
        }
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
        if self.card.realm != nil {
            let not = CardSettingsNotificationObject(card: self.card)
            let del = CardSettingsDeleteObject()
            return [crd, not, del]
        }
        
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
        } else if object is CardSettingsNotificationObject {
            let controller = CardSettingsNotificationSection(card: self.card)
            controller.inset = UIEdgeInsets(top: 50.0, left: 0.0, bottom: 0.0, right: 0.0)
            return controller
        } else if object is CardSettingsDeleteObject {
            let controller = CardSettingsDeleteSection(card: self.card)
            controller.inset = UIEdgeInsets(top: 50.0, left: 0.0, bottom: 30.0, right: 0.0)
            return controller
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
            self.card.title = Localizations.CardSettings.untitle(Sources.title(forType: self.card.type))
        }
        
        try! Database.manager.data.write {
            Database.manager.data.add(self.card)
        }
        
        Feedback.player.play(sound: .saveNewCard, feedbackType: .success)
        
        // Analytics
        sendEvent(.addNewCard, withProperties: ["type": self.card.type.string])
        self.navigationController?.popToRootViewController(animated: true)
    }
}
