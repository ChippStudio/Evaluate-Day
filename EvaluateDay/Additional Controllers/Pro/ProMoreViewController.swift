//
//  ProMoreViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 21/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class ProMoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var items = [(image: UIImage, title: String, subtitle: String)]()
    
    private let itemCell = "itemCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = Localizations.Settings.Pro.Description.More.title
        
        // Set items
        self.items.append((image: #imageLiteral(resourceName: "passcode"), title: Localizations.Settings.Pro.Description.More.Passcode.title, subtitle: Localizations.Settings.Pro.Description.More.Passcode.description))
        self.items.append((image: #imageLiteral(resourceName: "listB"), title: Localizations.Settings.Pro.Description.More.Cards.title, subtitle: Localizations.Settings.Pro.Description.More.Cards.description))
        self.items.append((image: #imageLiteral(resourceName: "sync"), title: Localizations.Settings.Pro.Description.More.Sync.title, subtitle: Localizations.Settings.Pro.Description.More.Sync.description))
        self.items.append((image: #imageLiteral(resourceName: "themes"), title: Localizations.Settings.Pro.Description.More.Themes.title, subtitle: Localizations.Settings.Pro.Description.More.Themes.description))
        self.items.append((image: #imageLiteral(resourceName: "export"), title: Localizations.Settings.Pro.Description.More.Export.title, subtitle: Localizations.Settings.Pro.Description.More.Export.description))
        self.items.append((image: #imageLiteral(resourceName: "sandClockB"), title: Localizations.Settings.Pro.Description.More.Past.title, subtitle: Localizations.Settings.Pro.Description.More.Past.description))
        self.items.append((image: #imageLiteral(resourceName: "app"), title: Localizations.Settings.Pro.Description.More.Future.title, subtitle: Localizations.Settings.Pro.Description.More.Future.description))
        
        sendEvent(Analytics.openProMore, withProperties: nil)
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
            
            // TableView
            self.tableView.backgroundColor = UIColor.background
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: itemCell, for: indexPath)
        cell.textLabel?.text = item.title
        cell.textLabel?.textColor = UIColor.text
        cell.detailTextLabel?.text = item.subtitle
        cell.detailTextLabel?.textColor = UIColor.main
        cell.imageView?.image = item.image.resizedImage(newSize: (CGSize(width: 30.0, height: 30.0))).withRenderingMode(.alwaysTemplate)
        cell.imageView?.tintColor = UIColor.main
        
        let selectedView = UIView()
        selectedView.backgroundColor = UIColor.tint
        selectedView.layer.cornerRadius = 10.0
        
        cell.selectedBackgroundView = selectedView
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
}
