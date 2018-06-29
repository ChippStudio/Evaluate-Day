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
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var collectionCover: UIView!
    
    // MARK: - VAriables
    let colors = ["FFFFFF", "414C58", "D67500", "0F0F0F"]
    var selectedColor = "FFFFFF"
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set navigation Item
        self.navigationItem.title = Localizations.settings.themes.select.icon
        
        // set table node
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.collectionNode = ASCollectionNode(collectionViewLayout: layout)
        self.collectionNode.dataSource = self
        self.collectionNode.delegate = self
        self.collectionNode.view.alwaysBounceHorizontal = true
        self.collectionCover.addSubnode(self.collectionNode)
        
        // Set icon
        self.iconImage.layer.masksToBounds = true
        self.iconImage.layer.cornerRadius = 20.0
        
        if let icon = UIApplication.shared.alternateIconName {
            self.iconImage.image = UIImage(named: icon)
            if icon == "DarkAppIcon" {
                self.selectedColor = "414C58"
            } else if icon == "OrangeAppIcon" {
                self.selectedColor = "D67500"
            } else if icon == "BlackAppIcon" {
                self.selectedColor = "0F0F0F"
            }
        } else {
            self.iconImage.image = UIImage(named: "WhiteAppIcon")
            self.selectedColor = "FFFFFF"
        }
        
        // Analytics
        sendEvent(.openIcons, withProperties: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionNode.frame = self.collectionCover.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.observable()
    }
    
    // MARK: - ASCollectionDataSource
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let style = Themes.manager.evaluateStyle
        return {
            let node = ColorDotNode(color: self.colors[indexPath.row], style: style)
            if self.colors[indexPath.row] == self.selectedColor {
                node.colorSelected = true
            } else {
                node.colorSelected = false
            }
            return node
        }
    }
    
    // MARK: - ASCollectionDelegate
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        collectionNode.deselectItem(at: indexPath, animated: true)
        let color = self.colors[indexPath.row]
        let app = UIApplication.shared
        switch color {
        case "FFFFFF":
            app.setAlternateIconName(nil, completionHandler: nil)
            self.selectedColor = "FFFFFF"
            self.iconImage.image = UIImage(named: "WhiteAppIcon")
        case "414C58":
            app.setAlternateIconName("DarkAppIcon", completionHandler: nil)
            self.selectedColor = "414C58"
            self.iconImage.image = UIImage(named: "DarkAppIcon")
        case "D67500":
            app.setAlternateIconName("OrangeAppIcon", completionHandler: nil)
            self.selectedColor = "D67500"
            self.iconImage.image = UIImage(named: "OrangeAppIcon")
        case "0F0F0F":
            app.setAlternateIconName("BlackAppIcon", completionHandler: nil)
            self.selectedColor = "0F0F0F"
            self.iconImage.image = UIImage(named: "BlackAppIcon")
        default: ()
        }
        
        self.collectionNode.reloadData()
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
}
