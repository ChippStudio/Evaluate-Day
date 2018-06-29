//
//  CardMergeViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 01/01/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import IGListKit
import AsyncDisplayKit
import RealmSwift

class CardMergeViewController: UIViewController, ListAdapterDataSource {
    // MARK: - UI
    var collectionNode: ASCollectionNode!
    
    // MARK: - Variable
    var card: Card!
    var adapter: ListAdapter!

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation item
        self.navigationItem.title = Localizations.cardMerge.title

        // Collection view
        self.collectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionNode.view.alwaysBounceVertical = true
        self.view.addSubnode(self.collectionNode)
        
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        self.adapter.setASDKCollectionNode(self.collectionNode)
        adapter.dataSource = self
        adapter.performUpdates(animated: true, completion: nil)
        
        self.observable()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self.view.traitCollection.userInterfaceIdiom == .pad && self.view.frame.size.width >= maxCollectionWidth {
            self.collectionNode.frame = CGRect(x: self.view.frame.size.width / 2 - maxCollectionWidth / 2, y: 0.0, width: maxCollectionWidth, height: self.view.frame.size.height)
        } else {
            self.collectionNode.frame = self.view.bounds
        }
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
            
            if let mergeObject = object.data as? Mergeable {
                let controller = mergeObject.mergeableSectionController
                if var cntrl = controller as? MergeSection {
                    cntrl.mergeDone = { () in
                        self.navigationController?.popViewController(animated: true)
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
    
    // MARK: - Private
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.cardMergeStyle
            
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
