//
//  AnalyticsViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 23/10/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import RealmSwift

class AnalyticsViewController: UIViewController, ListAdapterDataSource {

    // MARK: - UI
    var collectionNode: ASCollectionNode!
    var settingsButton: UIBarButtonItem!
    
    // MARK: - Variable
    var card: Card!
    var adapter: ListAdapter!
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        self.navigationItem.title = Localizations.analytics.title
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        // Collection view
        self.collectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionNode.view.alwaysBounceVertical = true
        self.collectionNode.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 50.0, right: 0.0)
        self.view.addSubnode(self.collectionNode)
        
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        self.adapter.setASDKCollectionNode(self.collectionNode)
        adapter.dataSource = self
        
        // Buttons
        self.settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings").resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(openCardSettingsAction(sender:)))
        self.navigationItem.rightBarButtonItem = self.settingsButton
        
        self.observable()
        
        // Analytics
        sendEvent(.openAnalytics, withProperties: ["type": self.card.type.string])
        
        // Feedback
        Feedback.player.play(sound: .openAnalytics, hapticFeedback: true)
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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    // MARK: - ListAdapterDataSource
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [DiffCard(card: self.card)]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        
        if let object = object as? DiffCard {
            if object.data == nil {
                return ListSectionController()
            }
            
            if let data = object.data as? Analytical {
                let controller = data.analyticalSectionController
                if var cntrl = controller as? AnalyticalSection {
                    cntrl.shareHandler = { (indexPath, items) in
                        let shareActivity = UIActivityViewController(activityItems: items, applicationActivities: nil)
                        var shareType = "Unknown"
                        if self.traitCollection.userInterfaceIdiom == .pad {
                            shareActivity.modalPresentationStyle = .popover
                            if let node = self.collectionNode.nodeForItem(at: indexPath) as? TitleNode {
                                shareActivity.popoverPresentationController?.sourceView = node.view
                                shareActivity.popoverPresentationController?.sourceRect = node.shareButton.frame
                                shareType = "Statistics"
                            } else if let node = self.collectionNode.nodeForItem(at: indexPath) as? AnalyticsCalendarNode {
                                shareActivity.popoverPresentationController?.sourceRect = node.shareButton.frame
                                shareActivity.popoverPresentationController?.sourceView = node.view
                                shareType = "Calendar"
                            } else if let node = self.collectionNode.nodeForItem(at: indexPath) as? AnalyticsBarChartNode {
                                shareActivity.popoverPresentationController?.sourceRect = node.shareButton.frame
                                shareActivity.popoverPresentationController?.sourceView = node.view
                                shareType = "Bar Chart"
                            } else if let node = self.collectionNode.nodeForItem(at: indexPath) as? AnalyticsLineChartNode {
                                shareActivity.popoverPresentationController?.sourceRect = node.shareButton.frame
                                shareActivity.popoverPresentationController?.sourceView = node.view
                                shareType = "Line Chart"
                            } else {
                                shareActivity.popoverPresentationController?.sourceRect = self.collectionNode.frame
                                shareActivity.popoverPresentationController?.sourceView = self.view
                            }
                        } else {
                            if self.collectionNode.nodeForItem(at: indexPath) as? TitleNode != nil {
                                shareType = "Statistics"
                            } else if self.collectionNode.nodeForItem(at: indexPath) as? AnalyticsCalendarNode != nil {
                                shareType = "Calendar"
                            } else if self.collectionNode.nodeForItem(at: indexPath) as? AnalyticsBarChartNode != nil {
                                shareType = "Bar Chart"
                            } else if self.collectionNode.nodeForItem(at: indexPath) as? AnalyticsLineChartNode != nil {
                                shareType = "Line Chart"
                            }
                        }
                        
                        sendEvent(.shareFromAnalytics, withProperties: ["type": self.card.type.string, "share": shareType])
                        self.present(shareActivity, animated: true, completion: nil)
                    }
                    cntrl.exportHandler = { (indexPath, index, file) in
                        let vc = UIActivityViewController(activityItems: [file], applicationActivities: [])
                        
                        if self.view.traitCollection.userInterfaceIdiom == .pad {
                            if let node = self.collectionNode.nodeForItem(at: indexPath) as? AnalyticsExportNode {
                                let itemNode = node.collectionNode.nodeForItem(at: IndexPath(row: index, section: 0))!
                                vc.popoverPresentationController?.sourceRect = itemNode.frame
                                vc.popoverPresentationController?.sourceView = itemNode.view
                            } else {
                                vc.popoverPresentationController?.sourceRect = self.collectionNode.frame
                                vc.popoverPresentationController?.sourceView = self.view
                            }
                        }
                        
                        self.present(vc, animated: true, completion: nil)
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
    
    // MARK: - Actions
    @objc func openCardSettingsAction(sender: UIBarButtonItem) {
        let controller = UIStoryboard(name: Storyboards.cardSettings.rawValue, bundle: nil).instantiateInitialViewController() as! CardSettingsViewController
        controller.card = self.card
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Private
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.analyticalStyle
            
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
            self.adapter.performUpdates(animated: true, completion: { (_) in
                self.collectionNode.reloadData()
            })
        })
    }
}
