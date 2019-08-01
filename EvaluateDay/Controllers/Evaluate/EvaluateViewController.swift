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

class EvaluateViewController: UIViewController, ListAdapterDataSource, UIViewControllerPreviewingDelegate, DateSectionProtocol, AnalyticsPreviewDelegate {
    
    // MARK: - UI
    var newCardButton: UIBarButtonItem!
    var reorderCardsButton: UIBarButtonItem!
    var collectionNode: ASCollectionNode!
    
    // MARK: - Variable
    var date: Date = Date() {
        didSet {
            // FIXME: - Think about it
//            if let split = self.universalSplitController as? SplitController {
//                split.date = self.date
//            }
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
            if cardType == nil {
                return
            }
            self.navigationItem.title = Sources.title(forType: cardType)
            if self.adapter == nil {
                return
            }
            self.adapter.performUpdates(animated: true, completion: nil)
        }
    }
    
    var scrollToCard: String!
    var cardAction: SiriShortcutItem!
    
    // MARK: - Objects
    private let proLockObject = ProLock()
    private let dateObject = DateObject(date: Date())
    private let emptyObject = EvaluateEmptyCardObject()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get cards
        self.setCards()
        
        // Navigation bar and activity
        if self.cardType != nil {
            self.navigationItem.title = Sources.title(forType: cardType!)
            let activity = NSUserActivity(activityType: SiriShortcutItem.evaluate.rawValue)
            let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
            if #available(iOS 12.0, *) {
                activity.persistentIdentifier = NSUserActivityPersistentIdentifier("\(self.cardType)")
                activity.isEligibleForPrediction = true
            }
            activity.title = Localizations.Siri.Shortcut.General.Evaluate.title(self.cardType.string)
            attributes.contentDescription = Localizations.Siri.Shortcut.General.Evaluate.description
            if #available(iOS 12.0, *) {
                activity.suggestedInvocationPhrase = Localizations.Siri.Shortcut.General.Evaluate.suggest
            }
            activity.userInfo = ["card_type": "\(self.cardType.rawValue)"]
            activity.contentAttributeSet = attributes
            self.userActivity = activity
            self.userActivity?.becomeCurrent()
        } else if self.collection != nil {
            if let dashboard = Database.manager.data.objects(Dashboard.self).filter("id=%@", self.collection!).first {
                self.navigationItem.title = dashboard.title
                self.userActivity = dashboard.shortcut
                self.userActivity?.becomeCurrent()
            } else {
                self.navigationItem.title = Localizations.Collection.titlePlaceholder
            }
        } else {
            self.navigationItem.title = Localizations.Collection.allcards
            let activity = NSUserActivity(activityType: SiriShortcutItem.evaluate.rawValue)
            let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
            if #available(iOS 12.0, *) {
                activity.persistentIdentifier = NSUserActivityPersistentIdentifier("All Cards")
                activity.isEligibleForPrediction = true
            }
            activity.title = Localizations.Siri.Shortcut.General.Evaluate.title(Localizations.Collection.allcards)
            attributes.contentDescription = Localizations.Siri.Shortcut.General.Evaluate.description
            if #available(iOS 12.0, *) {
                activity.suggestedInvocationPhrase = Localizations.Siri.Shortcut.General.Evaluate.suggest
            }
            activity.contentAttributeSet = attributes
            self.userActivity = activity
            self.userActivity?.becomeCurrent()
        }
        // navigation
        self.navigationController?.navigationBar.accessibilityIdentifier = "evaluateNavigationBar"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
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
        
        self.navigationItem.setRightBarButtonItems([self.newCardButton, self.reorderCardsButton], animated: true)
        
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
        }
        
        if UserDefaults.standard.bool(forKey: "demo") {
            let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(makeCardSnapshot(sender:)))
            tapGesture.numberOfTouchesRequired = 2
            self.view.addGestureRecognizer(tapGesture)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setCards), name: NSNotification.Name.CardsSortedDidChange, object: nil)
        
        sendEvent(Analytics.openEvaluate, withProperties: ["card_type": self.cardType == nil ? false : self.cardType.string,
                                                           "collection": self.collection == nil ? false : true])
    }
    
    @objc private func setCards() {
        self.cards = Database.manager.data.objects(Card.self).filter(Sources.predicate).sorted(byKeyPath: Sources.sorted, ascending: Sources.ascending)
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            self.collectionNode.backgroundColor = UIColor.background
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // FIXME: - Think about it
//        if let split = self.universalSplitController as? SplitController {
//            self.date = split.date
//        }
        if let section = self.adapter.sectionController(for: self.dateObject) as? DateSection {
            section.date = self.date
            section.isEdit = false
            section.collectionContext?.performBatch(animated: false, updates: { (batchContext) in
                batchContext.reload(section)
            }, completion: nil)
        }
        self.setCards()
        self.updateAppearance(animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.scrollToCard != nil {
            if let card = Database.manager.data.objects(Card.self).filter("id=%@ AND isDeleted=%@", self.scrollToCard!, false).first {
                self.adapter.scroll(to: DiffCard(card: card), supplementaryKinds: nil, scrollDirection: .vertical, scrollPosition: .top, animated: true)
                
                if self.cardAction != nil {
                    Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { (_) in
                        if let section = self.adapter.sectionController(for: DiffCard(card: card)) as? EvaluableSection {
                            section.performAction(for: self.cardAction)
                            self.cardAction = nil
                        }
                    }
                }
                
                self.scrollToCard = nil
            }
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.controlUserReview(sender:)), name: UIApplication.didBecomeActiveNotification, object: nil)
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
            let analyticsPreview = UIStoryboard(name: Storyboards.analyticsPreview.rawValue, bundle: nil).instantiateInitialViewController() as! AnalyticsPreviewViewController
            analyticsPreview.preferredContentSize = CGSize(width: 0.0, height: 300.0)
            analyticsPreview.card = section.card
            analyticsPreview.delegate = self
            return analyticsPreview
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if let preview = viewControllerToCommit as? AnalyticsPreviewViewController {
            let analytics = UIStoryboard(name: Storyboards.analytics.rawValue, bundle: nil).instantiateInitialViewController() as! AnalyticsViewController
            analytics.card = preview.card
            self.navigationController?.pushViewController(analytics, animated: false)
        }
    }
    
    // MARK: - AnalyticsPreviewDelegate
    func analyticsPreview(controller: AnalyticsPreviewViewController, didSelect action: UIPreviewAction, for previewedController: UIViewController) {
        switch action.title {
        case Localizations.General.Action.analytics:
            let analytics = UIStoryboard(name: Storyboards.analytics.rawValue, bundle: nil).instantiateInitialViewController() as! AnalyticsViewController
            analytics.card = controller.card
            self.navigationController?.pushViewController(analytics, animated: false)
        case Localizations.General.edit:
            let edit = UIStoryboard(name: Storyboards.cardSettings.rawValue, bundle: nil).instantiateInitialViewController() as! CardSettingsViewController
            edit.card = controller.card
            self.navigationController?.pushViewController(edit, animated: false)
        case Localizations.CardMerge.action:
            let merge = UIStoryboard(name: Storyboards.cardMerge.rawValue, bundle: nil).instantiateInitialViewController() as! CardMergeViewController
            merge.card = controller.card
            self.navigationController?.pushViewController(merge, animated: false)
        case Localizations.General.archive:
            try! Database.manager.data.write {
                controller.card.archived = true
                controller.card.archivedDate = Date()
                controller.card.edited = Date()
            }
        case Localizations.General.unarchive:
            try! Database.manager.data.write {
                controller.card.archived = false
                controller.card.archivedDate = nil
                controller.card.edited = Date()
            }
        default:
            break
        }
    }
    
    // MARK: - Actions
    @objc func newCardButtonAction(sender: UIBarButtonItem) {
        let controller = UIStoryboard(name: Storyboards.newCard.rawValue, bundle: nil).instantiateInitialViewController() as! NewCardViewController
        controller.cardType = self.cardType
        controller.collectionID = self.collection
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func reorderCardsAction(sender: UIBarButtonItem) {
        let controller = UIStoryboard(name: Storyboards.reorderCards.rawValue, bundle: nil).instantiateInitialViewController()!
        self.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Private
    private var isShowedReviewPopUp = false
    @objc private func controlUserReview(sender: Notification?) {
        // Automation app review requist
        if UserDefaults.standard.bool(forKey: "demo") || UserDefaults.standard.bool(forKey: "FASTLANE_SNAPSHOT") {
            return
        }
        
        if Database.manager.app.objects(AppUsage.self).count % 20 == 0 && Database.manager.app.objects(Card.self).count <= 1 && !self.isShowedReviewPopUp {
            if #available(iOS 10.3, *) {
                self.isShowedReviewPopUp = true
                sendEvent(.showAppRate, withProperties: nil)
                SKStoreReviewController.requestReview()
            }
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
