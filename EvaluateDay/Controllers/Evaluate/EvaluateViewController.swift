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

class EvaluateViewController: UIViewController, ListAdapterDataSource, UIViewControllerPreviewingDelegate {
    // MARK: - UI
    var newCardButton: UIBarButtonItem!
    var reorderCardsButton: UIBarButtonItem!
    var collectionNode: ASCollectionNode!
    var emptyView = CardListEmptyView()
    
    // MARK: - Variable
    var date: Date = Date() {
        didSet {
            self.navigationItem.title = DateFormatter.localizedString(from: self.date, dateStyle: .medium, timeStyle: .none)
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
    let proLockObject = ProLock()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get cards
        self.cards = Database.manager.data.objects(Card.self).filter("isDeleted=%@", false).sorted(byKeyPath: "order")
        
        // Navigation bar
        self.navigationItem.title = DateFormatter.localizedString(from: self.date, dateStyle: .medium, timeStyle: .none)
        self.navigationController?.navigationBar.accessibilityIdentifier = "evaluateNavigationBar"
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        // bar buttons button
        self.newCardButton = UIBarButtonItem(image: #imageLiteral(resourceName: "new").resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(newCardButtonAction(sender:)))
        self.newCardButton.accessibilityIdentifier = "newCardButton"
        self.reorderCardsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "reorder").resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(reorderCardsAction(sender:)))
        self.reorderCardsButton.accessibilityIdentifier = "reorderButton"
        
        // Collection view
        let layout = UICollectionViewFlowLayout()
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        self.collectionNode.view.alwaysBounceVertical = true
        self.collectionNode.accessibilityIdentifier = "evaluateCollection"
        self.view.addSubnode(self.collectionNode)
        
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        self.adapter.setASDKCollectionNode(self.collectionNode)
        adapter.dataSource = self
        
        // Empty view
        self.emptyView.newButton.addTarget(self, action: #selector(self.newCardButtonAction(sender:)), for: .touchUpInside)
        
        // Themes Set
        self.observable()
        
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
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        self.collectionNode.frame = self.view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Get cards token
        self.cardsToken = self.cards.observe({ (c) in
            switch c {
            case .initial(_):
                self.adapter.performUpdates(animated: true, completion: nil)
            case .update(_, deletions: let deleted, insertions: let inserted, modifications: _):
                if inserted.count != 0 || deleted.count != 0 {
                    self.adapter.performUpdates(animated: true, completion: nil)
                }
            case .error(let error):
                print("ERROR - \(error.localizedDescription)")
            }
        })
        self.date = Date()
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
                let diffCard = DiffCard(card: c)
                diffableCards.append(diffCard)
            }
        }
        
        if self.date.start.days(to: Date().start) > pastDaysLimit && !Store.current.isPro && diffableCards.count != 0 {
            diffableCards.insert(self.proLockObject, at: 0)
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
                cntrl.shareHandler = { (indexPath, bcard, items) in
                    
                    let shareActivity = UIActivityViewController(activityItems: items, applicationActivities: nil)
                    if self.traitCollection.userInterfaceIdiom == .pad {
                        shareActivity.modalPresentationStyle = .popover
                        let node = self.collectionNode.nodeForItem(at: indexPath) as! CardNode
                        shareActivity.popoverPresentationController?.sourceRect = node.title.shareButton.frame
                        shareActivity.popoverPresentationController?.sourceView = node.title.view
                    }
                    sendEvent(.shareFromEvaluateDay, withProperties: ["type": bcard.type.string])
                    self.present(shareActivity, animated: true, completion: nil)
                }
                cntrl.didSelectItem = { (index, card) in
                    let analytycs = UIStoryboard(name: Storyboards.analytics.rawValue, bundle: nil).instantiateInitialViewController() as! AnalyticsViewController
                    analytycs.card = card
                    self.navigationController?.pushViewController(analytycs, animated: true)
                }
            }
            return controller
        } else if object as? ProLock != nil {
            let section = ProLockSection()
            section.inset = cardInsets
            section.didSelectPro = { () in
                let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
                self.navigationController?.pushViewController(controller, animated: true)
            }
            return section
        }
        
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return self.emptyView
    }
    
    // MARK: - UIViewControllerPreviewingDelegate
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.collectionNode.indexPathForItem(at: location), let targetCell = collectionNode.view.visibleCells.first(where: { $0.frame.contains(location) }) else {
            return nil
        }
        
        previewingContext.sourceRect = targetCell.frame
        
        if let section = self.adapter.sectionController(forSection: indexPath.section) as? EvaluableSection {
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
        
        if Database.manager.app.objects(AppUsage.self).count % 10 == 0 && Database.manager.app.objects(Card.self).count <= 1 {
            if #available(iOS 10.3, *) {
                sendEvent(.showAppRate, withProperties: nil)
                SKStoreReviewController.requestReview()
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.evaluateStyle
            
            // Status bar
            UIApplication.shared.statusBarStyle = style.statusBarStyle
            
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
            self.navigationController!.view.backgroundColor = style.background
            self.view.backgroundColor = style.background
            self.collectionNode.backgroundColor = style.background
            
            // Empty view
            self.emptyView.style = style
            
            // Collection View
            self.adapter.performUpdates(animated: true, completion: { (_) in
                self.collectionNode.reloadData()
            })
        })
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
