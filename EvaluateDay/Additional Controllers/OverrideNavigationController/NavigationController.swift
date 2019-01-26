//
//  NavigationController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 26/01/2019.
//  Copyright © 2019 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if UserDefaults.standard.bool(forKey: Theme.darkMode.rawValue) {
            return UIStatusBarStyle.lightContent
        }
        return UIStatusBarStyle.default
    }
}
