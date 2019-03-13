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

class CollectionViewController: UIViewController, ListAdapterDataSource, DateSectionProtocol {
    
    // MARK: - UI
    var collectionNode: ASCollectionNode!
    var reorderButton: UIBarButtonItem!
    
    // MARK: - Variables
    var collections: Results<Dashboard>!
    var collectionToken: NotificationToken!
    var adapter: ListAdapter!
    var date: Date = Date() {
        didSet {
            if let split = self.universalSplitController as? SplitController {
                split.date = self.date
            }
            self.dateObject.date = self.date
            if self.adapter == nil {
                return
            }
            self.adapter.performUpdates(animated: true) { (done) in
                if done {
                    for c in self.collections {
                        if let section = self.adapter.sectionController(for: DiffCollection(collection: c)) as? CollectionListSection {
                            section.date = self.date
                            section.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                                batchContext.reload(section)
                            }, completion: nil)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Objects
    private let cardsObject = CollectionCardsObject()
    private var dateObject = DateObject(date: Date())
    private let actionObject = CollectionActionsObject()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        self.navigationItem.title = Localizations.Collection.title
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        self.navigationController?.navigationBar.accessibilityIdentifier = "collectionNavigationBar"
        
        // Set collections
        self.setCollections()
        
        // Collection view
        let layout = UICollectionViewFlowLayout()
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        self.collectionNode.view.alwaysBounceVertical = true
        self.collectionNode.accessibilityIdentifier = "collectionCollection"
        self.view.addSubnode(self.collectionNode)
        
        self.collectionNode.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            if #available(iOS 11.0, *) {
                make.leading.equalTo(self.view.safeAreaLayoutGuide)
                make.trailing.equalTo(self.view.safeAreaLayoutGuide)
            } else {
                make.leading.equalTo(self.view)
                make.trailing.equalTo(self.view)
            }
        }
        
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        self.adapter.setASDKCollectionNode(self.collectionNode)
        adapter.dataSource = self
        
        self.reorderButton = UIBarButtonItem(image: Images.Media.reorder.image.resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(self.reorderButtonAction(sender:)))
        self.navigationItem.rightBarButtonItem = self.reorderButton
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setCollections), name: NSNotification.Name.CollectionsSortedDidChange, object: nil)
        
        sendEvent(Analytics.openCollections, withProperties: nil)
    }
    
    @objc private func setCollections() {
        self.collections = Database.manager.data.objects(Dashboard.self).filter("isDeleted=%@", false).sorted(byKeyPath: Sources.sortedCollection, ascending: Sources.ascendingCollection)
        // Get cards token
        self.collectionToken = self.collections.observe({ (c) in
            switch c {
            case .initial(_):
                self.adapter.performUpdates(animated: true, completion: nil)
            case .update(_, deletions: let deleted, insertions: let inserted, modifications: let modificated):
                if inserted.count != 0 || deleted.count != 0 || modificated.count != 0 {
                    self.adapter.performUpdates(animated: true, completion: nil)
                }
            case .error(let error):
                print("ERROR - \(error.localizedDescription)")
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let split = self.universalSplitController as? SplitController {
            self.date = split.date
        }
        if let section = self.adapter.sectionController(for: self.dateObject) as? DateSection {
            section.date = self.date
            section.isEdit = false
            section.collectionContext?.performBatch(animated: false, updates: { (batchContext) in
                batchContext.reload(section)
            }, completion: nil)
        }
        self.setCollections()
        self.updateAppearance(animated: false)
    }
    
    override func updateAppearance(animated: Bool) {
        super.updateAppearance(animated: animated)
        
        if animated {
            for object in self.adapter.objects() {
                if let section = self.adapter.sectionController(for: object) {
                    section.collectionContext?.performBatch(animated: false, updates: { (batchContext) in
                        batchContext.reload(section)
                    }, completion: nil)
                }
            }
        }
        
        let duration: TimeInterval = animated ? 0.2 : 0
        UIView.animate(withDuration: duration) {
            
            //set NavigationBar
            self.navigationController?.navigationBar.barTintColor = UIColor.background
            self.navigationController?.navigationBar.tintColor = UIColor.main
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
            }
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "collections")?.resizedImage(newSize: CGSize(width: 20.0, height: 20.0)), style: .plain, target: nil, action: nil)
            
            // Backgrounds
            self.navigationController!.view.backgroundColor = UIColor.background
            self.view.backgroundColor = UIColor.background
            self.collectionNode.backgroundColor = UIColor.background
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.collectionToken != nil {
            self.collectionToken.invalidate()
        }
    }
    
    // MARK: - ListAdapterDataSource
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var diffableCards = [ListDiffable]()
        
        diffableCards.append(self.cardsObject)
        diffableCards.append(self.dateObject)
        if !Store.current.isPro {
            diffableCards.append(ProLock())
        }
        diffableCards.append(self.actionObject)
        
        for c in self.collections {
            diffableCards.append(DiffCollection(collection: c))
        }
        
        return diffableCards
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        if object is CollectionCardsObject {
            let section = CollectionCardsSection(date: self.date)
            section.inset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 35.0, right: 0.0)
            return section
        } else if let object = object as? DateObject {
            let section = DateSection(date: object.date)
            section.inset = UIEdgeInsets(top: 35.0, left: 0.0, bottom: 35.0, right: 0.0)
            return section
        } else if object is CollectionActionsObject {
            let section = CollectionActionsSection()
            section.inset = UIEdgeInsets(top: 35.0, left: 0.0, bottom: 10.0, right: 0.0)
            return section
        } else if object is ProLock {
            let section = ProLockSection()
            section.didSelectPro = { () in
                let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
                self.universalSplitController?.pushSideViewController(controller)
            }
            section.inset = UIEdgeInsets(top: 35.0, left: 0.0, bottom: 35.0, right: 0.0)
            return section
        } else if let object = object as? DiffCollection {
            let section = CollectionListSection(collection: object.data)
            section.inset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 10.0, right: 0.0)
            return section
        }
        
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    // MARK: - Actions
    @objc func reorderButtonAction(sender: UIBarButtonItem) {
        let controller = UIStoryboard(name: Storyboards.reorderCollections.rawValue, bundle: nil).instantiateInitialViewController()!
        self.present(controller, animated: true, completion: nil)
    }
}
