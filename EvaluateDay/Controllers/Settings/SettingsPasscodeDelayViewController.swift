//
//  SettingsPasscodeDelayViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class SettingsPasscodeDelayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var require = [PasscodeDelay]()
    
    private var delayCell = "delayCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NAvigation Controller
        self.navigationItem.title = Localizations.Settings.Passcode.require
        
        // set data
        self.require.append(.immediately)
        self.require.append(.one)
        self.require.append(.three)
        self.require.append(.five)
        self.require.append(.ten)
        self.require.append(.thirty)
        self.require.append(.hour)
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
        return self.require.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = self.require[indexPath.row]
        var requireString = ""
        switch item {
        case .immediately:
            requireString = Localizations.Settings.Passcode.Delay.immediately
        case .one:
            requireString = Localizations.Settings.Passcode.Delay._1m
        case .hour:
            requireString = Localizations.Settings.Passcode.Delay._1h
        default:
            requireString = Localizations.Settings.Passcode.Delay.minutes("\(item.rawValue)")
        }
        
        let selView = UIView()
        selView.backgroundColor = UIColor.tint
        selView.layer.cornerRadius = 5.0
        
        let cell = tableView.dequeueReusableCell(withIdentifier: delayCell, for: indexPath)
        cell.textLabel?.text = requireString
        cell.selectedBackgroundView = selView
        cell.imageView?.image = Images.Media.done.image.resizedImage(newSize: CGSize(width: 26.0, height: 26.0)).withRenderingMode(.alwaysTemplate)
        if item == Database.manager.application.settings.passcodeDelay {
            cell.imageView?.tintColor = UIColor.main
        } else {
            cell.imageView?.tintColor = UIColor.background
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let oldIndexPath = IndexPath(row: self.require.index(of: Database.manager.application.settings.passcodeDelay)!, section: 0)
        
        try! Database.manager.app.write {
            Database.manager.application.settings.passcodeDelay = self.require[indexPath.row]
        }
        
        self.tableView.reloadRows(at: [indexPath, oldIndexPath], with: .fade)
        
        sendEvent(.setPasscodeDelay, withProperties: ["duration": self.require[indexPath.row].rawValue])
    }
}
