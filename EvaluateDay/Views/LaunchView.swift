//
//  LaunchView.swift
//  EvaluateDay
//
//  Created by Konstantin Tsistjakov on 14/11/2017.
//  Copyright © 2017 Konstantin Tsistjakov. All rights reserved.
//

import UIKit

class LaunchView: UIView {
    
    // MARK: - Init
    init() {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor.blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
