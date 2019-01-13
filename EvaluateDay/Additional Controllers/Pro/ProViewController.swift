//
//  ProViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 04/12/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import MessageUI
import SafariServices
import SwiftKeychainWrapper

class ProViewController: UIViewController, ASTableDataSource, ASTableDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, SFSafariViewControllerDelegate {
    
    // MARK: - UI
    var tableNode: ASTableNode!
    
    // MARK: - Variable
    var priceString = "..." {
        didSet {
            let indexPath = IndexPath(row: 0, section: 1)
            self.tableNode.reloadRows(at: [indexPath], with: .fade)
        }
    }
    var price: NSDecimalNumber!
    private let proMoreViewController = "proMoreViewController"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation item
        self.navigationItem.title = Localizations.Settings.Pro.title.uppercased()
        
        // Set table node
        self.tableNode = ASTableNode(style: .grouped)
        self.tableNode.view.separatorStyle = .none
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        self.view.addSubnode(self.tableNode)
        
        // Analytics
        if Store.current.isPro {
            sendEvent(.openProReview, withProperties: nil)
        } else {
            sendEvent(.openPro, withProperties: nil)
        }
        
        // Feedback
        Feedback.player.play(sound: .openPro, hapticFeedback: true)
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
        self.updateAppearance(animated: false)
    }
    
    override func updateAppearance(animated: Bool) {
        super.updateAppearance(animated: animated)
        
        let duration: TimeInterval = animated ? 0.2 : 0
        UIView.animate(withDuration: duration) {
            //set NavigationBar
            self.navigationController?.view.backgroundColor = UIColor.background
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = UIColor.main
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            self.tableNode.backgroundColor = UIColor.background
            
            // Table node
            self.tableNode.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - ASTableDataSource
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        if Database.manager.application.user.pro {
            return 2
        }
        
        return 4
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if Database.manager.application.user.pro {
            if section == 0 {
                if KeychainWrapper.standard.integer(forKey: keychainProStart) != nil {
                    return 1
                }
                return 2
            }
            
            return 1
        }
        if section == 1 {
            return 9
        }
        
        if section == 2 {
            return 2
        }
        
        return 1
    }
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        
        let style = Themes.manager.settingsStyle
        
        if Store.current.isPro {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    var subscripition = true
                    if KeychainWrapper.standard.integer(forKey: keychainProStart) != nil {
                       subscripition = false
                    }
                    let selView = UIView()
                    selView.backgroundColor = UIColor.tint
                    return {
                        let node = SettingsProReviewNode(subscribe: subscripition)
                        node.selectedBackgroundView = selView
                        return node
                    }
                } else {
                    return {
                        let node = SettingsProButtonNode(title: Localizations.Settings.Pro.Subscription.manage)
                        return node
                    }
                }
            } else {
                return {
                    let node = PrivacyAndEulaNode()
                    node.selectionStyle = .none
                    node.privacySelected = { () in
                        self.openURL(privacyURLString)
                    }
                    node.eulaSelected = { () in
                        self.openURL(eulaURLString)
                    }
                    return node
                }
            }
        }
        
        if indexPath.section == 0 {
            return {
                let node = SettingsProDescriptionNode(style: style)
                node.selectionStyle = .none
                node.moreDidSelected = { () in
                    let controller = UIStoryboard(name: Storyboards.pro.rawValue, bundle: nil).instantiateViewController(withIdentifier: self.proMoreViewController)
                    self.navigationController?.pushViewController(controller, animated: true)
                }
                return node
            }
        }
        
        if indexPath.section == 1 {
            
            switch indexPath.row {
            case 0:
                return {
                    let node = InfoNode(title: Localizations.Settings.Pro.Subscription.Title.anuualy, style: style)
                    node.topInset = 20.0
                    node.infoSelected = { () in
                        let controller = UIStoryboard(name: Storyboards.web.rawValue, bundle: nil).instantiateInitialViewController() as! UINavigationController
                        let topController = controller.topViewController as! WebViewController
                        topController.html = Bundle.main.path(forResource: "annualy", ofType: "html")
                        self.present(controller, animated: true, completion: nil)
                    }
                    return node
                }
            case 1:
                return {
                    let node = SettingsProButtonNode(title: Localizations.Settings.Pro.Subscription.Buy.annualy(Store.current.localizedAnnualyPrice))
                    node.selectionStyle = .none
                    node.cover.backgroundColor = UIColor.squash
                    return node
                }
            case 2:
                if #available(iOS 11.2, *) {
                    return {
                        let node = DescriptionNode(text: Store.current.annualy.introductory, alignment: .center, style: style)
                        return node
                    }
                } else {
                    // Fallback on earlier versions
                    // Without introductory price
                    return {
                        return DescriptionNode(text: "", alignment: .center, style: style)
                    }
                }
            case 3:
                return {
                    let node = InfoNode(title: Localizations.Settings.Pro.Subscription.Title.monthly, style: style)
                    node.infoSelected = { () in
                        let controller = UIStoryboard(name: Storyboards.web.rawValue, bundle: nil).instantiateInitialViewController() as! UINavigationController
                        let topController = controller.topViewController as! WebViewController
                        topController.html = Bundle.main.path(forResource: "monthly", ofType: "html")
                        self.present(controller, animated: true, completion: nil)
                    }
                    return node
                }
            case 4:
                return {
                    let node = SettingsProButtonNode(title: Localizations.Settings.Pro.Subscription.Buy.monthly(Store.current.localizedMonthlyPrice))
                    node.selectionStyle = .none
                    return node
                }
            case 5:
                if #available(iOS 11.2, *) {
                    return {
                        let node = DescriptionNode(text: Store.current.mouthly.introductory, alignment: .center, style: style)
                        return node
                    }
                } else {
                    // Fallback on earlier versions
                    // Without introductory price
                    return {
                        let node = DescriptionNode(text: "", alignment: .center, style: style)
                        return node
                    }
                }
            case 6:
                return {
                    let node = SettingsProButtonNode(title: Localizations.Settings.Pro.Subscription.Buy.lifetime(Store.current.localizedLifetimePrice))
                    node.selectionStyle = .none
                    return node
                }
            case 7:
                return {
                    let node = DescriptionNode(text: Localizations.Settings.Pro.Subscription.Description.cancel, alignment: .left, style: style)
                    node.topInset = 30.0
                    return node
                }
            case 8:
                return {
                    let node = DescriptionNode(text: Localizations.Settings.Pro.Subscription.Description.iTunes, alignment: .left, style: style)
                    node.topInset = 20.0
                    return node
                }
            default:
                return {
                    return ASCellNode()
                }
            }
        }
        
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                return {
                    let node = SettingsProButtonNode(title: Localizations.Settings.Pro.questions)
                    node.selectionStyle = .none
                    return node
                }
            }
            
            return {
                let node = SettingsProButtonNode(title: Localizations.Settings.Pro.restore)
                node.selectionStyle = .none
                return node
            }
        }
    
        return {
            let node = PrivacyAndEulaNode()
            node.selectionStyle = .none
            node.privacySelected = { () in
                self.openURL(privacyURLString)
            }
            node.eulaSelected = { () in
                self.openURL(eulaURLString)
            }
            return node
        }
    }
    
    // MARK: - ASTableDelegate
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        
        if Store.current.isPro {
            if indexPath.section == 0 {
                if indexPath.row == 0 {
                    let controller = UIStoryboard(name: Storyboards.web.rawValue, bundle: nil).instantiateInitialViewController() as! UINavigationController
                    let topController = controller.topViewController as! WebViewController
                    if Store.current.subscriptionID == Store.current.monthlyProductID {
                        topController.html = Bundle.main.path(forResource: "monthly", ofType: "html")
                        self.present(controller, animated: true, completion: nil)
                    } else if Store.current.subscriptionID == Store.current.annuallyProductID {
                        topController.html = Bundle.main.path(forResource: "annualy", ofType: "html")
                        self.present(controller, animated: true, completion: nil)
                    }
                }
                if indexPath.row == 1 {
                    if let url = URL(string: subscriptionManageURL) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                return
            }
        }
        
        if indexPath.section == 1 {
            // Make Payment
            if indexPath.row == 6 {
                //Lifetime
                self.showLoadView()
                Store.current.payment(product: Store.current.lifetime, completion: { (_, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        self.hideLoadView()
                        return
                    }
                    // Success Payment
                    self.hideLoadView()
                    (UIApplication.shared.delegate as! AppDelegate).syncEngine.startSync()
                    self.tableNode.reloadData()
                })
            }
            if indexPath.row == 4 {
                // Mouthly
                self.showLoadView()
                Store.current.payment(product: Store.current.mouthly, completion: { (_, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        self.hideLoadView()
                        return
                    }
                    // Success Payment
                    self.hideLoadView()
                    (UIApplication.shared.delegate as! AppDelegate).syncEngine.startSync()
                    self.tableNode.reloadData()
                })
            } else if indexPath.row == 1 {
                // Annualy
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
                    self.tableNode.reloadData()
                })
            }
        } else if indexPath.section == 2 {
            if indexPath.row == 0 {
                if MFMailComposeViewController.canSendMail() {
                    let mailView = MFMailComposeViewController()
                    mailView.mailComposeDelegate = self
                    mailView.navigationBar.tintColor = Themes.manager.settingsStyle.safariTintColor
                    mailView.setSubject(Localizations.Settings.Support.Mail.subject + "Pro")
                    var pro = 0
                    if Database.manager.application.user.pro {
                        pro = 1
                    }
                    let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String + "(\(pro))"
                    let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
                    let iosVersion = UIDevice.current.systemVersion
                    mailView.setMessageBody(Localizations.Settings.Support.Mail.body(build, version, iosVersion), isHTML: false)
                    mailView.setToRecipients([feedbackMail])
                    self.present(mailView, animated: true, completion: {
                    })
                } else {
                    let alert = UIAlertController(title: Localizations.Settings.Support.MailError.title, message: Localizations.Settings.Support.MailError.message, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: Localizations.General.ok, style: .default, handler: nil)
                    alert.addAction(okAction)
                    
                    alert.view.tintColor = Themes.manager.settingsStyle.safariTintColor
                    alert.view.layoutIfNeeded()
                    self.present(alert, animated: true) {
                        alert.view.tintColor = Themes.manager.settingsStyle.safariTintColor
                    }
                }
            } else if indexPath.row == 1 {
                // Restore all transactions
                Store.current.restore(completion: { (_, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    self.tableNode.reloadData()
                })
            }
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Swift.Error?) {
        if error != nil {
            print(error!.localizedDescription)
        }
        controller.dismiss(animated: true, completion: nil)
    }
    // MARK: - SFSafariViewControllerDelegate
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    }
    
    // MARK: - Actions
    @objc func closeButtonAction(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func openURL(_ url: String) {
        let safari = SFSafariViewController(url: URL(string: url)!)
        safari.preferredControlTintColor = Themes.manager.settingsStyle.safariTintColor
        safari.delegate = self
        self.present(safari, animated: true, completion: nil)
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
}
