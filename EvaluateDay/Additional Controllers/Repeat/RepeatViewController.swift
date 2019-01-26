//
//  RepeatViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 30/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class RepeatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - UI
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variable
    var didSetNewRepeatInterval: (() -> Void)?
    var notification: LocalNotification! {
        didSet {
            self.weekdays.removeAll()
            for w in notification.repeatNotification {
                if w == "1" {
                    self.weekdays.append(true)
                } else {
                    self.weekdays.append(false)
                }
            }
        }
    }
    private var weekdays = [Bool]()
    private let repeatCell = "repeatCell"
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = Localizations.Settings.Notifications.New.Repeat.title
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
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.text]
            if #available(iOS 11.0, *) {
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.text]
            }
            
            // Backgrounds
            self.view.backgroundColor = UIColor.background
            
            // TableView
            self.tableView.backgroundColor = UIColor.background
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        var weekdaysMask = ""
        for w in self.weekdays {
            if w {
                weekdaysMask += "1"
            } else {
                weekdaysMask += "0"
            }
        }
        
        if self.notification.realm == nil {
            self.notification.repeatNotification = weekdaysMask
        } else {
            try! Database.manager.app.write {
                self.notification.repeatNotification = weekdaysMask
            }
        }
        
        self.didSetNewRepeatInterval?()
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let selView = UIView()
        selView.backgroundColor = UIColor.tint
        selView.layer.cornerRadius = 5.0
        
        let cell = tableView.dequeueReusableCell(withIdentifier: repeatCell, for: indexPath)
        cell.textLabel?.text = Locale.current.calendar.standaloneWeekdaySymbols[indexPath.row]
        cell.textLabel?.textColor = UIColor.text
        cell.selectedBackgroundView = selView
        cell.imageView?.image = Images.Media.done.image.resizedImage(newSize: CGSize(width: 26.0, height: 26.0)).withRenderingMode(.alwaysTemplate)
        if self.weekdays[indexPath.row] {
            cell.imageView?.tintColor = UIColor.main
        } else {
            cell.imageView?.tintColor = UIColor.background
        }
        
        return cell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let temp = self.weekdays[indexPath.row]
            self.weekdays.remove(at: indexPath.row)
            self.weekdays.insert(!temp, at: indexPath.row)
        }
        
        self.tableView.reloadSections([0], with: .fade)
    }
}
