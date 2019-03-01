//
//  SettingsIconsViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 26/06/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

@available(iOS 10.3, *)
class SettingsIconsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    // MARK: - UI
    @IBOutlet weak var collectionView: UICollectionView!
    
    var icons = [String]()
    
    // MARK: - Variables
    private let contentInset: CGFloat = 20.0
    private let iconCell = "iconCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set all icons
        for i in 0...11 {
            self.icons.append("AppIcon-\(i)")
        }

        // Set navigation Item
        self.navigationItem.title = Localizations.Settings.Themes.Select.icon
        
        // Analytics
        sendEvent(.openIcons, withProperties: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAppearance(animated: false)
    }
    
    override func updateAppearance(animated: Bool) {
        super.updateAppearance(animated: animated)
        
        let duration: TimeInterval = animated ? 0.2 : 0
        UIView.animate(withDuration: duration) {
            //set NavigationBar
            self.navigationController?.navigationBar.barTintColor = UIColor.background
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = UIColor.main
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.text]
            }
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            self.collectionView.backgroundColor = UIColor.background
        }
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.icons.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: iconCell, for: indexPath) as! IconCollectionViewCell
        cell.iconImage.image = UIImage(named: icon + "-Preview")
        if selected {
            cell.contentView.backgroundColor = UIColor.tint
        } else {
            cell.contentView.backgroundColor = UIColor.background
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Store.current.isPro {
            if indexPath.row == 0 {
                UIApplication.shared.setAlternateIconName(nil, completionHandler: nil)
            } else {
                let icon = self.icons[indexPath.row]
                UIApplication.shared.setAlternateIconName(icon, completionHandler: nil)
            }
            
            self.collectionView.reloadData()
            
            // Analytics
            sendEvent(.selectIcon, withProperties: ["icon": self.icons[indexPath.row]])
            
        } else {
            let controler = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateInitialViewController()!
            self.navigationController?.pushViewController(controler, animated: true)
        }
    }
}
