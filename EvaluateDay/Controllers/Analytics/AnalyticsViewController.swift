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
        self.navigationItem.title = Localizations.Analytics.title
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        // Collection view
        self.collectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionNode.view.alwaysBounceVertical = true
        self.collectionNode.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 50.0, right: 0.0)
        self.collectionNode.accessibilityIdentifier = "AnalyticsCollection"
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
        
        // Buttons
        self.settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings").resizedImage(newSize: CGSize(width: 22.0, height: 22.0)), style: .plain, target: self, action: #selector(openCardSettingsAction(sender:)))
        self.settingsButton.accessibilityIdentifier = "cardSettingsButton"
        self.settingsButton.accessibilityLabel = Localizations.Tabbar.settings
        self.settingsButton.accessibilityValue = self.card.title
        self.navigationItem.rightBarButtonItem = self.settingsButton
        
        // Analytics
        sendEvent(.openAnalytics, withProperties: ["type": self.card.type.string])
        
        // Feedback
        Feedback.player.play(sound: .openAnalytics, hapticFeedback: true)
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
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.text]
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.text]
            }
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            self.collectionNode.backgroundColor = UIColor.background
        }
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
                
                controller.inset = UIEdgeInsets(top: 30.0, left: 0.0, bottom: 0.0, right: 0.0)
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
}
