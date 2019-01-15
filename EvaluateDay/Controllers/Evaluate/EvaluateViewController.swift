//
//  EvaluateViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import IGListKit
import RealmSwift
import Branch
import StoreKit

class EvaluateViewController: UIViewController, ListAdapterDataSource, UIViewControllerPreviewingDelegate, DateSectionProtocol {
    
    // MARK: - UI
    var newCardButton: UIBarButtonItem!
    var reorderCardsButton: UIBarButtonItem!
    var collectionNode: ASCollectionNode!
    
    // MARK: - Variable
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
                    for c in self.cards {
                        if var section = self.adapter.sectionController(for: DiffCard(card: c)) as? EvaluableSection {
                            section.date = self.date
                            (section as! ListSectionController).collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                                batchContext.reload(section as! ListSectionController)
                            }, completion: nil)
                        }
                    }
                }
            }
        }
    }
    var cards: Results<Card>!
    private var cardsToken: NotificationToken!
    var adapter: ListAdapter!
    var collection: String! {
        didSet {
            if self.adapter == nil {
                return
            }
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    var cardType: CardType! {
        didSet {
            self.navigationItem.title = Sources.title(forType: cardType)
            if self.adapter == nil {
                return
            }
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    // MARK: - Objects
    private let proLockObject = ProLock()
    private let dateObject = DateObject(date: Date())
    private let emptyObject = EvaluateEmptyCardObject()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get cards
        self.cards = Database.manager.data.objects(Card.self).filter("isDeleted=%@", false).sorted(byKeyPath: "order")
        
        // Navigation bar
        if self.cardType != nil {
            self.navigationItem.title = Sources.title(forType: cardType)
        } else if self.collection != nil {
            if let dashboard = Database.manager.data.objects(Dashboard.self).filter("id=%@", self.collection!).first {
                self.navigationItem.title = dashboard.title
            } else {
                self.navigationItem.title = Localizations.Collection.titlePlaceholder
            }
        } else {
            self.navigationItem.title = Localizations.Collection.allcards
        }
        self.navigationController?.navigationBar.accessibilityIdentifier = "evaluateNavigationBar"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        // bar buttons button
        self.newCardButton = UIBarButtonItem(image: #imageLiteral(resourceName: "new").resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(newCardButtonAction(sender:)))
        self.newCardButton.accessibilityIdentifier = "newCardButton"
        self.newCardButton.accessibilityLabel = Localizations.General.Shortcut.New.title
        
        self.reorderCardsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "reorder").resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(reorderCardsAction(sender:)))
        self.reorderCardsButton.accessibilityIdentifier = "reorderButton"
        self.reorderCardsButton.accessibilityLabel = Localizations.Accessibility.Evaluate.reorder
        
        // Collection view
        let layout = UICollectionViewFlowLayout()
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        self.collectionNode.view.alwaysBounceVertical = true
        self.collectionNode.accessibilityIdentifier = "evaluateCollection"
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
        
        // Force Touch
        if self.traitCollection.forceTouchCapability == .available {
            self.registerForPreviewing(with: self, sourceView: self.collectionNode.view)
        } else {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(sender:)))
            longPress.minimumPressDuration = 0.5
            self.view.addGestureRecognizer(longPress)
        }
        
        if UserDefaults.standard.bool(forKey: "demo") {
            let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(makeCardSnapshot(sender:)))
            tapGesture.numberOfTouchesRequired = 2
            self.view.addGestureRecognizer(tapGesture)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        // Get cards token
        self.cardsToken = self.cards.observe({ (c) in
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
        self.updateAppearance(animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.controlUserReview(sender: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.controlUserReview(sender:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.cardsToken != nil {
            self.cardsToken.invalidate()
        }
    }
    
    // MARK: - ListAdapterDataSource
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var diffableCards = [ListDiffable]()
        if self.date < Date() {
            for c in self.cards {
                if self.collection != nil {
                    if c.dashboard != nil {
                        if c.dashboard! == self.collection! {
                            let diffCard = DiffCard(card: c)
                            diffableCards.append(diffCard)
                        }
                    }
                } else if self.cardType != nil {
                    if c.type == self.cardType {
                        let diffCard = DiffCard(card: c)
                        diffableCards.append(diffCard)
                    }
                } else {
                    let diffCard = DiffCard(card: c)
                    diffableCards.append(diffCard)
                }
            }
        }
        if diffableCards.isEmpty {
            diffableCards.append(self.emptyObject)
        }
        
        diffableCards.insert(self.dateObject, at: 0)
        
        if self.date.start.days(to: Date().start) > pastDaysLimit && !Store.current.isPro && diffableCards.count != 0 {
            diffableCards.insert(self.proLockObject, at: 1)
        }
        
        if self.cards.isEmpty || self.cards.count == 1 {
            self.navigationItem.setRightBarButtonItems([self.newCardButton], animated: true)
        } else {
            self.navigationItem.setRightBarButtonItems([self.newCardButton, self.reorderCardsButton], animated: true)
        }
        
        return diffableCards
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        if let object = object as? DiffCard {
            if object.data == nil {
                return ListSectionController()
            }
            
            let controller = object.data!.evaluateSectionController
            controller.inset = cardInsets
            if var cntrl = controller as? EvaluableSection {
                cntrl.date = self.date
                cntrl.didSelectItem = { (index, card) in
                    let analytycs = UIStoryboard(name: Storyboards.analytics.rawValue, bundle: nil).instantiateInitialViewController() as! AnalyticsViewController
                    analytycs.card = card
                    self.navigationController?.pushViewController(analytycs, animated: true)
                }
            }
            return controller
        } else if object is ProLock {
            let section = ProLockSection()
            section.inset = cardInsets
            section.didSelectPro = { () in
                let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
                self.navigationController?.pushViewController(controller, animated: true)
            }
            return section
        } else if object is EvaluateEmptyCardObject {
            var type: CardsEmptyType
            if self.collection != nil {
                type = .collection
            } else if self.cardType != nil {
                type = .type
            } else {
                type = .all
            }
            let section = EvaluateEmptyCardSection(type: type)
            section.inset = cardInsets
            return section
        } else if let object = object as? DateObject {
            let section = DateSection(date: object.date)
            section.inset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 20.0, right: 0.0)
            return section
        }
        
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    // MARK: - UIViewControllerPreviewingDelegate
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.collectionNode.indexPathForItem(at: location), let targetCell = collectionNode.view.visibleCells.first(where: { $0.frame.contains(location) }) else {
            return nil
        }
        
        if let section = self.adapter.sectionController(forSection: indexPath.section) as? EvaluableSection {
            previewingContext.sourceRect = targetCell.frame
            let settings = UIStoryboard(name: Storyboards.cardSettings.rawValue, bundle: nil).instantiateInitialViewController() as! CardSettingsViewController
            settings.card = section.card
            return settings
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: false)
    }
    
    // MARK: - Actions
    
    @objc func newCardButtonAction(sender: UIBarButtonItem) {
        let controller = UIStoryboard(name: Storyboards.newCard.rawValue, bundle: nil).instantiateInitialViewController()!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func reorderCardsAction(sender: UIBarButtonItem) {
        let controller = ReorderBottomViewController()
        controller.cards = self.cards
        controller.closeByTap = true
        self.present(controller, animated: true, completion: nil)
    }
    
    func scrollToCard(cardID: String) {
        for (i, c) in self.cards.enumerated() {
            if c.id == cardID {
                let indexPath = IndexPath(row: 0, section: i)
                self.collectionNode.scrollToItem(at: indexPath, at: .top, animated: true)
                break
            }
        }
    }
    @objc func longPressAction(sender: UILongPressGestureRecognizer) {
        guard let indexPath = self.collectionNode.indexPathForItem(at: sender.location(in: self.collectionNode.view)) else {
            return
        }
        
        if self.navigationController?.topViewController is EvaluateViewController {
            if let section = self.adapter.sectionController(forSection: indexPath.section) as? EvaluableSection {
                let settings = UIStoryboard(name: Storyboards.cardSettings.rawValue, bundle: nil).instantiateInitialViewController() as! CardSettingsViewController
                settings.card = section.card
                self.navigationController?.pushViewController(settings, animated: true)
            }
        }
    }
    
    // MARK: - Private
    @objc private func controlUserReview(sender: Notification?) {
        // Automation app review requist
        if UserDefaults.standard.bool(forKey: "demo") || UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") {
            return
        }
        
        if Database.manager.application.isAlreadyRateThisVersion {
            return
        }
        
        if Database.manager.app.objects(AppUsage.self).count % 20 == 0 && Database.manager.app.objects(Card.self).count <= 1 {
            let alert = UIAlertController(title: Localizations.General.like, message: nil, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: Localizations.General.yes, style: .default) { (_) in
                try! Database.manager.app.write {
                    Database.manager.application.isAlreadyRateThisVersion = true
                }
                if #available(iOS 10.3, *) {
                    sendEvent(.showAppRate, withProperties: ["like": NSNumber(value: true)])
                    SKStoreReviewController.requestReview()
                } else {
                    // Fallback on earlier versions
                }
            }
            
            let noAction = UIAlertAction(title: Localizations.General.no, style: .default) { (_) in
                try! Database.manager.app.write {
                    Database.manager.application.isAlreadyRateThisVersion = true
                }
                sendEvent(.showAppRate, withProperties: ["like": NSNumber(value: false)])
            }
            
            alert.addAction(yesAction)
            alert.addAction(noAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc private func makeCardSnapshot(sender: UILongPressGestureRecognizer) {
        guard let node = collectionNode.view.visibleCells.first(where: { $0.frame.contains(sender.location(in: self.collectionNode.view)) }) else {
            print("Not the collection node")
            return
        }
        
        if let image = node.snapshot {
            let shareActivity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            if self.traitCollection.userInterfaceIdiom == .pad {
                shareActivity.modalPresentationStyle = .popover
                shareActivity.popoverPresentationController?.sourceRect = node.frame
                shareActivity.popoverPresentationController?.sourceView = node.contentView
            }
            self.present(shareActivity, animated: true, completion: nil)
        }
    }
}
