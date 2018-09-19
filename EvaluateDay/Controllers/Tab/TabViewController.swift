//
//  TabViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 28/06/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let evaluateDay = UIStoryboard(name: Storyboards.evaluate.rawValue, bundle: nil).instantiateInitialViewController()!
        evaluateDay.tabBarItem.image = #imageLiteral(resourceName: "appIcon").resizedImage(newSize: CGSize(width: 24.0, height: 24.0))
        evaluateDay.tabBarItem.title = Localizations.tabbar.evaluate
        evaluateDay.tabBarItem.accessibilityIdentifier = "evaluate"
        
        let activity = UIStoryboard(name: Storyboards.activity.rawValue, bundle: nil).instantiateInitialViewController()!
        activity.tabBarItem.image = #imageLiteral(resourceName: "user").resizedImage(newSize: CGSize(width: 24.0, height: 24.0))
        activity.tabBarItem.title = Localizations.tabbar.activity
        activity.tabBarItem.accessibilityIdentifier = "activity"
        
        var settings: UIViewController
        if (UIApplication.shared.delegate as! AppDelegate).window?.traitCollection.userInterfaceIdiom == .phone {
            settings = UIStoryboard(name: Storyboards.settings.rawValue, bundle: nil).instantiateInitialViewController()!
        } else {
            settings = UIStoryboard(name: Storyboards.settingsSplit.rawValue, bundle: nil).instantiateInitialViewController()!
        }
        settings.tabBarItem.image = #imageLiteral(resourceName: "settings").resizedImage(newSize: CGSize(width: 24.0, height: 24.0))
        settings.tabBarItem.title = Localizations.tabbar.settings
        settings.tabBarItem.accessibilityIdentifier = "settings"
        
        self.viewControllers = [evaluateDay, activity, settings]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.observable()
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private
    private func observable() {
        _ = Themes.manager.changeTheme.asObservable().subscribe({ (_) in
            let style = Themes.manager.tabControlerStyle
            self.view.backgroundColor = style.background
            // TabBar
            self.tabBar.unselectedItemTintColor = style.tabTintColor
            self.tabBar.tintColor = style.tabSelectedColor
            self.tabBar.barTintColor = style.background
        })
    }
}
