//
//  MainNavigationViewController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 28/08/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class MainNavigationViewController: UINavigationController {

    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateAppearance(animated: false)
    }
    
    override func updateAppearance(animated: Bool) {
        super.updateAppearance(animated: animated)
        self.view.backgroundColor = UIColor.background
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if UserDefaults.standard.bool(forKey: Theme.darkMode.rawValue) {
            return UIStatusBarStyle.lightContent
        }
        return UIStatusBarStyle.default
    }
}
