//
//  ActivityViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 10/03/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import FBSDKLoginKit
import RealmSwift
import SnapKit

class ActivityViewController: UIViewController, ListAdapterDataSource {

    // MARK: - UI
    var collectionNode: ASCollectionNode!
    
    // MARK: - Variables
    var adapter: ListAdapter!
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        self.navigationItem.title = Localizations.Activity.title
        self.navigationController?.navigationBar.accessibilityIdentifier = "activityNavigationBar"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        // Collection view
        let layout = UICollectionViewFlowLayout()
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        self.collectionNode.view.alwaysBounceVertical = true
        self.collectionNode.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 100.0, right: 0.0)
        self.collectionNode.accessibilityIdentifier = "activityCollection"
        self.view.insertSubview(self.collectionNode.view, at: 0)
        
        self.collectionNode.view.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
        }
        
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self, workingRangeSize: 0)
        self.adapter.setASDKCollectionNode(self.collectionNode)
        adapter.dataSource = self
        
        sendEvent(.openActivity, withProperties: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAppearance(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.text]
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.text]
            }
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            
            // Backgrounds
            self.navigationController?.navigationBar.barTintColor = UIColor.background
            self.view.backgroundColor = UIColor.background
            self.collectionNode.backgroundColor = UIColor.background
        }
    }
    
    // MARK: - Objects
    let userObject = ActivityUserObject()
    let proLock = ProLock()
    let analyticsObject = ActivityAnalyticsObject()
    let photoObject = ActivityPhotoObject()
    
    // MARK: - ListAdapterDataSource
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var diffableCards = [ListDiffable]()
        
        diffableCards.append(self.userObject)
        if !Store.current.isPro {
            diffableCards.append(self.proLock)
        }
        diffableCards.append(self.analyticsObject)
        diffableCards.append(self.photoObject)
        return diffableCards
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is ActivityUserObject {
            let section = ActivityUserSection()
            section.didFacebookPressed = { (sec) in
                if FBSDKAccessToken.current() == nil {
                    FBSDKLoginManager().logIn(withReadPermissions: ["public_profile", "email"], from: self, handler: { (result, error) in
                        if error != nil {
                            //Show error message
                        } else if result != nil {
                            if result!.isCancelled {
                                // Cancelid Facebook login
                            } else {
                                // Success login
                                self.facebookRequest(section: sec)
                            }
                        }
                    })
                } else {
                    self.facebookRequest(section: sec)
                }
            }
            return section
        } else if object is ProLock {
            let section = ProLockSection()
            section.inset = cardInsets
            section.didSelectPro = { () in
                let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
                self.navigationController?.pushViewController(controller, animated: true)
            }
            return section
        } else if object is ActivityAnalyticsObject {
            let section = ActivityAnalyticsSection()
            return section
        } else if object is ActivityPhotoObject {
            let section = ActivityPhotoSection()
            section.inset = UIEdgeInsets(top: 70.0, left: 0.0, bottom: 0.0, right: 0.0)
            return section
        }
        
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
    
    // MARK: - Private
    private func facebookRequest(section: ListSectionController) {
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, picture.type(large)"])
        _ = request?.start(completionHandler: { (_, result, _) in
            guard let userInfo = result as? [String: Any] else { return }
            
            if let imageURL = ((userInfo["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String {
                //Download image from imageURL
                do {
                    let imageData = try Data(contentsOf: URL(string: imageURL)!)
                    try Database.manager.app.write {
                        Database.manager.application.user.avatar = imageData
                    }
                } catch {
                    
                }
            }
            
            if let userName = userInfo["name"] as? String {
                try! Database.manager.app.write {
                    Database.manager.application.user.name = userName
                }
            }
            if let userEmail = userInfo["email"] as? String {
                try! Database.manager.app.write {
                    Database.manager.application.user.email = userEmail
                }
            }
            
            section.collectionContext?.performBatch(animated: true, updates: { (context) in
                context.reload(section)
            }, completion: { (_) in
                //
            })
        })
    }
}
