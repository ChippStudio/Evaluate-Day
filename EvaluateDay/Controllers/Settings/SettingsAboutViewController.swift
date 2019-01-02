//
//  SettingsAboutViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 27/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit
import SafariServices
import Branch

let settingsAboutViewControllerID = "settingsAboutViewController"

class SettingsAboutViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate {
    
    // MARK: - Outlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var madeLabel: UILabel!
    @IBOutlet weak var footerView: UIView!
    
    // MARK: - Cells
    fileprivate let topTitleCellID = "topTitleCell"
    fileprivate let socialCellID = "socialCell"
    fileprivate let menuCellID = "menuCell"
    fileprivate let shareCellID = "shareCell"
    fileprivate let logoCellID = "logoCell"
    fileprivate let detailsCellID = "detailsCell"
    fileprivate let specialThanksCellID = "specialThanksCell"
    
    // MARK: - Private    
    fileprivate var isShowThanks = false
    fileprivate var specialThanks = [SpecialThanks]()
    
    fileprivate var isShowLegals = false
    fileprivate var legals = [Legal]()
    
    fileprivate var isShowOpenSources = false
    fileprivate var openSource = [OpenSource]()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation bar
        self.navigationItem.title = Localizations.settings.about.title
        
        //set open sources libraries
        self.openSource.append(OpenSource(title: "SnapKit", URL: "https://github.com/SnapKit/SnapKit"))
        self.openSource.append(OpenSource(title: "Realm", URL: "https://realm.io"))
        self.openSource.append(OpenSource(title: "RxSwift", URL: "https://github.com/ReactiveX/RxSwift"))
        self.openSource.append(OpenSource(title: "Texture", URL: "http://texturegroup.org/"))
        self.openSource.append(OpenSource(title: "SwiftyJSON", URL: "https://github.com/SwiftyJSON/SwiftyJSON"))
        self.openSource.append(OpenSource(title: "Alamofire", URL: "https://github.com/Alamofire/Alamofire"))
        self.openSource.append(OpenSource(title: "Amplitude-iOS", URL: "https://amplitude.com"))
        self.openSource.append(OpenSource(title: "FSCalendar", URL: "https://github.com/WenchaoD/FSCalendar"))
        self.openSource.append(OpenSource(title: "IGListKit", URL: "https://github.com/Instagram/IGListKit"))
        self.openSource.append(OpenSource(title: "Charts", URL: "https://github.com/danielgindi/Charts"))
        self.openSource.append(OpenSource(title: "SwiftKeychainWrapper", URL: "https://github.com/jrendel/SwiftKeychainWrapper"))
        self.openSource.append(OpenSource(title: "YandexMobileMetrica", URL: "https://appmetrica.yandex.com"))
        self.openSource.append(OpenSource(title: "Facebook SDK", URL: "https://developers.facebook.com/"))
        self.openSource.append(OpenSource(title: "Branch", URL: "https://branch.io"))
        
        //set legal
        self.legals.append(Legal(title: Localizations.settings.about.legal.forecast, URL: "https://darksky.net"))
        
        //set special thanks
        
        //Table view
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80.0
        
        // Analytics
        sendEvent(.openAbout, withProperties: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.observable()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        case 1: return 1
        case 2: if isShowOpenSources {
            return openSource.count + 1
        }
        
        return 1
        case 3: if isShowLegals {
            return legals.count + 1
        }
        
        return 1
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let style = Themes.manager.settingsStyle
        switch indexPath.section {
        case 0: if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: topTitleCellID, for: indexPath) as! SettingsAboutTitleTableViewCell
            let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
            let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
            cell.title.text = Localizations.general.evaluateday
            cell.title.font = style.aboutAppTitleFont
            cell.title.textColor = style.aboutTintColor
            cell.subtitle.text = Localizations.general.version(value1: build, version)
            cell.subtitle.textColor = style.aboutTintColor
            cell.subtitle.font = style.aboutVersionFont
            cell.backgroundColor = style.background
            cell.contentView.backgroundColor = style.background
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: socialCellID, for: indexPath) as! SettingsAboutSocialTableViewCell
            cell.facebookButton.addTarget(self, action: #selector(socialButtonsAction(_: )), for: .touchUpInside)
            cell.facebookButton.backgroundColor = UIColor.white
            cell.facebookButton.layer.borderColor = style.aboutTintColor.cgColor
            
            cell.twitterButton.addTarget(self, action: #selector(socialButtonsAction(_: )), for: .touchUpInside)
            cell.twitterButton.backgroundColor = UIColor.white
            cell.twitterButton.layer.borderColor = style.aboutTintColor.cgColor
            
            cell.instagramButton.addTarget(self, action: #selector(socialButtonsAction(_: )), for: .touchUpInside)
            cell.instagramButton.backgroundColor = UIColor.white
            cell.instagramButton.layer.borderColor = style.aboutTintColor.cgColor
        
            cell.mailButton.addTarget(self, action: #selector(socialButtonsAction(_: )), for: .touchUpInside)
            cell.mailButton.backgroundColor = UIColor.white
            cell.mailButton.layer.borderColor = style.aboutTintColor.cgColor
            cell.backgroundColor = style.background
            cell.contentView.backgroundColor = style.background
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: shareCellID, for: indexPath) as! SettingsAboutShareTableViewCell
            cell.title.text = Localizations.settings.about.share.title
            cell.title.font = style.aboutShareFont
            cell.title.textColor = style.aboutTintColor
            
            cell.share.image = #imageLiteral(resourceName: "share").withRenderingMode(.alwaysTemplate)
            cell.share.tintColor = style.aboutTintColor
            
            cell.backgroundColor = style.background
            cell.contentView.backgroundColor = style.background
            
            cell.accessibilityTraits = UIAccessibilityTraitButton
            cell.accessibilityLabel = Localizations.settings.about.share.title
            return cell
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: menuCellID, for: indexPath)
            cell.textLabel?.text = Localizations.settings.about.rate
            cell.textLabel?.font = style.aboutSectionTitleFont
            cell.textLabel?.textColor = style.aboutTintColor
            cell.backgroundColor = style.background
            cell.contentView.backgroundColor = style.background
            return cell
        case 2: if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: menuCellID, for: indexPath)
            cell.textLabel?.text = Localizations.settings.about.openSource
            cell.textLabel?.font = style.aboutSectionTitleFont
            cell.textLabel?.textColor = style.aboutTintColor
            cell.backgroundColor = style.background
            cell.contentView.backgroundColor = style.background
            return cell
        } else {
            let source = self.openSource[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: detailsCellID, for: indexPath)
            cell.textLabel?.text = source.title
            cell.textLabel?.font = style.aboutInfoFont
            cell.textLabel?.textColor = style.aboutTintColor
            cell.backgroundColor = style.background
            cell.contentView.backgroundColor = style.background
            return cell
            }
        case 3: if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: menuCellID, for: indexPath)
            cell.textLabel?.text = Localizations.settings.about.legal.title
            cell.textLabel?.font = style.aboutSectionTitleFont
            cell.textLabel?.textColor = style.aboutTintColor
            cell.backgroundColor = style.background
            cell.contentView.backgroundColor = style.background
            return cell
        } else {
            let legal = self.legals[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: detailsCellID, for: indexPath)
            cell.textLabel?.text = legal.title
            cell.textLabel?.font = style.aboutInfoFont
            cell.textLabel?.textColor = style.aboutTintColor
            cell.backgroundColor = style.background
            cell.contentView.backgroundColor = style.background
            return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: logoCellID, for: indexPath) as! SettingsLogoTableViewCell
            cell.logo.image = #imageLiteral(resourceName: "Chipp-logo").withRenderingMode(.alwaysTemplate)
            cell.logo.tintColor = style.aboutLogoTint
            cell.backgroundColor = style.background
            cell.contentView.backgroundColor = style.background
            
            cell.accessibilityTraits = UIAccessibilityTraitButton
            cell.accessibilityLabel = "Chipp Studio"
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                sendEvent(.openEvaluateSite, withProperties: nil)
                self.openURL("http://evaluateday.com")
            }
            if indexPath.row == 2 {
                let hashTag = "#evaluateday"
                
                // Make universal Branch Link
                let linkObject = BranchUniversalObject(canonicalIdentifier: "appShare")
                linkObject.title = Localizations.share.link.title
                linkObject.contentDescription = Localizations.share.description
                
                let linkProperties = BranchLinkProperties()
                linkProperties.feature = "Application Share"
                linkProperties.channel = "Users"
                
                linkObject.getShortUrl(with: linkProperties) { (link, error) in
                    if error != nil && link == nil {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    let rect = tableView.convert(tableView.rectForRow(at: indexPath), to: tableView.superview)
                    let shareActivity = UIActivityViewController(activityItems: [link!, hashTag, Localizations.settings.about.share.message], applicationActivities: nil)
                    if self.traitCollection.userInterfaceIdiom == .pad {
                        shareActivity.modalPresentationStyle = UIModalPresentationStyle.popover
                        shareActivity.popoverPresentationController?.sourceView = self.view
                        shareActivity.popoverPresentationController?.sourceRect = rect
                    }
                    
                    sendEvent(.shareApp, withProperties: nil)
                    self.present(shareActivity, animated: true, completion: nil)
                }
                
            }
        case 1:
            let url = URL(string: appURLString)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            
        case 2: if indexPath.row == 0 {
            var indexPaths = [IndexPath]()
            for i in 1...openSource.count {
                indexPaths.append(IndexPath(row: i, section: indexPath.section))
            }
            if isShowOpenSources {
                self.isShowOpenSources = false
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: indexPaths, with: .middle)
                self.tableView.endUpdates()
            } else {
                self.isShowOpenSources = true
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: indexPaths, with: .middle)
                self.tableView.endUpdates()
            }
        } else {
            let source = self.openSource[indexPath.row - 1]
            sendEvent(.touchOpenSource, withProperties: ["source": source.title])
            self.openURL(source.URL)
            }
        case 3: if indexPath.row == 0 {
            var indexPaths = [IndexPath]()
            for i in 1...legals.count {
                indexPaths.append(IndexPath(row: i, section: indexPath.section))
            }
            if isShowLegals {
                self.isShowLegals = false
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: indexPaths, with: .middle)
                self.tableView.endUpdates()
            } else {
                self.isShowLegals = true
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: indexPaths, with: .middle)
                self.tableView.endUpdates()
            }
        } else {
            let legal = self.legals[indexPath.row - 1]
            sendEvent(.touchLegal, withProperties: ["legal": legal.title])
            self.openURL(legal.URL)
            }
        case 4:
            sendEvent(.openChipp, withProperties: nil)
            self.openURL("http://chippstudio.ee")
        default: ()
        }
    }
    
    // MARK: - SFSafariViewControllerDelegate
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    }
    
    // MARK: - Actions
    @objc func socialButtonsAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            sendEvent(.openEvaluateDaySocial, withProperties: ["social": "Facebook"])
            self.openURL("https://www.facebook.com/EvaluateDay-136725710039383")
        case 1:
            sendEvent(.openEvaluateDaySocial, withProperties: ["social": "Twitter"])
            self.openURL("https://twitter.com/ChippStudio")
        case 2:
            sendEvent(.openEvaluateDaySocial, withProperties: ["social": "Instagram"])
            self.openURL("https://www.instagram.com/evaluatedayapp")
        case 3:
            sendEvent(.openEvaluateDaySocial, withProperties: ["social": "Newsletter"])
            self.openURL("http://eepurl.com/cgbuvb")
        default: break
        }
    }
    
    func openURL(_ url: String) {
        let safari = SFSafariViewController(url: URL(string: url)!)
        safari.preferredControlTintColor = Themes.manager.settingsStyle.safariTintColor
        safari.delegate = self
        self.present(safari, animated: true, completion: nil)
    }
    
    // MARK: - in class sruct
    struct SpecialThanks {
        let imageName: String
        let name: String
        let email: String
        let description: String
    }
    
    struct OpenSource {
        let title: String
        let URL: String
    }
    
    struct Legal {
        let title: String
        let URL: String
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
            self.tableView.backgroundColor = style.background
            self.tableView.reloadData()
            
            // Made in
            self.madeLabel.textColor = style.aboutTintColor
            self.madeLabel.font = style.aboutMadeInFont
            self.footerView.backgroundColor = style.background
        })
    }
}
