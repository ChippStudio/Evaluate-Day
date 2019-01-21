//
//  ProViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 19/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import SafariServices

class ProViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    private let subscribeToProCell = "subscribeToProCell"
    private let subscriptionReviewCell = "subscriptionReviewCell"
    
    private let showDetailSegue = "showDetailSegue"

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation item
        self.navigationItem.title = Localizations.Settings.Pro.title
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
            self.navigationController?.view.backgroundColor = UIColor.background
            self.navigationController?.navigationBar.isTranslucent = false
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.tintColor = UIColor.main
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            
            // TableView
            self.tableView.backgroundColor = UIColor.background
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if Store.current.isPro {
            let cell = tableView.dequeueReusableCell(withIdentifier: subscriptionReviewCell, for: indexPath) as! SubscriptionReviewCell
            cell.privacyButton.addTarget(self, action: #selector(self.openPrivacy(sender:)), for: .touchUpInside)
            cell.eulaButton.addTarget(self, action: #selector(self.openEULA(sender:)), for: .touchUpInside)
            cell.manageButton.addTarget(self, action: #selector(self.manageSubscriptions(sender:)), for: .touchUpInside)
            
            let selectedView = UIView()
            selectedView.backgroundColor = UIColor.tint
            
            cell.selectedBackgroundView = selectedView
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: subscribeToProCell, for: indexPath) as! SubscriptionBuyCell
        cell.privacyButton.addTarget(self, action: #selector(self.openPrivacy(sender:)), for: .touchUpInside)
        cell.eulaButton.addTarget(self, action: #selector(self.openEULA(sender:)), for: .touchUpInside)
        cell.continueButton.addTarget(self, action: #selector(self.continuePurchaseAction(sender:)), for: .touchUpInside)
        cell.restoreButton.addTarget(self, action: #selector(self.restorePurchasesAction(sender:)), for: .touchUpInside)
        cell.oneTimeButton.addTarget(self, action: #selector(self.oneTimePurchaseAction(sender:)), for: .touchUpInside)
        cell.viewMoreButton.addTarget(self, action: #selector(self.readMoreAction(sender:)), for: .touchUpInside)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if Store.current.isPro {
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
    }
    
    // MARK: - Actions
    @objc func openPrivacy(sender: UIButton) {
        let safari = SFSafariViewController(url: URL(string: privacyURLString)!)
        self.present(safari, animated: true, completion: nil)
    }
    
    @objc func openEULA(sender: UIButton) {
        let safari = SFSafariViewController(url: URL(string: eulaURLString)!)
        self.present(safari, animated: true, completion: nil)
    }
    
    @objc func readMoreAction(sender: UIButton) {
        self.performSegue(withIdentifier: showDetailSegue, sender: self)
    }
    
    @objc func continuePurchaseAction(sender: UIButton) {
        if let cell = self.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SubscriptionBuyCell {
            self.showLoadView()
            let product = cell.isTopSelected ? Store.current.annualy : Store.current.mouthly
            Store.current.payment(product: product) { (transaction, error) in
                self.hideLoadView()
            }
        }
    }
    
    @objc func restorePurchasesAction(sender: UIButton) {
        self.showLoadView()
        Store.current.restore { (transactions, error) in
            self.hideLoadView()
        }
    }
    
    @objc func oneTimePurchaseAction(sender: UIButton) {
        self.showLoadView()
        Store.current.payment(product: Store.current.lifetime) { (transaction, error) in
            self.hideLoadView()
        }
    }
    
    @objc func manageSubscriptions(sender: UIButton) {
        if let url = URL(string: subscriptionManageURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Private Actions
    private var loadCoverView: UIView!
    private var loadIndicatorView: UIActivityIndicatorView!
    private func showLoadView() {
        self.loadCoverView = UIView()
        self.loadCoverView.backgroundColor = UIColor.background
        self.loadCoverView.alpha = 0.0
        
        self.loadIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.loadIndicatorView.alpha = 0.0
        self.loadIndicatorView.startAnimating()
        
        self.view.addSubview(self.loadCoverView)
        self.loadCoverView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        self.view.addSubview(self.loadIndicatorView)
        self.loadIndicatorView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3) {
            self.loadCoverView.alpha = 0.6
            self.loadIndicatorView.alpha = 1.0
        }
    }
    
    private func hideLoadView() {
        
        self.loadIndicatorView.stopAnimating()
        UIView.animate(withDuration: 0.3) {
            self.loadCoverView.alpha = 0.0
            self.loadIndicatorView.alpha = 0.0
        }
        
        self.loadCoverView.removeFromSuperview()
        self.loadIndicatorView.removeFromSuperview()
    }
}
