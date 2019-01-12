//
//  SettingsWeekViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 27/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class SettingsWeekViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    private let weekCell = "weekCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()

        // Navigation bar
        self.navigationItem.title = Localizations.Settings.General.week
        
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
        return Locale.current.calendar.standaloneWeekdaySymbols.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selView = UIView()
        selView.backgroundColor = UIColor.tint
        selView.layer.cornerRadius = 5.0
        
        let cell = tableView.dequeueReusableCell(withIdentifier: weekCell, for: indexPath)
        cell.textLabel?.text = Locale.current.calendar.standaloneWeekdaySymbols[indexPath.row]
        cell.selectedBackgroundView = selView
        cell.imageView?.image = Images.Media.done.image.resizedImage(newSize: CGSize(width: 26.0, height: 26.0)).withRenderingMode(.alwaysTemplate)
        let selectedIndex = Database.manager.application.settings.weekStart
        if indexPath.row == selectedIndex - 1 {
            cell.imageView?.tintColor = UIColor.main
        } else {
            cell.imageView?.tintColor = UIColor.background
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let oldIndexPath = IndexPath(row: Database.manager.application.settings.weekStart - 1, section: 0)
        
        try! Database.manager.app.write {
            Database.manager.application.settings.weekStart = indexPath.row + 1
        }
        
        self.tableView.reloadRows(at: [indexPath, oldIndexPath], with: .fade)
        
        sendEvent(.setWeekStart, withProperties: ["day": Locale.current.calendar.standaloneWeekdaySymbols[indexPath.row]])
    }
}
