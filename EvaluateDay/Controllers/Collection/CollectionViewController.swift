//
//  CollectionViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import IGListKit
import RealmSwift

class CollectionViewController: UIViewController, ListAdapterDataSource {

    // MARK: - UI
    var collectionNode: ASCollectionNode!
    
    // MARK: - Variables
    var adapter: ListAdapter!
    var date: Date! {
        didSet {
            self.dateObject = DateObject(date: self.date)
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    // MARK: - Objects
    private let cardsObject = CollectionCardsObject()
    private var dateObject = DateObject(date: Date())
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        self.navigationItem.title = Localizations.collection.title
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        // Collection view
        let layout = UICollectionViewFlowLayout()
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        self.collectionNode.view.alwaysBounceVertical = true
        self.collectionNode.accessibilityIdentifier = "collectionCollection"
        self.view.addSubnode(self.collectionNode)
        
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        self.adapter.setASDKCollectionNode(self.collectionNode)
        adapter.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateAppearance(animated: false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.collectionNode.frame = self.view.bounds
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
//            self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
            
            // Backgrounds
            self.navigationController!.view.backgroundColor = UIColor.background
            self.view.backgroundColor = UIColor.background
//            self.collectionNode.backgroundColor = UIColor.background
            
            // Empty view
//            self.emptyView.style = style
            
            // Collection View
//            self.adapter.performUpdates(animated: true, completion: { (_) in
//                self.collectionNode.reloadData()
//            })
        }
    }
    
    // MARK: - ListAdapterDataSource
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var diffableCards = [ListDiffable]()
        
        diffableCards.append(self.cardsObject)
        diffableCards.append(self.dateObject)
        
        return diffableCards
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        if object is CollectionCardsObject {
            return CollectionCardsSection()
        } else if let object = object as? DateObject {
            return DateSection(date: object.date)
        }
        
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
