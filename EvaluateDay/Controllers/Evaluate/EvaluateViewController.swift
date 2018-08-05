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
    let calendarObject = CalendarObject()
    let futureObject = FutureObject()
    
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
        } else {
            diffableCards.append(self.futureObject)
        }
        
        if self.date.start.days(to: Date().start) > pastDaysLimit && !Store.current.isPro && diffableCards.count != 0 {
            diffableCards.insert(self.proLockObject, at: 0)
        }
        
        if self.cards.count != 0 {
            diffableCards.insert(self.calendarObject, at: 0)
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
                cntrl.deleteHandler = { (indexPath, card) in
                    self.deleteCard(indexPath: indexPath, card: card)
                }
                cntrl.editHandler = { (indexPath, card) in
                    if card.data as? Editable != nil {
                        let controller = UIStoryboard(name: Storyboards.cardSettings.rawValue, bundle: nil).instantiateInitialViewController() as! CardSettingsViewController
                        controller.card = card
                        controller.titleString = Sources.title(forType: card.type)
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
                cntrl.mergeHandler = { (indexPath, card) in
                    if card.data as? Mergeable != nil {
                        let controller = UIStoryboard(name: Storyboards.cardMerge.rawValue, bundle: nil).instantiateInitialViewController() as! CardMergeViewController
                        controller.card = card
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
                cntrl.unarchiveHandler = { (indexPath, card) in
                    self.unarchiveCard(indexPath: indexPath, card: card)
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
        } else if object is CalendarObject {
            let section = CalendarSection()
            section.didSelectDate = { (date) in
                self.date = date
            }
            var newInsets = cardInsets
            newInsets.bottom = 50.0
            section.inset = newInsets
            return section
        } else if object is FutureObject {
            let section = FutureSection()
            section.shareAction = { () in
                self.shareAction()
            }
            section.inset = cardInsets
            return section
        }
        
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return self.emptyView
    }
    
    // MARK: - UIViewControllerPreviewingDelegate
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.collectionNode.indexPathForItem(at: location) else {
            return nil
        }
        
        if let section = self.adapter.sectionController(forSection: indexPath.section) as? EvaluableSection {
            let analytics = UIStoryboard(name: Storyboards.analytics.rawValue, bundle: nil).instantiateInitialViewController() as! AnalyticsViewController
            analytics.card = section.card
            return analytics
        }
        
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: false)
    }
    
    // MARK: - Actions
    @objc func activityButtonAction(_ sender: UIBarButtonItem) {
        let controller = UIStoryboard(name: Storyboards.activity.rawValue, bundle: nil).instantiateInitialViewController()!
        controller.modalPresentationStyle = .formSheet
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func settingsButtonAction(_ sender: UIBarButtonItem) {
        if self.view.traitCollection.userInterfaceIdiom == .phone {
            let controller = UIStoryboard(name: Storyboards.settings.rawValue, bundle: nil).instantiateInitialViewController()!
            self.present(controller, animated: true, completion: nil)
        } else {
            let controller = UIStoryboard(name: Storyboards.settingsSplit.rawValue, bundle: nil).instantiateInitialViewController()!
            controller.transition = SplitSettingsTransition(animationDuration: 0.4)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
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
    
    func deleteCard(indexPath: IndexPath, card: Card) {
        var message = Localizations.list.card.deleteMessage
        if !card.archived {
            message += "\n\n \(Localizations.list.card.archiveNotDelete) \n\n"
            message += Localizations.list.card.archiveMessage
        }
        
        let alert = UIAlertController(title: Localizations.general.sureQuestion, message: message, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: Localizations.general.cancel, style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: Localizations.general.delete, style: .destructive) { (_) in
            // Delete card
            sendEvent(.deleteCard, withProperties: ["type": card.type.string])
            try! Database.manager.data.write {
                card.data.deleteValues()
                card.isDeleted = true
            }
            
            Feedback.player.play(sound: .deleteCard, feedbackType: .success)
        }
        
        let archiveAction = UIAlertAction(title: Localizations.general.archive, style: .default) { (_) in
            // Archive card
            sendEvent(.archiveCard, withProperties: ["type": card.type.string])
            
            try! Database.manager.data.write {
                card.archived = true
                card.archivedDate = Date()
                card.edited = Date()
            }
            
            if let section = self.adapter.sectionController(forSection: indexPath.section) {
                section.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                    batchContext.reload(section)
                }, completion: nil)
            }
        }
        
        if !card.archived {
            alert.addAction(archiveAction)
        }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        if self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            let node = self.collectionNode.nodeForItem(at: indexPath) as! ActionsNode
            let b = node.button(forType: .delete)
            alert.popoverPresentationController?.sourceRect = b!.frame
            alert.popoverPresentationController?.sourceView = node.view
        }
        
        alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
        alert.view.layoutIfNeeded()
        self.present(alert, animated: true) {
            alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
        }
    }
    
    func unarchiveCard(indexPath: IndexPath, card: Card) {
        let alert = UIAlertController(title: Localizations.general.sureQuestion, message: Localizations.list.card.unarchiveMessage, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: Localizations.general.cancel, style: .cancel, handler: nil)
        let unarchiveAction = UIAlertAction(title: Localizations.general.unarchive, style: .default) { (_) in
            // Unarchive card
            try! Database.manager.data.write {
                card.archived = false
                card.archivedDate = nil
                card.edited = Date()
            }
            sendEvent(.unarchiveCard, withProperties: ["type": card.type.string])
            
            if let section = self.adapter.sectionController(forSection: indexPath.section) {
                section.collectionContext?.performBatch(animated: true, updates: { (batchContext) in
                    batchContext.reload(section)
                }, completion: nil)
            }
        }
        
        alert.addAction(cancelAction)
        alert.addAction(unarchiveAction)
        
        if self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            let node = self.collectionNode.nodeForItem(at: indexPath) as! UnarchiveNode
            alert.popoverPresentationController?.sourceRect = node.unarchiveButton.frame
            alert.popoverPresentationController?.sourceView = node.view
        }
        
        alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
        alert.view.layoutIfNeeded()
        self.present(alert, animated: true) {
            alert.view.tintColor = Themes.manager.evaluateStyle.actionSheetTintColor
        }
    }
    
    func shareAction() {
        
        let inView = CalendarShareView(message: Localizations.calendar.empty.futureQuote.text, author: Localizations.calendar.empty.futureQuote.author)
        
        // Share Image
        let sv = ShareView(view: inView)
        UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(sv)
        sv.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        sv.layoutIfNeeded()
        
        var items = [Any]()
        if let im = sv.snapshot {
            items.append(im)
        }
        
        sv.removeFromSuperview()
        
        // Make universal Branch Link
        let linkObject = BranchUniversalObject(canonicalIdentifier: "calendarShare")
        linkObject.title = Localizations.share.link.title
        linkObject.contentDescription = Localizations.share.description
        
        let linkProperties = BranchLinkProperties()
        linkProperties.feature = "Quote Share"
        linkProperties.channel = "Calendar"
        
        linkObject.getShortUrl(with: linkProperties) { (link, error) in
            if error != nil && link == nil {
                print(error!.localizedDescription)
            } else {
                items.append(link!)
            }
            
            let shareActivity = UIActivityViewController(activityItems: items, applicationActivities: nil)
            if self.traitCollection.userInterfaceIdiom == .pad {
                shareActivity.modalPresentationStyle = .popover
                let indexPath = IndexPath(row: 0, section: 1)
                let node = self.collectionNode.nodeForItem(at: indexPath) as! FutureNode
                shareActivity.popoverPresentationController?.sourceRect = node.shareButton.frame
                shareActivity.popoverPresentationController?.sourceView = node.view
            }
            sendEvent(.shareFromCalendar, withProperties: nil)
            self.present(shareActivity, animated: true, completion: nil)
        }
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
}
