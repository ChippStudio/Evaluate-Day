//
//  SplitController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class SplitController: UniversalSplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black
        self.insertMainViewController(UIStoryboard(name: Storyboards.collection.rawValue, bundle: nil).instantiateInitialViewController() as! UINavigationController)
    }
}
