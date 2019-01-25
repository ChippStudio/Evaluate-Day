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
        self.navigationItem.title = Localizations.Settings.About.title
        
        //set open sources libraries
        self.openSource.append(OpenSource(title: "SnapKit", URL: "https://github.com/SnapKit/SnapKit"))
        self.openSource.append(OpenSource(title: "Realm", URL: "https://realm.io"))
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
        self.openSource.append(OpenSource(title: "Flurry-iOS", URL: "http://www.flurry.com"))
        self.openSource.append(OpenSource(title: "SwiftGen", URL: "https://github.com/SwiftGen/SwiftGen"))
        
        //set legal
        self.legals.append(Legal(title: Localizations.Settings.About.Legal.forecast, URL: "https://darksky.net"))
        
        //set special thanks
        
        //Table view
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80.0
        self.tableView.showsHorizontalScrollIndicator = false
        self.tableView.showsVerticalScrollIndicator = false
        
        // Analytics
        sendEvent(.openAbout, withProperties: nil)
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
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.text]
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.text]
            }
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            
            // TableView
            self.tableView.backgroundColor = UIColor.background
            self.tableView.reloadData()
            
            // Made in
            self.madeLabel.textColor = UIColor.text
            self.madeLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
            self.footerView.backgroundColor = UIColor.background
        }
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
        
        let selView = UIView()
        selView.layer.cornerRadius = 5.0
        selView.backgroundColor = UIColor.tint
        
        switch indexPath.section {
        case 0: if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: topTitleCellID, for: indexPath) as! SettingsAboutTitleTableViewCell
            let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
            let version = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
            cell.title.text = Localizations.General.evaluateday
            cell.title.font = UIFont.preferredFont(forTextStyle: .title1)
            cell.title.textColor = UIColor.text
            cell.subtitle.text = Localizations.General.version(build, version)
            cell.subtitle.textColor = UIColor.text
            cell.subtitle.font = UIFont.preferredFont(forTextStyle: .caption2)
            cell.backgroundColor = UIColor.background
            cell.contentView.backgroundColor = UIColor.background
            cell.selectedBackgroundView = selView
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: socialCellID, for: indexPath) as! SettingsAboutSocialTableViewCell
            cell.facebookButton.addTarget(self, action: #selector(socialButtonsAction(_: )), for: .touchUpInside)
            cell.facebookButton.backgroundColor = UIColor.white
            cell.facebookButton.layer.borderColor = UIColor.main.cgColor
            
            cell.linkedinButton.addTarget(self, action: #selector(socialButtonsAction(_: )), for: .touchUpInside)
            cell.linkedinButton.backgroundColor = UIColor.white
            cell.linkedinButton.layer.borderColor = UIColor.main.cgColor
            
            cell.instagramButton.addTarget(self, action: #selector(socialButtonsAction(_: )), for: .touchUpInside)
            cell.instagramButton.backgroundColor = UIColor.white
            cell.instagramButton.layer.borderColor = UIColor.main.cgColor
            
            cell.githubButton.addTarget(self, action: #selector(socialButtonsAction(_: )), for: .touchUpInside)
            cell.githubButton.backgroundColor = UIColor.white
            cell.githubButton.layer.borderColor = UIColor.main.cgColor
        
            cell.mailButton.addTarget(self, action: #selector(socialButtonsAction(_: )), for: .touchUpInside)
            cell.mailButton.backgroundColor = UIColor.white
            cell.mailButton.layer.borderColor = UIColor.main.cgColor
            
            cell.backgroundColor = UIColor.background
            cell.contentView.backgroundColor = UIColor.background
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: shareCellID, for: indexPath) as! SettingsAboutShareTableViewCell
            cell.title.text = Localizations.Settings.About.Share.title
            cell.title.font = UIFont.preferredFont(forTextStyle: .body)
            cell.title.textColor = UIColor.text
            
            cell.share.image = Images.Media.share.image.withRenderingMode(.alwaysTemplate)
            cell.share.tintColor = UIColor.main
            
            cell.backgroundColor = UIColor.background
            cell.contentView.backgroundColor = UIColor.background
            
            cell.selectedBackgroundView = selView
            
            cell.accessibilityTraits = UIAccessibilityTraitButton
            cell.accessibilityLabel = Localizations.Settings.About.Share.title
            return cell
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: menuCellID, for: indexPath)
            cell.textLabel?.text = Localizations.Settings.About.rate
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
            cell.textLabel?.textColor = UIColor.text
            cell.backgroundColor = UIColor.background
            cell.contentView.backgroundColor = UIColor.background
            cell.selectedBackgroundView = selView
            return cell
        case 2: if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: menuCellID, for: indexPath)
            cell.textLabel?.text = Localizations.Settings.About.openSource
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
            cell.textLabel?.textColor = UIColor.text
            cell.backgroundColor = UIColor.background
            cell.contentView.backgroundColor = UIColor.background
            cell.selectedBackgroundView = selView
            return cell
        } else {
            let source = self.openSource[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: detailsCellID, for: indexPath)
            cell.textLabel?.text = source.title
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            cell.textLabel?.textColor = UIColor.text
            cell.backgroundColor = UIColor.background
            cell.contentView.backgroundColor = UIColor.background
            cell.selectedBackgroundView = selView
            return cell
            }
        case 3: if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: menuCellID, for: indexPath)
            cell.textLabel?.text = Localizations.Settings.About.Legal.title
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
            cell.textLabel?.textColor = UIColor.text
            cell.backgroundColor = UIColor.background
            cell.contentView.backgroundColor = UIColor.background
            cell.selectedBackgroundView = selView
            return cell
        } else {
            let legal = self.legals[indexPath.row - 1]
            let cell = tableView.dequeueReusableCell(withIdentifier: detailsCellID, for: indexPath)
            cell.textLabel?.text = legal.title
            cell.textLabel?.font = UIFont.preferredFont(forTextStyle: .body)
            cell.textLabel?.textColor = UIColor.text
            cell.backgroundColor = UIColor.background
            cell.contentView.backgroundColor = UIColor.background
            cell.selectedBackgroundView = selView
            return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: logoCellID, for: indexPath) as! SettingsLogoTableViewCell
            cell.logo.image = Images.Media.chippLogo.image
            cell.backgroundColor = UIColor.background
            cell.contentView.backgroundColor = UIColor.background
            cell.selectedBackgroundView = selView
            
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
                linkObject.title = Localizations.Share.Link.title
                linkObject.contentDescription = Localizations.Share.description
                
                let linkProperties = BranchLinkProperties()
                linkProperties.feature = "Application Share"
                linkProperties.channel = "Users"
                
                linkObject.getShortUrl(with: linkProperties) { (link, error) in
                    if error != nil && link == nil {
                        print(error!.localizedDescription)
                        return
                    }
                    
                    let rect = tableView.convert(tableView.rectForRow(at: indexPath), to: tableView.superview)
                    let shareActivity = UIActivityViewController(activityItems: [link!, hashTag, Localizations.Settings.About.Share.message], applicationActivities: nil)
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
            self.openURL("https://facebook.com/chippstudio")
        case 1:
            sendEvent(.openEvaluateDaySocial, withProperties: ["social": "Instagram"])
            self.openURL("https://www.instagram.com/chippstudio/")
        case 2:
            sendEvent(.openEvaluateDaySocial, withProperties: ["social": "LinkedIn"])
            self.openURL("https://www.linkedin.com/company/chippstudio/")
        case 3:
            sendEvent(.openEvaluateDaySocial, withProperties: ["social": "GitHub"])
            self.openURL("https://github.com/ChippStudio")
        case 4:
            sendEvent(.openEvaluateDaySocial, withProperties: ["social": "Newsletter"])
            self.openURL("http://eepurl.com/cgbuvb")
        default: break
        }
    }
    
    func openURL(_ url: String) {
        let safari = SFSafariViewController(url: URL(string: url)!)
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
}
