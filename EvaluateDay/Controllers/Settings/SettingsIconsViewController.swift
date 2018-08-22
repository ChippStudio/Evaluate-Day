//
//  SettingsIconsViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 26/06/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

@available(iOS 10.3, *)
class SettingsIconsViewController: UIViewController, ASCollectionDelegate, ASCollectionDataSource {

    // MARK: - UI
    var collectionNode: ASCollectionNode!
    let icons = ["WhiteAppIcon", "WhiteAppIcon-Positive", "WhiteAppIcon-Negative", "DarkAppIcon", "DarkAppIcon-Positive", "DarkAppIcon-Negative", "OrangeAppIcon", "OrangeAppIcon-Positive", "OrangeAppIcon-Negative", "BlackAppIcon", "BlackAppIcon-Positive", "BlackAppIcon-Negative"]
    
    // MARK: - Variables
    private let contentInset: CGFloat = 20.0
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set navigation Item
        self.navigationItem.title = Localizations.settings.themes.select.icon
        
        // set table node
        let layout = self.calculateLayout()
         self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        self.collectionNode.dataSource = self
        self.collectionNode.delegate = self
        self.collectionNode.view.alwaysBounceVertical = true
        self.collectionNode.contentInset = UIEdgeInsets(top: 20.0, left: self.contentInset, bottom: 0.0, right: self.contentInset)
        self.view.addSubnode(self.collectionNode)
        
        // Analytics
        sendEvent(.openIcons, withProperties: nil)
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
        self.collectionNode.view.setCollectionViewLayout(self.calculateLayout(), animated: true)
        self.observable()
    }
    
    // MARK: - ASCollectionDataSource
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.icons.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let style = Themes.manager.settingsStyle
        let icon = self.icons[indexPath.row]
        var selected: Bool = false
        if let currentIcon = UIApplication.shared.alternateIconName {
            if currentIcon == icon {
                selected = true
            }
        } else {
            if indexPath.row == 0 {
                selected = true
            }
        }
        
        return {
            let node = SettingsIconSelectNode(icon: UIImage(named: icon + "-Preview"), selected: selected, style: style)
            node.isAccessibilityElement = true
            node.accessibilityLabel = icon
            node.accessibilityValue = "\(selected)"
            node.accessibilityTraits = UIAccessibilityTraitButton
            return node
        }
    }
    
    // MARK: - ASCollectionDelegate
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        collectionNode.deselectItem(at: indexPath, animated: true)
        
        if Store.current.isPro {
            if indexPath.row == 0 {
                UIApplication.shared.setAlternateIconName(nil, completionHandler: nil)
            } else {
                let icon = self.icons[indexPath.row]
                UIApplication.shared.setAlternateIconName(icon, completionHandler: nil)
            }
            
            self.collectionNode.reloadData()
            // Analytics
            sendEvent(.selectIcon, withProperties: ["icon": self.icons[indexPath.row]])
            
        } else {
            let controler = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
            self.navigationController?.pushViewController(controler, animated: true)
        }
    }

    // MARK: - Private
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.settingsStyle
            
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
        })
    }
    
    private func calculateLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        if self.view.traitCollection.userInterfaceIdiom == .pad {
            layout.itemSize = CGSize(width: 130.0, height: 130.0)
        } else {
            let width = self.view.frame.size.width - self.contentInset * 2
            let itemSize = width/3
            layout.itemSize = CGSize(width: itemSize, height: itemSize)
        }
        
        return layout
    }
}
