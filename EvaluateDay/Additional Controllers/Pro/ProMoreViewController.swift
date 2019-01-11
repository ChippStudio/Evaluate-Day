//
//  ProMoreViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 18/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit

protocol ProMoreViewControllerStyle {
    var proMoreViewControllerCoverColor: UIColor { get }
    var proMoreViewControllerCoverAlpha: CGFloat { get }
    var proMoreViewControllerButtonsCover: UIColor { get }
    var proMoreViewControllerButtonsFont: UIFont { get }
    var proMoreViewControllerButtonsColor: UIColor { get }
}

class ProMoreViewController: UIViewController, ASTableDataSource, ASTableDelegate {

    // MARK: - UI
    var tableNode: ASTableNode!
    @IBOutlet weak var cover: UIView!
    @IBOutlet weak var annualyButtonCover: UIView!
    @IBOutlet weak var annualyButton: UIButton!
    
    // MARK: - Variables
    var items = [(image: UIImage, title: String, subtitle: String)]()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = Localizations.Settings.Pro.Description.More.title
        
        // Set items
        self.items.append((image: #imageLiteral(resourceName: "passcode"), title: Localizations.Settings.Pro.Description.More.Passcode.title, subtitle: Localizations.Settings.Pro.Description.More.Passcode.description))
        self.items.append((image: #imageLiteral(resourceName: "listB"), title: Localizations.Settings.Pro.Description.More.Cards.title, subtitle: Localizations.Settings.Pro.Description.More.Cards.description))
        self.items.append((image: #imageLiteral(resourceName: "analyticsB"), title: Localizations.Settings.Pro.Description.More.Analytics.title, subtitle: Localizations.Settings.Pro.Description.More.Analytics.description))
        self.items.append((image: #imageLiteral(resourceName: "activityB"), title: Localizations.Settings.Pro.Description.More.Activity.title, subtitle: Localizations.Settings.Pro.Description.More.Activity.description))
        self.items.append((image: #imageLiteral(resourceName: "sync"), title: Localizations.Settings.Pro.Description.More.Sync.title, subtitle: Localizations.Settings.Pro.Description.More.Sync.description))
        self.items.append((image: #imageLiteral(resourceName: "themes"), title: Localizations.Settings.Pro.Description.More.Themes.title, subtitle: Localizations.Settings.Pro.Description.More.Themes.description))
        self.items.append((image: #imageLiteral(resourceName: "export"), title: Localizations.Settings.Pro.Description.More.Export.title, subtitle: Localizations.Settings.Pro.Description.More.Export.description))
        self.items.append((image: #imageLiteral(resourceName: "sandClockB"), title: Localizations.Settings.Pro.Description.More.Past.title, subtitle: Localizations.Settings.Pro.Description.More.Past.description))
        self.items.append((image: #imageLiteral(resourceName: "app"), title: Localizations.Settings.Pro.Description.More.Future.title, subtitle: Localizations.Settings.Pro.Description.More.Future.description))
        
        // Button
        self.annualyButtonCover.layer.masksToBounds = true
        self.annualyButtonCover.layer.cornerRadius = 5.0
        
        self.annualyButton.setTitle(Localizations.Settings.Pro.Subscription.Buy.annualy(Store.current.localizedAnnualyPrice), for: .normal)
        
        // set table node
        self.tableNode = ASTableNode(style: .plain)
        self.tableNode.dataSource = self
        self.tableNode.delegate = self
        self.tableNode.view.separatorStyle = .none
        self.tableNode.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 164.0, right: 0.0)
        self.view.insertSubview(self.tableNode.view, at: 0)
        
        // Analytics
        sendEvent(.openProMore, withProperties: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self.view.traitCollection.userInterfaceIdiom == .pad && self.view.frame.size.width >= maxCollectionWidth {
            self.tableNode.frame = CGRect(x: self.view.frame.size.width / 2 - maxCollectionWidth / 2, y: 0.0, width: maxCollectionWidth, height: self.view.frame.size.height)
        } else {
            self.tableNode.frame = self.view.bounds
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.observable()
    }
    
    // MARK: - ASTableDataSource
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let item = self.items[indexPath.row]
        return {
            let node = SettingsProDescriptionMoreNode(image: item.image, title: item.title, subtitle: item.subtitle, style: Themes.manager.settingsStyle)
            if indexPath.row % 2 == 0 {
                node.backView.backgroundColor = UIColor.white
            }
            return node
        }
    }
    
    // MARK: - Actions
    @IBAction func subscriptionButtonAction(_ sender: UIButton) {
        self.showLoadView()
        Store.current.payment(product: Store.current.annualy, completion: { (_, error) in
            if error != nil {
                print(error!.localizedDescription)
                self.hideLoadView()
                return
            }
            // Success Payment
            self.hideLoadView()
            (UIApplication.shared.delegate as! AppDelegate).syncEngine.startSync()
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    // MARK: - Private actions
    // MARK: - Load view acctions
    private var evaluateLoadView: LoadView!
    func showLoadView() {
        if self.evaluateLoadView != nil {
            return
        }
        
        self.evaluateLoadView = LoadView(full: true, style: Themes.manager.activityControlerStyle)
        self.evaluateLoadView.alpha = 0.0
        
        self.view.addSubview(self.evaluateLoadView)
        self.evaluateLoadView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            self.evaluateLoadView.alpha = 1.0
        }) { (_) in
            self.evaluateLoadView.startAnimation()
        }
    }
    
    func hideLoadView() {
        if self.evaluateLoadView == nil {
            return
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.evaluateLoadView.alpha = 0.0
        }) { (_) in
            self.evaluateLoadView.removeFromSuperview()
            self.evaluateLoadView.stopAnimation()
            self.evaluateLoadView = nil
        }
    }
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
            
            // Set buttons
            self.cover.backgroundColor = style.proMoreViewControllerCoverColor
            self.cover.alpha = style.proMoreViewControllerCoverAlpha
            
            self.annualyButtonCover.backgroundColor = style.proMoreViewControllerButtonsCover
            
            self.annualyButton.setTitleColor(style.proMoreViewControllerButtonsColor, for: .normal)
            
            self.annualyButton.titleLabel?.font = style.proMoreViewControllerButtonsFont
            
            // Backgrounds
            self.view.backgroundColor = style.background
            self.tableNode.backgroundColor = style.background
            
            // Table node
            self.tableNode.reloadData()
        })
    }
}
