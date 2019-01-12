//
//  SplitController.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 29/12/2018.
//  Copyright © 2018 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class SplitController: UniversalSplitViewController {

    var date: Date = Date()
    
    // MARK: - Override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.background
        self.separatorViewColor = UIColor.tint
        self.closeButtonImage = UIImage(named: "close")?.resizedImage(newSize: CGSize(width: 24.0, height: 24.0))
        self.insertMainViewController(UIStoryboard(name: Storyboards.collection.rawValue, bundle: nil).instantiateInitialViewController() as! UINavigationController)
    }
}
